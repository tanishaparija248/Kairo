import 'dart:developer';
import 'package:dio/dio.dart';
import '../utils/api_constants.dart';
import '../models/student_model.dart';
import '../models/job_analysis_model.dart';
import '../models/workflow_run_model.dart';
import '../models/roadmap_model.dart';
import '../models/interview_question_model.dart';
import '../models/interview_response_model.dart';
import 'package:supertokens_flutter/dio.dart';
import 'temporary_auth_service.dart';

class ApiService {
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    dio.addSupertokensInterceptor();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("--- API Request ---");
          print("URL: ${options.uri}");
          print("Method: ${options.method}");
          print("Headers (sanitized): ${options.headers.keys.where((k) => k != "Authorization").map((k) => "$k: ${options.headers[k]}").join(", ")}");
          print("Body: ${options.data}");
          
          options.extra["startTime"] = DateTime.now();
          handler.next(options);
        },
        onResponse: (response, handler) {
          final startTime = response.requestOptions.extra["startTime"] as DateTime;
          final elapsedTime = DateTime.now().difference(startTime).inMilliseconds;

          print("--- API Response ---");
          print("URL: ${response.requestOptions.uri}");
          print("Status Code: ${response.statusCode}");
          print("Response Body: ${response.data}");
          print("Elapsed Time: ${elapsedTime}ms");

          handler.next(response);
        },
        onError: (DioException e, handler) {
          print("--- API Error ---");
          print("URL: ${e.requestOptions.uri}");
          print("Status Code: ${e.response?.statusCode}");
          print("Response Body: ${e.response?.data}");
          print("Error Message: ${e.message}");

          handler.next(e);
        },
      ),
    );
  }

  Future<StudentModel?> getStudentByEmail(String email) async {
    print(">>> API CALL: getStudentByEmail(email: $email)");
    try {
      final response = await dio.get(
        "/pods/${ApiConstants.podId}/datastore/tables/${ApiConstants.studentsTable}/records",
        queryParameters: {
          "filter": '{"field":"email","op":"eq","value":"$email"}',
        },
      );
      print(">>> RAW JSON (getStudentByEmail): ${response.data}");

      final List items = response.data["items"] ?? [];
      if (items.isNotEmpty) {
        return StudentModel.fromJson(items.first);
      }
      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<StudentModel> createStudent(StudentModel student) async {
    print(">>> API CALL: createStudent");
    try {
      final response = await dio.post(
        "/pods/${ApiConstants.podId}/datastore/tables/${ApiConstants.studentsTable}/records",
        data: student.toJson(),
      );
      print(">>> RAW JSON (createStudent): ${response.data}");
      return StudentModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // --- Endpoints for future phases ---

  Future<JobAnalysisModel> createJobAnalysis(JobAnalysisModel analysis) async {
    print(">>> API CALL: createJobAnalysis");
    try {
      final response = await dio.post(
        "/pods/${ApiConstants.podId}/datastore/tables/${ApiConstants.analysesTable}/records",
        data: analysis.toJson(),
      );
      print(">>> RAW JSON (createJobAnalysis): ${response.data}");
      return JobAnalysisModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<WorkflowRunModel> startFullAnalysis() async {
    print(">>> API CALL: startFullAnalysis");
    try {
      final response = await dio.post(
        "/pods/${ApiConstants.podId}/workflows/${ApiConstants.fullAnalysisWorkflow}/runs",
        data: {}, // Lemma often requires at least an empty JSON object
      );
      print(">>> RAW JSON (startFullAnalysis): ${response.data}");
      return WorkflowRunModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<void> submitWorkflowForm({
    required String runId,
    required String analysisId,
  }) async {
    print(">>> API CALL: submitWorkflowForm(runId: $runId, analysisId: $analysisId)");
    try {
      await dio.post(
        "/pods/${ApiConstants.podId}/workflow-runs/$runId/form",
        data: {
          "node_id": "start_form",
          "inputs": {
            "analysis_id": analysisId,
          }
        },
      );
      print(">>> SUCCESS: submitWorkflowForm completed");
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<WorkflowRunModel> getWorkflowStatus(String runId) async {
    print(">>> API CALL: getWorkflowStatus(runId: $runId)");
    try {
      final response = await dio.get(
        "/pods/${ApiConstants.podId}/workflow-runs/$runId",
      );

      print(">>> RAW JSON (getWorkflowStatus): ${response.data}");
      
      final model = WorkflowRunModel.fromJson(response.data);
      print(">>> PARSED WorkflowRunModel: id=${model.id}, status=${model.status}, node=${model.currentNodeId}");
      
      return model;
    } on DioException catch (e) {
      print(">>> DIO ERROR (getWorkflowStatus): ${e.message}");
      print(">>> DIO ERROR BODY: ${e.response?.data}");
      _handleDioError(e);
      rethrow;
    } catch (e) {
      print(">>> UNEXPECTED ERROR (getWorkflowStatus): $e");
      rethrow;
    }
  }

  Future<JobAnalysisModel> getAnalysis(String analysisId) async {
    print(">>> API CALL: getAnalysis(analysisId: $analysisId)");
    try {
      final response = await dio.get(
        "/pods/${ApiConstants.podId}/datastore/tables/${ApiConstants.analysesTable}/records/$analysisId",
      );
      print(">>> RAW JSON (getAnalysis): ${response.data}");
      
      final model = JobAnalysisModel.fromJson(response.data);
      print(">>> PARSED JobAnalysisModel: role=${model.roleTitle}, id=${model.id}");
      
      return model;
    } on DioException catch (e) {
      print(">>> DIO ERROR (getAnalysis): ${e.message}");
      _handleDioError(e);
      rethrow;
    } catch (e) {
      print(">>> UNEXPECTED ERROR (getAnalysis): $e");
      rethrow;
    }
  }

  Future<List<RoadmapModel>> getRoadmap(String analysisId) async {
    print(">>> API CALL: getRoadmap(analysisId: $analysisId)");
    try {
      final response = await dio.get(
        "/pods/${ApiConstants.podId}/datastore/tables/${ApiConstants.roadmapTable}/records",
        queryParameters: {
          "filter": '{"field":"analysis_id","op":"eq","value":"$analysisId"}',
          "sort": '{"week_number":"asc"}',
        },
      );
      print(">>> RAW JSON (getRoadmap): ${response.data}");
      
      final items = response.data["items"] as List? ?? [];
      final models = items.map((e) => RoadmapModel.fromJson(e)).toList();
      print(">>> PARSED Roadmap: ${models.length} items found");
      
      return models;
    } on DioException catch (e) {
      print(">>> DIO ERROR (getRoadmap): ${e.message}");
      _handleDioError(e);
      rethrow;
    } catch (e) {
      print(">>> UNEXPECTED ERROR (getRoadmap): $e");
      rethrow;
    }
  }

  Future<List<InterviewQuestionModel>> getInterviewQuestions(String analysisId) async {
    print(">>> API CALL: getInterviewQuestions(analysisId: $analysisId)");
    try {
      final response = await dio.get(
        "/pods/${ApiConstants.podId}/datastore/tables/${ApiConstants.questionsTable}/records",
        queryParameters: {
          "filter": '{"field":"analysis_id","op":"eq","value":"$analysisId"}',
        },
      );
      print(">>> RAW JSON (getInterviewQuestions): ${response.data}");
      
      final items = response.data["items"] as List? ?? [];
      final models = items.map((e) => InterviewQuestionModel.fromJson(e)).toList();
      print(">>> PARSED Questions: ${models.length} items found");
      
      return models;
    } on DioException catch (e) {
      print(">>> DIO ERROR (getInterviewQuestions): ${e.message}");
      _handleDioError(e);
      rethrow;
    } catch (e) {
      print(">>> UNEXPECTED ERROR (getInterviewQuestions): $e");
      rethrow;
    }
  }

  Future<InterviewResponseModel> submitInterviewAnswer({
    required String questionId,
    required String answer,
  }) async {
    print(">>> API CALL: submitInterviewAnswer(questionId: $questionId)");
    final response = await dio.post(
      "/pods/${ApiConstants.podId}/datastore/tables/${ApiConstants.responsesTable}/records",
      data: {
        "data": {
          "question_id": questionId,
          "answer_text": answer,
          "status": "pending",
        }
      },
    );
    print(">>> RAW JSON (submitInterviewAnswer): ${response.data}");
    return InterviewResponseModel.fromJson(response.data);
  }

  Future<WorkflowRunModel> startEvaluationWorkflow() async {
    print(">>> API CALL: startEvaluationWorkflow");
    final response = await dio.post(
      "/pods/${ApiConstants.podId}/workflows/${ApiConstants.evaluateWorkflow}/runs",
    );
    print(">>> RAW JSON (startEvaluationWorkflow): ${response.data}");
    return WorkflowRunModel.fromJson(response.data);
  }

  Future<void> submitEvaluationForm({
    required String runId,
    required String responseId,
  }) async {
    print(">>> API CALL: submitEvaluationForm(runId: $runId, responseId: $responseId)");
    await dio.post(
      "/pods/${ApiConstants.podId}/workflow-runs/$runId/form",
      data: {
        "node_id": "start_form",
        "inputs": {
          "response_id": responseId,
        }
      },
    );
    print(">>> SUCCESS: submitEvaluationForm completed");
  }

  Future<InterviewResponseModel> getEvaluationResult(String responseId) async {
    print(">>> API CALL: getEvaluationResult(responseId: $responseId)");
    final response = await dio.get(
      "/pods/${ApiConstants.podId}/datastore/tables/${ApiConstants.responsesTable}/records/$responseId",
    );
    print(">>> RAW JSON (getEvaluationResult): ${response.data}");
    return InterviewResponseModel.fromJson(response.data);
  }

  void _handleDioError(DioException e) {
    String message = "An unexpected error occurred.";

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      print("CRITICAL API ERROR BODY: $data");

      if (statusCode == 401 || statusCode == 403) {
        message = "Authentication failed (401/403). STOPPING. Body: $data";
      } else if (statusCode == 400) {
        message = "Bad Request (400). Payload validation failed. Body: $data";
      } else if (statusCode == 404) {
        message = "Not Found (404). Endpoint or Pod incorrect. Body: $data";
      } else if (statusCode == 500) {
        message = "Internal Server Error (500). Body: $data";
      } else if (data is Map && data.containsKey("message")) {
        message = data["message"];
      }
    }
    
    print("User-friendly message: $message");
  }
}
