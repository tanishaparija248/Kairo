import '../models/student_model.dart';
import '../services/api_services.dart';

class StudentRepository {
  final ApiService _apiService = ApiService();

  Future<StudentModel> createStudent(StudentModel student) async {
    return await _apiService.createStudent(student);
  }
}
