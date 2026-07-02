import 'package:flutter/material.dart';
import 'mock_interview_screen.dart';

class AnalysisResultScreen extends StatelessWidget {
  final String role;
  final int score;
  final List<String> requiredSkills;
  final List<String> missingSkills;
  final List<String> preferredSkills;
  final List<Map<String, String>> roadmap;
  final List<String> interviewQuestions;
  final List<String> userSkills;

  const AnalysisResultScreen({
    super.key,
    required this.role,
    required this.score,
    required this.requiredSkills,
    required this.missingSkills,
    required this.preferredSkills,
    required this.roadmap,
    required this.interviewQuestions,
    required this.userSkills,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Analysis Result",
          style: TextStyle(
            color: Color(0xFF1E1B4B),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E1B4B)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Job Role Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFA78BFA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Target Role",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    role,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 1. Required Skills
            if (requiredSkills.isNotEmpty) ...[
              _sectionTitle("Required Skills"),
              ...requiredSkills.map((s) => _skillChip(s)),
              const SizedBox(height: 25),
            ],

            /// 2. Current Skills
            if (userSkills.isNotEmpty) ...[
              _sectionTitle("Current Skills"),
              ...userSkills.map((s) => _skillChip(s)),
              const SizedBox(height: 25),
            ],

            /// 3. Missing Skills
            if (missingSkills.isNotEmpty) ...[
              _sectionTitle("Missing Skills"),
              ...missingSkills.map((s) => _skillChip(s, isMissing: true)),
              const SizedBox(height: 25),
            ],

            /// 4. Preferred Skills
            if (preferredSkills.isNotEmpty) ...[
              _sectionTitle("Preferred Skills"),
              ...preferredSkills.map((s) => _skillChip(s, isPreferred: true)),
              const SizedBox(height: 25),
            ],

            /// 5. Readiness Score
            _sectionTitle("Readiness Score"),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFEDE9FE),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Overall Readiness",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$score%",
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA78BFA),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 6. Roadmap
            _sectionTitle("Roadmap"),
            ...roadmap.map((item) => _roadmapTile(
              item["week"] ?? "",
              item["topic"] ?? "",
            )),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MockInterviewScreen(
                        role: role,
                        questions: interviewQuestions,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA78BFA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Start Mock Interview",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E1B4B),
        ),
      ),
    );
  }

  Widget _skillChip(String skill, {bool isMissing = false, bool isPreferred = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFEDE9FE),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isMissing ? Icons.error_outline : Icons.check_circle_outline,
            color: isMissing ? Colors.orangeAccent : const Color(0xFFA78BFA),
          ),
          const SizedBox(width: 12),
          Text(
            skill,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _roadmapTile(
      String week,
      String topic,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEDE9FE),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            week,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFA78BFA),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            topic,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
