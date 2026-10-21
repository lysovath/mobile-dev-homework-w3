import 'dart:math';

import 'package:test/test.dart';

import '../lib/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "Sovath");

    expect(lms.students.first.name, 'Sovath');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });

  test('Add Student to Course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: "Sovath");

    lms.createCourse(courseId: 'c1', courseName: 'Flutter');

    expect(lms.courses.first.name, "Flutter");

    lms.addStudentToCourse(studentId: 's1', courseId: 'c1');

    expect(lms.courses.first.studentIds.length, 1);

    lms.removeStudent(studentId: 's1');

    expect(lms.courses.first.studentIds.length, 0);
  });

  test("Record student result", () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: "Sovath");

    lms.createCourse(courseId: 'c1', courseName: 'Flutter');

    lms.addStudentToCourse(studentId: 's1', courseId: 'c1');

    lms.recordStudentScoreForCourse(studentId: 's1', courseId: 'c1', score: 85);

    expect(lms.courseResults.first.score, 85);

    lms.removeStudent(studentId: 's1');

    expect(lms.courseResults.length, 0);
  });

  test("Add a duplicate course id", () {
    final lms = LmsSystem();

    lms.createCourse(courseId: 'c1', courseName: "Flutter");
    
    expect(() => lms.createCourse(courseId: 'c1', courseName: "Dart"), throwsException);
  });

  test("Add none existing student to course", (){
    final lms = LmsSystem();

    lms.createCourse(courseId: 'c1', courseName: "Flutter");

    expect(() => lms.addStudent(studentId: 's1', studentName: "Sovath"),  throwsException);
  });

  test("Register student to a none existance course", (){
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: "Sovath");

    expect(() => lms.addStudentToCourse(studentId: 's1', courseId: 'c1'), throwsException);
  });

  test("Record score for none existing student", () {
    final lms = LmsSystem();

    lms.createCourse(courseId: 'c1', courseName: 'Flutter');

    expect(() => lms.recordStudentScoreForCourse(studentId: 's1', courseId: 'c1', score: 85), throwsException);
  });

  test("Record score in a none existing course", (){
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: "Sovath");

    expect(() => lms.recordStudentScoreForCourse(studentId: 's1', courseId: 'c1', score: 90), throwsException);
  });

  test("Record score for student that not in the course", () {
    final lms = LmsSystem();
    lms.createCourse(courseId: 'c1', courseName: "Flutter");
    lms.addStudent(studentId: 's1', studentName: "Sovath");

    expect(() => lms.recordStudentScoreForCourse(studentId: 's1', courseId: 'c1', score: 96), throwsException);
  });

  test("Record score for that already recorded for the student and course", (){
    final lms = LmsSystem();

    lms.createCourse(courseId: 'c1', courseName: "Flutter");
    lms.addStudent(studentId: 's1', studentName: "Sovath");
    lms.addStudentToCourse(studentId: 's1', courseId: 'c1');
    lms.recordStudentScoreForCourse(studentId: 's1', courseId: 'c1', score: 100);

    expect(() => lms.recordStudentScoreForCourse(studentId: 's1', courseId: 'c1', score: 20), throwsException);
  });
 }
