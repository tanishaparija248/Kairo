import 'dart:math';

class AnalysisResult {
  final String role;
  final String company;
  final String experienceLevel;
  final int score;
  final List<String> requiredSkills;
  final List<String> missingSkills;
  final List<String> preferredSkills;
  final List<Map<String, String>> roadmap;
  final List<String> interviewQuestions;

  AnalysisResult({
    required this.role,
    required this.company,
    required this.experienceLevel,
    required this.score,
    required this.requiredSkills,
    required this.missingSkills,
    required this.preferredSkills,
    required this.roadmap,
    required this.interviewQuestions,
  });
}

class LocalAnalysisService {
  static final Map<String, List<String>> _roleSkills = {
    "AI/ML Engineer": ["Python", "TensorFlow", "PyTorch", "Transformers", "LLMs", "NLP", "Computer Vision", "Machine Learning", "Scikit-Learn", "Keras"],
    "Data Scientist": ["Python", "R", "SQL", "Pandas", "Matplotlib", "Scikit-Learn", "Statistics", "Deep Learning", "Spark", "Data Visualization"],
    "Software Engineer": ["DSA", "Algorithms", "System Design", "Java", "C++", "Python", "SQL", "Git", "Unit Testing", "Object-Oriented Programming"],
    "Backend Developer": ["Node.js", "Express", "SQL", "Docker", "MongoDB", "PostgreSQL", "REST API", "GraphQL", "Redis", "Authentication"],
    "Frontend Developer": ["HTML", "CSS", "JavaScript", "TypeScript", "React", "Next.js", "Vue", "Angular", "Tailwind CSS", "Redux"],
    "Flutter Developer": ["Flutter", "Dart", "Firebase", "Riverpod", "BLoC", "State Management", "REST API", "Git", "Unit Testing", "CI/CD"],
    "Android Developer": ["Kotlin", "Java", "Android SDK", "Jetpack Compose", "Retrofit", "Dagger Hilt", "Coroutines", "MVVM", "Room Database"],
    "iOS Developer": ["Swift", "SwiftUI", "Combine", "UIKit", "Core Data", "Xcode", "iOS SDK", "CocoaPods", "MVVM"],
    "DevOps Engineer": ["Docker", "Kubernetes", "Jenkins", "Terraform", "AWS", "Azure", "GCP", "CI/CD", "Linux", "Bash Scripting"],
    "Cloud Engineer": ["AWS", "Azure", "GCP", "Terraform", "CloudFormation", "Serverless", "IAM", "VPC", "Cloud Security", "Kubernetes"],
    "Cybersecurity Analyst": ["Linux", "Networking", "OWASP", "SIEM", "Python", "Burp Suite", "IDS/IPS", "Cryptography", "PenTesting", "Wireshark"],
    "QA Engineer": ["Selenium", "JUnit", "TestRail", "Appium", "Postman", "Cypress", "Automation Testing", "Regression Testing", "Agile", "Jira"],
    "Full Stack Developer": ["React", "Node.js", "SQL", "TypeScript", "HTML/CSS", "Express", "REST API", "Git", "Docker", "Cloud Basics"],
  };

  static final Map<String, List<String>> _roleQuestions = {
    "AI/ML Engineer": [
      "Explain the intuition behind Gradient Descent.",
      "What is the difference between CNN and Transformer architectures?",
      "Explain the concept of Prompt Engineering in LLMs.",
      "How do you handle the Bias-Variance tradeoff?",
      "What is fine-tuning and when should you use it?",
      "Explain the Attention mechanism in Transformers.",
      "What are the common evaluation metrics for ML models?",
      "How do you prevent overfitting in deep learning?",
      "Explain backpropagation in neural networks.",
      "What is the difference between supervised and unsupervised learning?"
    ],
    "Data Scientist": [
      "What is the difference between L1 and L2 regularization?",
      "Explain p-value and its significance.",
      "How do you handle missing or corrupted data in a dataset?",
      "What is the Central Limit Theorem?",
      "Explain the difference between Type I and Type II errors.",
      "How does a Random Forest algorithm work?",
      "Explain Logistic Regression.",
      "What is cross-validation?",
      "How do you evaluate a recommendation system?",
      "Explain the curse of dimensionality."
    ],
    "Software Engineer": [
      "Explain Binary Search and its time complexity.",
      "What are the SOLID principles?",
      "Explain the four pillars of Object-Oriented Programming.",
      "What is the difference between a process and a thread?",
      "How does Garbage Collection work in modern languages?",
      "Explain Big O notation with examples.",
      "What is a Singleton pattern and when should it be avoided?",
      "Difference between an interface and an abstract class.",
      "How do you identify and handle deadlocks?",
      "Explain how a Hash Table works internally."
    ],
    "Backend Developer": [
      "Explain the principles of RESTful API design.",
      "What is the difference between SQL and NoSQL databases?",
      "How does JWT authentication work?",
      "Explain horizontal vs vertical scaling.",
      "What are Microservices and what are their challenges?",
      "How do you prevent SQL Injection attacks?",
      "Explain ACID properties in databases.",
      "What is an API Gateway?",
      "How does message queuing work in distributed systems?",
      "Explain the difference between Docker containers and Virtual Machines."
    ],
    "Frontend Developer": [
      "What is the Virtual DOM and how does it work?",
      "Explain the difference between var, let, and const.",
      "What are React Hooks and how do they change component logic?",
      "How do you optimize web performance?",
      "Explain Cross-Origin Resource Sharing (CORS).",
      "What is the difference between SSR and CSR?",
      "How do you handle state management in large applications?",
      "What are the benefits of using TypeScript over JavaScript?",
      "Explain the concept of responsive web design.",
      "What is a Progressive Web App (PWA)?"
    ],
    "Flutter Developer": [
      "What is the difference between StatefulWidget and StatelessWidget?",
      "Explain the Flutter build lifecycle.",
      "How do FutureBuilder and StreamBuilder differ?",
      "What is Riverpod and why is it preferred over Provider?",
      "Explain the concept of 'Keys' in Flutter.",
      "How does Flutter's rendering engine work?",
      "What is Dart's event loop and how does it handle concurrency?",
      "Difference between hot reload and hot restart?",
      "How do you handle dependency injection in Flutter?",
      "Explain the use of InheritedWidget."
    ],
    "Android Developer": [
      "Explain the Android Activity lifecycle.",
      "What is Jetpack Compose and how does it differ from Views?",
      "Explain the MVVM architecture in Android.",
      "What are Coroutines and how do they help in async tasks?",
      "Difference between Serializable and Parcelable.",
      "What is Dagger Hilt and why use it for DI?",
      "Explain the role of ViewModel in Android.",
      "How does the Room database work?",
      "What are WorkManager and its use cases?",
      "Explain the difference between a Service and an IntentService."
    ],
    "iOS Developer": [
      "Explain the difference between SwiftUI and UIKit.",
      "What are Optionals in Swift and how do they work?",
      "Explain Automatic Reference Counting (ARC).",
      "What is the difference between a struct and a class in Swift?",
      "Explain the MVC and MVVM patterns in iOS.",
      "What is Combine framework?",
      "How do you handle concurrency in iOS using GCD or async/await?",
      "What is Core Data?",
      "Explain the iOS Application lifecycle.",
      "What are Protocols and Delegates?"
    ],
    "DevOps Engineer": [
      "What is CI/CD and why is it important?",
      "Explain the difference between Docker and Kubernetes.",
      "What is Infrastructure as Code (IaC)?",
      "Explain Blue-Green vs Canary deployment.",
      "What are the benefits of using Jenkins for automation?",
      "How do you manage secrets in a DevOps pipeline?",
      "What is the role of Prometheus and Grafana?",
      "Explain the concept of GitOps.",
      "How do you handle auto-scaling in the cloud?",
      "What is a Load Balancer and how does it work?"
    ],
    "Cloud Engineer": [
      "Explain the difference between IaaS, PaaS, and SaaS.",
      "How do you secure a VPC in AWS/Azure/GCP?",
      "What is the difference between AWS Lambda and EC2?",
      "Explain the shared responsibility model in cloud computing.",
      "What is a serverless architecture?",
      "How do you handle data replication in the cloud?",
      "What is the purpose of an IAM policy?",
      "Explain the concept of edge computing.",
      "What is CloudFront and how does it work?",
      "How do you manage cloud costs effectively?"
    ],
    "Cybersecurity Analyst": [
      "What is the OWASP Top 10 and why does it matter?",
      "Explain the CIA Triad (Confidentiality, Integrity, Availability).",
      "Difference between symmetric and asymmetric encryption.",
      "What is a Man-in-the-Middle (MITM) attack?",
      "Explain Cross-Site Scripting (XSS) and its mitigation.",
      "What is SQL Injection and how can it be prevented?",
      "Explain the TCP 3-way handshake process.",
      "What is a VPN and how does it provide security?",
      "Difference between a Firewall and an Intrusion Detection System (IDS).",
      "Explain the concept of Zero Trust security architecture."
    ],
    "QA Engineer": [
      "What is the difference between Alpha and Beta testing?",
      "Explain the STLC (Software Testing Life Cycle).",
      "What is regression testing and when is it performed?",
      "Difference between black box and white box testing.",
      "What is automation testing and when is it not suitable?",
      "Explain the concept of the Test Pyramid.",
      "What is Boundary Value Analysis?",
      "How do you handle flaky tests in automation?",
      "What is the difference between bug severity and priority?",
      "Explain the role of a QA engineer in an Agile environment."
    ],
    "Full Stack Developer": [
      "How do you choose between a monolithic and a microservices architecture?",
      "Explain the difference between client-side and server-side rendering.",
      "How do you manage state across the entire stack?",
      "What are the security considerations for a full stack application?",
      "Explain the role of a message broker like RabbitMQ or Kafka.",
      "How do you optimize the performance of both frontend and backend?",
      "What is the difference between SQL and NoSQL for a full stack app?",
      "How do you handle authentication and authorization across the stack?",
      "Explain the benefits of using a containerized environment (Docker).",
      "How do you implement CI/CD for a full stack project?"
    ],
  };

  static final Map<String, List<String>> _rolePatterns = {
    "AI/ML Engineer": ["ai/ml engineer", "machine learning engineer", "ai engineer", "ml engineer"],
    "Data Scientist": ["data scientist"],
    "Software Engineer": ["software engineer", "software developer"],
    "Backend Developer": ["backend developer", "backend engineer"],
    "Frontend Developer": ["frontend developer", "frontend engineer"],
    "Flutter Developer": ["flutter developer", "flutter engineer"],
    "Android Developer": ["android developer", "android engineer"],
    "iOS Developer": ["ios developer", "ios engineer"],
    "DevOps Engineer": ["devops engineer", "devops"],
    "Cloud Engineer": ["cloud engineer", "cloud architect"],
    "Cybersecurity Analyst": ["cybersecurity analyst", "security analyst", "cybersecurity engineer"],
    "QA Engineer": ["qa engineer", "quality assurance engineer", "test engineer"],
    "Full Stack Developer": ["full stack developer", "full stack engineer", "fullstack developer"],
  };

  Future<AnalysisResult> analyze(String jd, List<String> userSkills) async {
    final jdLower = jd.toLowerCase();
    final jdLines = jd.split('\n');
    final firstLine = jdLines.isNotEmpty ? jdLines.first.trim().toLowerCase() : "";

    // Normalize user skills for comparison
    final normalizedUserSkills = userSkills.map((s) => s.trim().toLowerCase()).toList();

    // 1. Role Detection
    String detectedRole = "General Software Engineer";
    bool roleFound = false;

    // First, check exact matches in the title/first line
    for (var entry in _rolePatterns.entries) {
      for (var pattern in entry.value) {
        if (firstLine.contains(pattern)) {
          detectedRole = entry.key;
          roleFound = true;
          break;
        }
      }
      if (roleFound) break;
    }

    // If not found in first line, check whole JD but give higher weight to exact patterns
    if (!roleFound) {
      for (var entry in _rolePatterns.entries) {
        for (var pattern in entry.value) {
          if (jdLower.contains(pattern)) {
            detectedRole = entry.key;
            roleFound = true;
            break;
          }
        }
        if (roleFound) break;
      }
    }

    // Fallback keyword matching if no exact pattern found
    if (!roleFound) {
      int maxMatches = 0;
      _roleSkills.forEach((role, skills) {
        int matches = 0;
        final roleParts = role.toLowerCase().replaceAll('/', ' ').split(' ');
        for (var part in roleParts) {
          if (part.length > 3 && jdLower.contains(part)) matches += 5;
        }
        for (var skill in skills) {
          if (jdLower.contains(skill.toLowerCase())) matches++;
        }
        if (matches > maxMatches) {
          maxMatches = matches;
          detectedRole = role;
        }
      });
      if (maxMatches > 10) roleFound = true;
    }

    if (!roleFound) {
      detectedRole = "General Software Engineer";
    }

    // 2. Company Detection
    String company = "Unknown";
    // Check first line specifically like "Software Engineer at Google"
    final atPattern = RegExp(r"at\s+([A-Z][a-zA-Z0-9\s&]+)");
    final firstLineMatch = atPattern.firstMatch(jdLines.isNotEmpty ? jdLines.first : "");
    if (firstLineMatch != null) {
      company = firstLineMatch.group(1)!.trim();
      // Clean up company name if it continues too far
      if (company.contains(RegExp(r"\s+is|\s+looks|\s+seeks|\s+hiring|\s+-"))) {
         company = company.split(RegExp(r"\s+is|\s+looks|\s+seeks|\s+hiring|\s+-")).first.trim();
      }
    } else {
      final companyPatterns = [
        RegExp(r"(?:at|joining|with)\s+([A-Z][a-zA-Z0-9\s&]+?)(?:\s+is|\s+looks|\s+seeks|\s+hiring)"),
        RegExp(r"^([A-Z][a-zA-Z0-9\s&]+?)\s+is looking for"),
        RegExp(r"Company:\s*([A-Z][a-zA-Z0-9\s&]+)"),
      ];
      for (var pattern in companyPatterns) {
        final match = pattern.firstMatch(jd);
        if (match != null && match.groupCount >= 1) {
          company = match.group(1)!.trim();
          break;
        }
      }
    }

    // 3. Experience Level Detection
    String experienceLevel = "Entry Level";
    if (jdLower.contains("senior") || jdLower.contains("sr.")) {
      experienceLevel = "Senior";
    } else if (jdLower.contains("lead") || jdLower.contains("principal")) {
      experienceLevel = "Lead";
    } else if (jdLower.contains("junior") || jdLower.contains("jr.")) {
      experienceLevel = "Junior";
    } else if (jdLower.contains("intern")) {
      experienceLevel = "Intern";
    }

    // 4. Skills Analysis
    List<String> allRoleSkills = _roleSkills[detectedRole] ?? _roleSkills["Software Engineer"]!;
    
    // Required Skills = technical skills extracted from JD
    List<String> requiredSkills = [];
    for (var skill in allRoleSkills) {
      if (jdLower.contains(skill.toLowerCase())) {
        requiredSkills.add(skill);
      }
    }

    // Missing Skills = Required Skills - Current Skills
    List<String> missingSkills = [];
    for (var skill in requiredSkills) {
      if (!normalizedUserSkills.contains(skill.toLowerCase())) {
        missingSkills.add(skill);
      }
    }

    // 5. Readiness Score
    // Readiness = (Current Skills Matching Required Skills ÷ Total Required Skills) × 100
    int matchedCount = requiredSkills.length - missingSkills.length;
    int score = 0;
    if (requiredSkills.isNotEmpty) {
      score = ((matchedCount / requiredSkills.length) * 100).round();
    } else {
      // Fallback if no specific skills found in JD
      score = 100;
    }

    // 6. Preferred Skills
    List<String> preferredSkills = ["Agile", "Teamwork", "Problem Solving"];
    final techKeywords = ["AWS", "Azure", "GCP", "Docker", "Kubernetes", "Redis", "Kafka", "PostgreSQL", "MongoDB", "TypeScript", "Git", "Jira", "Jenkins"];
    for (var tech in techKeywords) {
      if (jdLower.contains(tech.toLowerCase()) && !requiredSkills.contains(tech)) {
        preferredSkills.add(tech);
      }
    }

    // 7. Roadmap (Using only Missing Skills)
    List<Map<String, String>> roadmap = [];
    List<String> topics = [...missingSkills];
    
    if (topics.isEmpty) {
        roadmap.add({"week": "Week 1", "topic": "Deepen expertise in ${requiredSkills.isNotEmpty ? requiredSkills.first : detectedRole}"});
        roadmap.add({"week": "Week 2", "topic": "Contribute to Open Source Projects"});
        roadmap.add({"week": "Week 3", "topic": "System Design & Architecture"});
        roadmap.add({"week": "Week 4", "topic": "Advanced Interview Preparation"});
    } else {
        for (int i = 0; i < topics.length && i < 4; i++) {
          roadmap.add({
            "week": "Week ${i + 1}",
            "topic": "Master ${topics[i]}",
          });
        }
        
        // Fill up to 4 weeks if fewer than 4 missing skills
        if (roadmap.length < 4) {
            final genericTopics = ["System Design", "Unit Testing", "Clean Architecture", "Performance Tuning"];
            for (var gt in genericTopics) {
                if (roadmap.length >= 4) break;
                if (!topics.contains(gt)) {
                    roadmap.add({
                        "week": "Week ${roadmap.length + 1}",
                        "topic": "Master $gt",
                    });
                }
            }
        }
    }

    // 8. Interview Questions
    List<String> baseQuestions = _roleQuestions[detectedRole] ?? _roleQuestions["Software Engineer"]!;
    List<String> displayQuestions = List<String>.from(baseQuestions);
    int jdHash = jd.hashCode.abs();
    final random = Random(jdHash);
    displayQuestions.shuffle(random);

    return AnalysisResult(
      role: detectedRole,
      company: company,
      experienceLevel: experienceLevel,
      score: score,
      requiredSkills: requiredSkills,
      missingSkills: missingSkills,
      preferredSkills: preferredSkills.take(3).toList(),
      roadmap: roadmap,
      interviewQuestions: displayQuestions.take(10).toList(),
    );
  }
}
