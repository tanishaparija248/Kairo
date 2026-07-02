import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading_screen.dart';
import '../services/api_services.dart';
import '../models/job_analysis_model.dart';

class JDAnalyzerScreen extends StatefulWidget {
  const JDAnalyzerScreen({super.key});

  @override
  State<JDAnalyzerScreen> createState() => _JDAnalyzerScreenState();
}

class _JDAnalyzerScreenState extends State<JDAnalyzerScreen> {
  final TextEditingController jdController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  final List<String> _userSkills = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    jdController.dispose();
    skillController.dispose();
    super.dispose();
  }

  void _analyzeJD() async {
    final String jd = jdController.text.trim();
    if (jd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a Job Description first.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Get the stored Lemma student UUID
      final prefs = await SharedPreferences.getInstance();
      final String? studentId = prefs.getString('lemma_student_id');
      
      if (studentId == null) {
        throw Exception("Student session not found. Please log in again.");
      }
      
      log("Using student_id for Analysis: $studentId");

      // 2. Create Job Analysis with the correct UUID
      final analysis = await _apiService.createJobAnalysis(
        JobAnalysisModel(
          studentId: studentId,
          jdRaw: jd,
        ),
      );

      if (analysis.id == null) throw Exception("Failed to create analysis");

      // 2. Start Workflow
      final workflow = await _apiService.startFullAnalysis();

      // 3. Submit Form
      await _apiService.submitWorkflowForm(
        runId: workflow.id,
        analysisId: analysis.id!,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LoadingScreen(
            runId: workflow.id,
            analysisId: analysis.id!,
            userSkills: _userSkills,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Analysis failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "JD Analyzer",
          style: TextStyle(
            color: Color(0xFF1E1B4B),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF1E1B4B),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Analyze Your Dream Job 🚀",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Paste a Job Description or upload a PDF to discover your readiness score, missing skills, roadmap and interview questions.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Current Skills",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFEDE9FE),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_userSkills.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: -4,
                        children: _userSkills.map((skill) => Chip(
                          label: Text(skill),
                          backgroundColor: const Color(0xFFF5F3FF),
                          side: const BorderSide(color: Color(0xFFDDD6FE)),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _userSkills.remove(skill);
                            });
                          },
                        )).toList(),
                      ),
                    ),
                  TextField(
                    controller: skillController,
                    decoration: const InputDecoration(
                      hintText: "Type skill and press enter...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        setState(() {
                          if (!_userSkills.contains(value.trim())) {
                            _userSkills.add(value.trim());
                          }
                          skillController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Job Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFEDE9FE),
                ),
              ),
              child: TextField(
                controller: jdController,
                maxLines: 12,
                decoration: const InputDecoration(
                  hintText: "Paste Job Description Here...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Center(
              child: Text(
                "OR",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("PDF Upload coming soon."),
                  ),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload Job Description (PDF)"),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                foregroundColor: const Color(0xFFA78BFA),
                side: const BorderSide(
                  color: Color(0xFFA78BFA),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyzeJD,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA78BFA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Analyze Job Description",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 35),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFEDE9FE),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "The AI will generate:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("✅ Required Skills"),
                  SizedBox(height: 8),
                  Text("✅ Missing Skills"),
                  SizedBox(height: 8),
                  Text("✅ Readiness Score"),
                  SizedBox(height: 8),
                  Text("✅ Personalized Roadmap"),
                  SizedBox(height: 8),
                  Text("✅ Interview Questions"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
