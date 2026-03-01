import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:study_snap/core/models/solution_step.dart';
import 'package:study_snap/features/result/segmented_progress_bar.dart';
import 'package:study_snap/features/result/step_badge.dart';

final class ResultScreen extends StatefulWidget {
  SolutionResult result;
  String? answer;
  String? type;
  List<SolutionStep>? steps;
  String? concept;

  ResultScreen({super.key, required this.result}) {
    answer = result.answer;
    type = result.type;
    steps = result.steps;
    concept = result.concept;
  }

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int currentStep = 0;
  bool get isFinished => currentStep == widget.steps!.length - 1;
  bool showSummary = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solution')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          spacing: 16,
          children: [
            SegmentedProgressBar(
              steps: widget.steps,
              isSelectedIndex: currentStep,
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              child:
                  showSummary
                      ? _buildSummary(context)
                      : _buildSolutionSteps(context),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _buildSummary(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          SizedBox(height: 16),
          _celebrationCardWidget(),
          SizedBox(height: 16),
          Text(
            "Summary",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          if (widget.steps != null)
            ...List.generate(widget.steps!.length, (index) {
              return Row(
                children: [
                  StepBadge(
                    context: context,
                    step: widget.steps![index],
                    isSelected: false,
                  ),
                  SizedBox(width: 8),
                  Text(widget.steps![index].summary),
                ],
              );
            }),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.yellow.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.yellow.withOpacity(0.8)),
            ),
            child: Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Text("💡"),
                    Text(
                      "KEY CONCEPT",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[800],
                      ),
                    ),
                  ],
                ),
                Text(widget.concept ?? "No concept extracted"),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.8)),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Snap Another",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _celebrationCardWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text("🎉", style: TextStyle(fontSize: 32)),
            SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You got it!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "All steps ${widget.steps!.length} completed successfully",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _buildSolutionSteps(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 32,
        children: [
          if (widget.answer != null) _buildAnswer(context, widget.answer!),
          Row(
            children: [
              Text(
                "STEP BY STEP SOLUTION",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          StepsWidget(
            context: context,
            steps: widget.steps!,
            currentStep: currentStep,
          ),
          _nextButton(),
        ],
      ),
    );
  }

  AnimatedContainer _nextButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isFinished ? Colors.green : Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        height: 55,
        child: TextButton(
          onPressed: () {
            if (currentStep < widget.steps!.length - 1) {
              setState(() {
                currentStep++;
              });
            } else {
              setState(() {
                showSummary = true;
              });
            }
          },
          child: Text(
            isFinished ? "Finish" : "Next Step",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Container _buildAnswer(BuildContext context, String answer) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Final Answer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            MarkdownBody(data: answer),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Widget to display each step of the solution
class StepsWidget extends StatefulWidget {
  const StepsWidget({
    super.key,
    required this.context,
    required this.steps,
    required this.currentStep,
  });

  final BuildContext context;
  final List<SolutionStep> steps;
  final int currentStep;

  @override
  State<StepsWidget> createState() => _StepsWidgetState();
}

class _StepsWidgetState extends State<StepsWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.steps.length,
      itemBuilder: (context, index) {
        final step = widget.steps[index];
        return AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child:
              index == widget.currentStep
                  ? expandedContent(context, step)
                  : summaryContent(context, step),
        );
      },
    );
  }

  BoxDecoration get boxDecoration => BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
    ),
  );

  Container expandedContent(BuildContext context, SolutionStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    StepBadge(context: context, step: step, isSelected: true),
                  ],
                ),
              ),
              Expanded(flex: 10, child: MarkdownBody(data: step.explanation)),
            ],
          ),
          Divider(height: 32, color: Colors.grey.withOpacity(0.5)),
        ],
      ),
    );
  }

  Container summaryContent(BuildContext context, SolutionStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                StepBadge(context: context, step: step, isSelected: false),
              ],
            ),
          ),
          Expanded(flex: 10, child: MarkdownBody(data: step.summary!)),
        ],
      ),
    );
  }
}
