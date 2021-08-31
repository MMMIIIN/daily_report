import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/error/error_handling.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

final userUid = FirebaseAuth.instance.currentUser!.uid;
final userTodo = FirebaseFirestore.instance.collection('user').doc(userUid);
String currentTodoTitleUid = '';
String currentTodoUid = '';

Future<void> addTodoTitle(TodoTitle todoTitle) async {
  await userTodo.collection('todoTitle').add({
    'title': todoTitle.title,
    'titleColorIndex': todoTitle.titleColor,
    'uid': 'null',
    'startHour': todoTitle.timeRange!.startTime.hour,
    'startMinute': todoTitle.timeRange!.startTime.minute,
    'endHour': todoTitle.timeRange!.endTime.hour,
    'endMinute': todoTitle.timeRange!.endTime.minute,
    'boolOfTime': todoTitle.boolOfTime
  }).then((value) async {
    await value.update(
      {'uid': value.id},
    );
    currentTodoTitleUid = value.id;
    Get.back();
    await Get.showSnackbar(
      GetBar(
        title: 'SUCCESS!',
        message: '성공적으로 추가되었습니다.',
        backgroundColor: successColor,
        duration: Duration(seconds: 1),
      ),
    );
  }).catchError(
    (error) async => await Get.showSnackbar(
      GetBar(
        title: 'ERROR',
        message: error.toString(),
      ),
    ),
  );
}

Future<List<TodoTitle>> getTodoTitleData() async {
  var todoTitleList = <TodoTitle>[];
  TodoTitle loadData;
  await userTodo.collection('todoTitle').get().then(
    (value) {
      value.docs.forEach(
        (data) {
          loadData = TodoTitle(
              title: data['title'],
              titleColor: data['titleColorIndex'],
              uid: data['uid'],
              boolOfTime: data['boolOfTime'],
              timeRange: TimeRange(
                  startTime: TimeOfDay(
                      hour: data['startHour'], minute: data['startMinute']),
                  endTime: TimeOfDay(
                      hour: data['endHour'], minute: data['endMinute'])));
          todoTitleList.add(loadData);
        },
      );
    },
  );
  return todoTitleList;
}

void deleteTodoTitle(String todoUid) {
  userTodo.collection('todoTitle').doc(todoUid).delete().then(
        (value) => Get.showSnackbar(
          GetBar(
            title: 'SUCCESS',
            message: '성공적으로 삭제되었습니다.',
            duration: Duration(
              seconds: 1,
            ),
            backgroundColor: successColor,
          ),
        ),
      );
}

Future<void> todoFirebaseDelete(String todoUid) async {
  await FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos')
      .doc(todoUid)
      .delete()
      .then((value) {
    Get.back();
    Get.back();
    Get.showSnackbar(GetBar(
      duration: Duration(seconds: 2),
      title: 'SUCCESS',
      message: '성공적으로 삭제되었습니다.',
      backgroundColor: successColor,
    ));
  }).catchError(
    (error) async => await Get.showSnackbar(
      GetBar(
        title: 'DELETE',
        message: 'ERROR!',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: errorColor,
      ),
    ),
  );
}

Future<void> addFireStore(TestTodo todo) async {
  return await FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos')
      .add({
    'title': todo.title,
    'startHour': todo.startHour,
    'startMinute': todo.startMinute,
    'endHour': todo.endHour,
    'endMinute': todo.endMinute,
    'uid': 'NULL',
    'value': todo.value,
    'color': todo.colorIndex,
    'year': todo.ymd.year,
    'month': todo.ymd.month,
    'day': todo.ymd.day,
    'hourMinute': todo.hourMinute
  }).then((value) async{
    currentTodoUid = value.id;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .doc(value.id)
        .update({'uid': value.id})
        .catchError((error) => print(error));
    await Get.showSnackbar(GetBar(
      title: 'SUCCESS',
      message: '성공적으로 추가되었습니다.',
      duration: Duration(seconds: 1),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: successColor,
    ));
  }).catchError(
    (error) async => await Get.showSnackbar(
      GetBar(
        title: 'ERROR',
        message: '로그인 정보를 확인하세요',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: errorColor,
      ),
    ),
  );
}

Future<void> updateFireStore(TestTodo todo) async {
  return await FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos')
      .doc(todo.uid)
      .update({
    'title': todo.title,
    'startHour': todo.startHour,
    'startMinute': todo.startMinute,
    'endHour': todo.endHour,
    'endMinute': todo.endMinute,
    'uid': todo.uid,
    'value': todo.value,
    'color': todo.colorIndex,
    'year': todo.ymd.year,
    'month': todo.ymd.month,
    'day': todo.ymd.day,
    'hourMinute': todo.hourMinute
  }).then((value) {
    Get.showSnackbar(GetBar(
      title: 'UPDATE',
      message: 'success!!',
      duration: Duration(seconds: 2),
      backgroundColor: successColor,
      snackPosition: SnackPosition.BOTTOM,
    ));
  }).catchError(
    (error) async => await Get.showSnackbar(
      GetBar(
        title: 'UPDATE',
        message: 'ERROR!',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: errorColor,
      ),
    ),
  );
}

Future<void> firebaseAuthSignUp(
    String userEmail, String userPw, String signupName, int genderIndex) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: userEmail,
      password: userPw,
    )
        .then((value) {
      FirebaseAuth.instance.currentUser!.updateDisplayName(signupName);
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('info')
          .doc()
          .set({'gender': genderIndex, 'name': signupName});
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todoTitle')
          .doc('initData')
          .set({
        'boolOfTime': false,
        'endHour': 1,
        'endMinute': 0,
        'startHour': 0,
        'startMinute': 0,
        'title': '꾹 눌러서 삭제',
        'titleColorIndex': 0,
        'uid': 'initData'
      });
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todos')
          .doc('initData')
          .set({
        'uid': 'initData',
        'year': DateTime.now().year,
        'month': DateTime.now().month,
        'day': DateTime.now().day,
        'title': '회원가입',
        'startHour': DateTime.now().hour,
        'startMinute': DateTime.now().minute,
        'endHour': DateTime.now().hour + 1,
        'endMinute': DateTime.now().minute,
        'value': 60,
        'colorIndex': 0
      });
    });
  } on FirebaseAuthException catch (e) {
    await Get.showSnackbar(GetBar(
      title: 'ERROR',
      message: setErrorMessage(e.code),
      backgroundColor: errorColor,
      duration: Duration(seconds: 2),
    ));
  } catch (e) {
    print(e);
  }
}
