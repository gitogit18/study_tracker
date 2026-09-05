import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/study_session.dart';
import '../models/subject.dart';

class StudyRepository extends ChangeNotifier {
  StudyRepository(this.uid, {FirebaseFirestore? firestore}) : _firestore = firestore {
    _init();
  }

  final String uid;
  FirebaseFirestore? _firestore;
  FirebaseFirestore get firestore => _firestore ??= FirebaseFirestore.instance;

  List<Subject> _subjects = [];
  List<StudySession> _sessions = [];
  Map<String, dynamic> _settings = {};

  StreamSubscription? _subjectsSub;
  StreamSubscription? _sessionsSub;
  StreamSubscription? _settingsSub;

  void _init() {
    _settingsSub = firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _settings = snapshot.data() ?? {};
        notifyListeners();
      }
    });

    _subjectsSub = firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .snapshots()
        .listen((snapshot) {
      _subjects = snapshot.docs
          .map((doc) => Subject.fromFirestore(doc.id, doc.data()))
          .toList();
      notifyListeners();
    });

    _sessionsSub = firestore
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .orderBy('startedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _sessions = snapshot.docs
          .map((doc) => StudySession.fromFirestore(doc.id, doc.data()))
          .toList();
      notifyListeners();
    });
  }

  List<Subject> get subjects => List.unmodifiable(_subjects);
  List<StudySession> get sessions => List.unmodifiable(_sessions);
  Map<String, dynamic> get settings => _settings;

  Future<void> updateDailyGoal(int minutes) async {
    final now = DateTime.now();
    final today = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    
    await firestore.collection('users').doc(uid).set({
      'dailyGoalMinutes': minutes,
      'lastGoalSetDate': today,
    }, SetOptions(merge: true));
  }

  Future<void> updateStreakData({
    required int currentStreak,
    required int longestStreak,
    required int freezesAvailable,
    required int successfulDaysCount,
    required List<String> freezeUsageDates,
  }) async {
    await firestore.collection('users').doc(uid).set({
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'freezesAvailable': freezesAvailable,
      'successfulDaysCount': successfulDaysCount,
      'freezeUsageDates': freezeUsageDates,
    }, SetOptions(merge: true));
  }

  Subject? subjectById(String id) {
    try {
      return _subjects.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addSubject(Subject subject) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .doc(subject.id.isEmpty ? null : subject.id)
        .set(subject.toFirestore());
  }

  Future<void> updateSubject(Subject subject) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .doc(subject.id)
        .update(subject.toFirestore());
  }

  Future<void> deleteSubject(String id) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .doc(id)
        .delete();
  }

  Future<void> addSession(StudySession session) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .add(session.toFirestore());
  }

  @override
  void dispose() {
    _subjectsSub?.cancel();
    _sessionsSub?.cancel();
    _settingsSub?.cancel();
    super.dispose();
  }
}
