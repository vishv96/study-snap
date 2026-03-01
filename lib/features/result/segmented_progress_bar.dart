import 'package:flutter/material.dart';
import 'package:study_snap/core/models/solution_step.dart';
import 'package:study_snap/features/camera/result_screen.dart';

class SegmentedProgressBar extends StatefulWidget {
  const SegmentedProgressBar({
    super.key,
    required this.steps,
    required this.isSelectedIndex,
  });

  final List<SolutionStep>? steps;
  final int isSelectedIndex;

  @override
  State<SegmentedProgressBar> createState() => _SegmentedProgressBarState();
}

class _SegmentedProgressBarState extends State<SegmentedProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ...List.generate(widget.steps!.length, (index) {
            final isActive = index <= widget.isSelectedIndex;

            final activeColor = Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.9);
            final inactiveColor = Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.3);

            return progressSegment(isActive, activeColor, inactiveColor);
          }),
        ],
      ),
    );
  }

  Expanded progressSegment(
    bool isActive,
    Color activeColor,
    Color inactiveColor,
  ) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
