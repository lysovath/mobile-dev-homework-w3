import 'package:lms_layered_architecture_example/model/course_result.dart';

import '../model/course.dart';
import '../model/student.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> courseResults = [];
 
  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }
 
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);

    for(Course course in courses){
      course.studentIds.removeWhere((id) => id == studentId);
    }

    courseResults.removeWhere((courseResult) => courseResult.studentId == studentId);
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  } 

  void createCourse({required String courseId, required String courseName}){
    Course? course = _findCourseOrNull(courseId);
    if(course != null){
      throw Exception("Course with id $courseId already exist!");
    }
    Course newCourse = Course(id: courseId, name: courseName);
    courses.add(newCourse);
  }

  void addStudentToCourse({required String studentId, required String courseId}){
    Student? student = _findStudentOrNull(studentId);
    if(student == null){
      throw Exception("Student with id $studentId doesn't exist");
    }

    Course? course = _findCourseOrNull(courseId);
    if(course == null){
      throw Exception("Course with id $courseId doesn't exist");
    }

    bool isStudentExistInCourse = course.studentIds.contains(studentId);
    if(isStudentExistInCourse){
      throw Exception("Student with id $studentId already register in course id $courseId");
    }

    course.studentIds.add(studentId);
  }

  Course? _findCourseOrNull(String courseId){
    for(Course course in courses){
      if(course.id == courseId){
        return course;
      }
    }
    return null;
  }

  void recordStudentScoreForCourse({required String studentId, required String courseId, required double score}){
    Student? student = _findStudentOrNull(studentId);
    if(student == null){
      throw Exception("Student with id $studentId doesn't exist");
    }

    Course? course = _findCourseOrNull(courseId);
    if(course == null){
      throw Exception("Course with id $courseId doesn't exist");
    }

    bool isStudentExistInCourse = course.studentIds.contains(studentId);
    if(!isStudentExistInCourse){
      throw Exception("Student with id $studentId doesn't register in course with id $courseId");
    }

    CourseResult? existCourseResult = courseResults.where((courseResult) => courseResult.courseId == courseId && courseResult.studentId == studentId).firstOrNull;
    if(existCourseResult != null){
      throw Exception("Student $studentId already recorded for $courseId");
    }

    CourseResult newCourseResult = CourseResult(courseId: courseId, studentId: studentId, score: score);
    courseResults.add(newCourseResult);
  }

}
