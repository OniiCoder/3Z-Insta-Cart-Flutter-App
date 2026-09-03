import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class DailyProgressModel {
  final String date;
  final int stepCount;

  DailyProgressModel({required this.date, required this.stepCount});
}

class InteractiveStepChart extends StatefulWidget {
  final List<DailyProgressModel> dailyBreakdown;
  final int stepTarget;
  final int challengeDurationDays;

  const InteractiveStepChart({
    super.key,
    required this.dailyBreakdown,
    required this.stepTarget,
    this.challengeDurationDays = 7,
  });

  @override
  State<InteractiveStepChart> createState() => _InteractiveStepChartState();
}

class _InteractiveStepChartState extends State<InteractiveStepChart> {
  late String _selectedRange;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    final available = _getAvailableRanges();
    _selectedRange = available.contains('W') ? 'W' : available.first;
  }

  List<String> _getAvailableRanges() {
    final count = math.max(widget.dailyBreakdown.length, widget.challengeDurationDays);
    if (count >= 180) {
      return ['W', 'M', '6M', 'Y'];
    } else if (count >= 60) {
      return ['W', 'M', '6M'];
    } else if (count >= 14) {
      return ['W', 'M'];
    } else {
      return ['W'];
    }
  }

  List<DailyProgressModel> _getFilteredData() {
    if (widget.dailyBreakdown.isEmpty) return [];

    final sorted = List<DailyProgressModel>.from(widget.dailyBreakdown)
      ..sort((a, b) => a.date.compareTo(b.date));

    int takeCount;
    switch (_selectedRange) {
      case 'W':
        takeCount = 7;
        break;
      case 'M':
        takeCount = 30;
        break;
      case '6M':
        takeCount = 180;
        break;
      case 'Y':
        takeCount = 365;
        break;
      default:
        takeCount = 7;
    }

    if (sorted.length > takeCount) {
      return sorted.sublist(sorted.length - takeCount);
    }
    return sorted;
  }

  String _formatNumber(int n) {
    if (n >= 1000000) {
      return '${(n / 1000000).toStringAsFixed(1)}M';
    } else if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}k';
    }
    return n.toString();
  }

  String _formatShortDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${d.day} ${months[d.month - 1]} ${d.year}';
    } catch (_) {
      return dateStr;
    }
  }

  String _getDateRangeSubtitle(List<DailyProgressModel> data) {
    if (data.isEmpty) return '';
    if (data.length == 1) return _formatShortDate(data.first.date);
    return '${_formatShortDate(data.first.date)} – ${_formatShortDate(data.last.date)}';
  }

  @override
  Widget build(BuildContext context) {
    final availableRanges = _getAvailableRanges();
    final data = _getFilteredData();

    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalSteps = data.fold<int>(0, (sum, item) => sum + item.stepCount);
    final avgSteps = data.isNotEmpty ? (totalSteps / data.length).round() : 0;

    DailyProgressModel? selectedItem;
    if (_selectedIndex != null && _selectedIndex! >= 0 && _selectedIndex! < data.length) {
      selectedItem = data[_selectedIndex!];
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Step Activity',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        selectedItem != null
                            ? _formatNumber(selectedItem.stepCount)
                            : _formatNumber(avgSteps),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        selectedItem != null ? 'steps' : 'avg/day',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedItem != null
                        ? _formatShortDate(selectedItem.date)
                        : _getDateRangeSubtitle(data),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              if (availableRanges.length > 1)
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: availableRanges.map((range) {
                      final isSelected = _selectedRange == range;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _selectedRange = range;
                            _selectedIndex = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF334155) : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            range,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onHorizontalDragUpdate: (details) => _handleTouch(details.localPosition.dx, data),
            onTapDown: (details) => _handleTouch(details.localPosition.dx, data),
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: CustomPaint(
                painter: _StepChartPainter(
                  data: data,
                  stepTarget: widget.stepTarget,
                  selectedIndex: _selectedIndex,
                  range: _selectedRange,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Target: ${_formatNumber(widget.stepTarget)} steps/day',
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
              const Text(
                'Touch or drag to scrub dates',
                style: TextStyle(fontSize: 10.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleTouch(double dx, List<DailyProgressModel> data) {
    if (data.isEmpty) return;
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    final chartWidth = box != null ? box.size.width - 40 : 300.0;

    final barWidthTotal = chartWidth / data.length;
    int index = (dx / barWidthTotal).floor().clamp(0, data.length - 1);

    if (index != _selectedIndex) {
      HapticFeedback.selectionClick();
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

class _StepChartPainter extends CustomPainter {
  final List<DailyProgressModel> data;
  final int stepTarget;
  final int? selectedIndex;
  final String range;

  _StepChartPainter({
    required this.data,
    required this.stepTarget,
    required this.selectedIndex,
    required this.range,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = math.max(
      stepTarget,
      data.map((e) => e.stepCount).reduce(math.max),
    );

    final double availableWidth = size.width;
    final double barSpacing = data.length <= 7 ? 8.0 : (data.length <= 30 ? 3.0 : 1.5);
    final double barWidth = ((availableWidth - (barSpacing * (data.length - 1))) / data.length).clamp(2.0, 36.0);

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final isSelected = selectedIndex == i;
      final heightRatio = maxVal > 0 ? (item.stepCount / maxVal).clamp(0.04, 1.0) : 0.04;
      final barHeight = size.height * heightRatio;
      final x = i * (barWidth + barSpacing);
      final y = size.height - barHeight;

      final paint = Paint()
        ..color = isSelected
            ? BmnColors.brand400
            : (item.stepCount >= stepTarget ? BmnColors.brand500 : const Color(0xFF334155))
        ..style = PaintingStyle.fill;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        Radius.circular(barWidth / 2),
      );

      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StepChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.range != range;
  }
}
