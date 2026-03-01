import 'package:flutter/material.dart';
import 'package:study_snap/core/models/solution_step.dart';

class StepBadge extends StatelessWidget {
  const StepBadge({
    super.key,
    required this.context,
    required this.step,
    required this.isSelected,
  });

  final BuildContext context;
  final SolutionStep step;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => Container(
    width: 25,
    height: 25,
    decoration: BoxDecoration(
      color:
          isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.green.withOpacity(0.2),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child:
          isSelected
              ? Text(
                step.step.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                ),
              )
              : Icon(
                isSelected ? Icons.arrow_right_alt : Icons.check,
                size: 16,
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.green,
              ),
    ),
  );
}
