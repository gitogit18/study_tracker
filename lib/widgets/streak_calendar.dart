import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../viewmodels/streak_view_model.dart';

class StreakCalendar extends StatefulWidget {
  const StreakCalendar({
    super.key,
    required this.dailyStatus,
    required this.onDateSelected,
  });

  final Map<DateTime, StreakStatus> dailyStatus;
  final Function(DateTime) onDateSelected;

  @override
  State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _getMonthName(_focusedMonth.month);
    final year = _focusedMonth.year;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$monthName $year',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.ink,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDaysOfWeek(),
        const SizedBox(height: 8),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildDaysOfWeek() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        return SizedBox(
          width: 40,
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday;
    
    // Adjust for Monday start (Dart weekday is 1 for Monday, 7 for Sunday)
    final offset = firstWeekday - 1;
    
    final totalCells = ((daysInMonth + offset) / 7).ceil() * 7;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final day = index - offset + 1;
        if (day < 1 || day > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
        final status = _getStatusForDate(date);
        
        return GestureDetector(
          onTap: () => widget.onDateSelected(date),
          child: _buildDayCell(day, status),
        );
      },
    );
  }

  Widget _buildDayCell(int day, StreakStatus status) {
    Color bgColor = Colors.transparent;
    Color textColor = AppTheme.ink;
    Widget? icon;

    switch (status) {
      case StreakStatus.completed:
        bgColor = AppTheme.primary;
        textColor = Colors.white;
        break;
      case StreakStatus.freezeUsed:
        bgColor = const Color(0xFFE8F5F1);
        textColor = AppTheme.primary;
        icon = const Text('❄️', style: TextStyle(fontSize: 10));
        break;
      case StreakStatus.missed:
        bgColor = const Color(0xFFFEECEE);
        textColor = const Color(0xFFE53935);
        break;
      case StreakStatus.noData:
        bgColor = const Color(0xFFF7F7F5);
        textColor = AppTheme.muted;
        break;
      case StreakStatus.future:
        textColor = AppTheme.muted.withOpacity(0.5);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: status == StreakStatus.noData ? Border.all(color: AppTheme.divider) : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '$day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          if (icon != null)
            Positioned(
              bottom: 4,
              child: icon,
            ),
        ],
      ),
    );
  }

  StreakStatus _getStatusForDate(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (day.isAfter(today)) {
      return StreakStatus.future;
    }
    
    return widget.dailyStatus[day] ?? StreakStatus.noData;
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
