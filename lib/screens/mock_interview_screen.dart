import 'package:flutter/material.dart';

class MockInterviewScreen extends StatefulWidget {
  final String role;
  final List<String>? questions;
  const MockInterviewScreen({super.key, required this.role, this.questions});

  @override
  State<MockInterviewScreen> createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends State<MockInterviewScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Mock Interview",
          style: TextStyle(
            color: Color(0xFF1E1B4B),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF1E1B4B),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Practice with Confidence 🎤",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose a practice mode and get interview-ready.",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 30),
            _practiceCard(
              index: 0,
              icon: Icons.description_outlined,
              title: "Resume Based Interview",
              subtitle: "Questions generated from your resume and projects.",
            ),
            const SizedBox(height: 16),
            _practiceCard(
              index: 1,
              icon: Icons.work_outline,
              title: "JD Based Interview",
              subtitle: "Questions tailored to a specific job description.",
            ),
            const SizedBox(height: 16),
            _practiceCard(
              index: 2,
              icon: Icons.casino_outlined,
              title: "Random Practice",
              subtitle: "General interview questions for everyday preparation.",
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: selectedIndex == null
                    ? null
                    : () {
                        _startInterview(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA78BFA),
                  disabledBackgroundColor: const Color(0xFFDDD6FE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Start Practice",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startInterview(BuildContext context) {
    final questions = widget.questions ?? _getQuestionsForRole(widget.role);
    final displayQuestions = List<String>.from(questions);
    displayQuestions.shuffle();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "${widget.role} Interview",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1B4B),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Prepare yourself with these 10 curated questions.",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  itemCount: displayQuestions.length > 10 ? 10 : displayQuestions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFC),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFEDE9FE)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFA78BFA).withOpacity(0.1),
                            radius: 14,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                color: Color(0xFFA78BFA),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              displayQuestions[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1E1B4B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA78BFA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Finish Practice",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getQuestionsForRole(String role) {
    final roleLower = role.toLowerCase();
    if (roleLower.contains("flutter")) {
      return [
        "What is the difference between StatefulWidget and StatelessWidget?",
        "Explain the Flutter build lifecycle.",
        "How do FutureBuilder and StreamBuilder differ?",
        "What is Riverpod and how does it improve state management?",
        "Explain the concept of 'InheritedWidget'.",
        "How does Flutter's rendering engine (Skia/Impeller) work?",
        "What are keys in Flutter and when should you use them?",
        "Difference between 'main()' and 'runApp()' in Flutter?",
        "How do you handle deep linking in Flutter?",
        "Explain Dart's event loop and Isolates.",
        "How would you optimize a long list in Flutter?",
        "What is the purpose of 'pubspec.yaml'?",
      ];
    } else if (roleLower.contains("ai") || roleLower.contains("machine learning")) {
      return [
        "Explain the intuition behind Gradient Descent.",
        "Difference between CNN and Transformer architectures?",
        "What is Prompt Engineering and why is it important for LLMs?",
        "Explain Bias-Variance tradeoff.",
        "How does Backpropagation work in Neural Networks?",
        "What is the difference between Supervised and Unsupervised learning?",
        "Explain the concept of Overfitting and how to prevent it.",
        "What are GANs (Generative Adversarial Networks)?",
        "Explain the Attention mechanism in Transformers.",
        "How do you evaluate a classification model? (F1-score, Precision, Recall)",
        "What is Transfer Learning?",
        "Difference between L1 and L2 regularization?",
      ];
    } else if (roleLower.contains("backend")) {
      return [
        "Explain the principles of REST APIs.",
        "How does JWT Authentication work?",
        "Difference between SQL and NoSQL databases?",
        "What are Microservices and their advantages?",
        "How do you handle database migrations?",
        "Explain horizontal vs vertical scaling.",
        "What is Docker and how does it help in deployment?",
        "How do you prevent SQL Injection?",
        "Explain the concept of Caching and Redis.",
        "What is an API Gateway?",
        "How does message queuing (e.g., RabbitMQ, Kafka) work?",
        "Explain ACID properties in databases.",
      ];
    } else if (roleLower.contains("frontend")) {
      return [
        "What is the Virtual DOM and how does it work?",
        "Explain CSS Flexbox vs Grid.",
        "Difference between 'var', 'let', and 'const' in JavaScript.",
        "What are React Hooks? (useEffect, useState, etc.)",
        "How do you optimize web performance?",
        "Explain the concept of Responsive Design.",
        "What is Redux and why is it used?",
        "Difference between SSR (Server Side Rendering) and CSR (Client Side Rendering).",
        "Explain Cross-Origin Resource Sharing (CORS).",
        "How do you handle state in a large-scale frontend app?",
        "What is TypeScript and how does it differ from JavaScript?",
        "Explain Closures in JavaScript.",
      ];
    } else if (roleLower.contains("cybersecurity")) {
      return [
        "What is the OWASP Top 10?",
        "Explain the difference between Symmetric and Asymmetric encryption.",
        "What is a Man-in-the-Middle (MITM) attack?",
        "How does a Three-way Handshake work in TCP?",
        "Explain the concept of Zero Trust security.",
        "What is Cross-Site Scripting (XSS) and how to prevent it?",
        "Difference between VAPT and Penetration Testing?",
        "What is a Firewall and how does it operate?",
        "Explain SQL Injection and its mitigation.",
        "What is Multi-Factor Authentication (MFA)?",
        "Explain the CIA Triad (Confidentiality, Integrity, Availability).",
        "What is the purpose of a VPN?",
      ];
    } else if (roleLower.contains("data science")) {
      return [
        "Explain the difference between Overfitting and Underfitting.",
        "What is the Central Limit Theorem and why is it important?",
        "How do you handle missing values in a dataset?",
        "Explain the bias-variance tradeoff.",
        "What is a p-value?",
        "Difference between L1 and L2 regularization.",
        "Explain the Random Forest algorithm.",
        "How does Logistic Regression work?",
        "What is the ROC curve and AUC?",
        "Explain K-means clustering.",
        "How do you deal with imbalanced data?",
        "What is Cross-Validation?",
      ];
    } else if (roleLower.contains("devops")) {
      return [
        "Explain the CI/CD pipeline and its importance.",
        "What is Infrastructure as Code (IaC)?",
        "Difference between Docker and Virtual Machines.",
        "How does Kubernetes handle self-healing?",
        "Explain Blue-Green vs Canary deployment.",
        "What is GitOps?",
        "Explain the concept of 'Everything as Code'.",
        "How do you manage secrets in a pipeline?",
        "Explain the role of a Load Balancer.",
        "What is observability and how is it different from monitoring?",
        "Explain the 3-way handshake in TCP.",
        "What is a serverless architecture?",
      ];
    } else {
      return [
        "Explain Binary Search and its time complexity.",
        "What is the difference between HashMap and TreeMap?",
        "Explain the four pillars of OOP.",
        "How does Garbage Collection work?",
        "Difference between a Process and a Thread.",
        "Explain Big O notation with examples.",
        "What are SOLID principles?",
        "How do you implement a Singleton pattern?",
        "Explain the difference between an Interface and an Abstract Class.",
        "What is a Deadlock and how to avoid it?",
        "Explain the working of a Hash Table.",
        "Difference between Recursion and Iteration.",
      ];
    }
  }

  Widget _practiceCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F3FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFA78BFA) : const Color(0xFFEDE9FE),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFFA78BFA),
              size: 30,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFA78BFA),
              ),
          ],
        ),
      ),
    );
  }
}
