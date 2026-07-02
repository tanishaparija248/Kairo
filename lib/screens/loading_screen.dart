import 'dart:async';
import 'package:flutter/material.dart';
import 'analysis_result_screen.dart';
import '../services/api_services.dart';

class LoadingScreen extends StatefulWidget {
  final String runId;
  final String analysisId;
  final List<String> userSkills;

  const LoadingScreen({
    super.key,
    required this.runId,
    required this.analysisId,
    required this.userSkills,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final ApiService _apiService = ApiService();
  int currentStep = 0;
  Timer? _timer;
  Timer? _statusTimer;

  final List<String> steps = [
    "Reading Job Description...",
    "Analyzing Required Skills...",
    "Calculating Readiness Score...",
    "Generating Learning Roadmap...",
    "Preparing Interview Questions..."
  ];

  @override
  void initState() {
    super.initState();
    
    // Animation timer for steps
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentStep < steps.length - 1) {
        setState(() {
          currentStep++;
        });
      }
    });

    // Polling timer for workflow status
    _startPolling();
  }

  void _startPolling() {
    print(">>> STARTING WORKFLOW POLLING for runId: ${widget.runId}");
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        print(">>> POLLING: Calling getWorkflowStatus for runId: ${widget.runId}");
        final workflow = await _apiService.getWorkflowStatus(widget.runId);
        print(">>> POLLING SUCCESS: Status is ${workflow.status}");
        
        // Use case-insensitive comparison and handle nulls
        final status = workflow.status.toUpperCase();
        
        if (status == "COMPLETED") {
          print(">>> WORKFLOW COMPLETED! Transitioning to fetch results...");
          timer.cancel();
          _fetchResultsAndNavigate();
        } else if (status == "FAILED") {
          print(">>> WORKFLOW FAILED: ${workflow.error}");
          timer.cancel();
          _handleError(workflow.error ?? "Analysis workflow failed.");
        } else {
          print(">>> WORKFLOW STILL IN PROGRESS (Status: $status)");
        }
      } catch (e) {
        print(">>> POLLING ERROR: $e");
        if (e.toString().contains("401") || e.toString().contains("403")) {
          print(">>> CRITICAL AUTH ERROR. Stopping polling.");
          timer.cancel();
          _handleError("Authentication error. Please log in again.");
        }
      }
    });
  }

  Future<void> _fetchResultsAndNavigate() async {
    print(">>> ENTERING _fetchResultsAndNavigate <<<");
    try {
      print(">>> AWAITING: getAnalysis for analysisId: ${widget.analysisId}");
      final analysis = await _apiService.getAnalysis(widget.analysisId);
      print(">>> RECEIVED: Job Analysis data for ${analysis.roleTitle}");
      
      print(">>> AWAITING: getRoadmap for analysisId: ${widget.analysisId}");
      final roadmap = await _apiService.getRoadmap(widget.analysisId);
      print(">>> RECEIVED: Roadmap with ${roadmap.length} items");
      
      print(">>> AWAITING: getInterviewQuestions for analysisId: ${widget.analysisId}");
      final questions = await _apiService.getInterviewQuestions(widget.analysisId);
      print(">>> RECEIVED: ${questions.length} Interview Questions");

      print(">>> CHECKING MOUNTED STATE: $mounted");
      if (!mounted) {
        print(">>> NAVIGATION ABORTED: Widget unmounted during async operation.");
        return;
      }

      print(">>> READY TO NAVIGATE: Immediately before Navigator.pushReplacement");
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AnalysisResultScreen(
            role: analysis.roleTitle ?? "Analyst",
            score: (analysis.readinessData?["score"] as num?)?.toInt() ?? 0,
            requiredSkills: analysis.extractedSkills?.map((e) => e.toString()).toList() ?? [],
            missingSkills: (analysis.readinessData?["missing_skills"] as List?)?.map((e) => e.toString()).toList() ?? [],
            preferredSkills: [], 
            roadmap: roadmap.map((e) => {
              "week": "Week ${e.weekNumber}",
              "topic": e.title ?? e.description ?? ""
            }).toList(),
            interviewQuestions: questions.map((e) => e.questionText).toList(),
            userSkills: widget.userSkills,
          ),
        ),
      );
      print(">>> NAVIGATION EXECUTED: Navigator call completed.");
    } catch (e, stackTrace) {
      print("!!! EXCEPTION CAUGHT IN _fetchResultsAndNavigate !!!");
      print("!!! ERROR: $e");
      print("!!! STACK TRACE: \n$stackTrace");
      _handleError("Failed to fetch analysis results: $e");
    }
  }

  void _handleError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 5,
                color: Color(0xFFA78BFA),
              ),
              const SizedBox(height: 40),
              const Text(
                "AI is analyzing your Job Description",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1B4B),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Please wait while Kairo prepares your personalized interview plan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 50),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFFA78BFA),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          steps[currentStep],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              LinearProgressIndicator(
                value: (currentStep + 1) / steps.length,
                backgroundColor: Colors.grey.shade300,
                color: const Color(0xFFA78BFA),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
