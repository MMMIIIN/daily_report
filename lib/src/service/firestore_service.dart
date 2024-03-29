import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/error/error_handling.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:daily_report/src/pages/list/controller/list_controller.dart';
import 'package:daily_report/src/pages/login/controller/login_controller.dart';
import 'package:daily_report/src/pages/login/login_page.dart';
import 'package:daily_report/src/pages/signup/controller/signup_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

String currentTodoTitleUid = '';
String currentTodoUid = '';

final TodoController _todoController = Get.put(TodoController());
final LoginController _loginController = Get.put(LoginController());
final ListController _listController = Get.put(ListController());
final SignUpController _signUpController = Get.put(SignUpController());
final ChartController _chartController = Get.put(ChartController());

Future<void> addTodoTitle(TodoTitle todoTitle) async {
  await FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todoTitle')
      .add({
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
        title: 'SUCCESS',
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
  await FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todoTitle')
      .get()
      .then(
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
  FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todoTitle')
      .doc(todoUid)
      .delete()
      .then(
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
      .then((value) async {})
      .catchError(
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
    'memoText': todo.memoText,
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
  }).then((value) async {
    currentTodoUid = value.id;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .doc(value.id)
        .update({'uid': value.id}).catchError((error) => print(error));
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
    'memoText': todo.memoText,
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
    String userEmail, String userPw, String signupName) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: userEmail,
      password: userPw,
    )
        .then((value) async{
      await _todoController.initUidTodoList();
      await _todoController.initTodoTitleList();
      await _loginController.clearTextField();
      await _listController.initSearchResult();
      await _listController.clearData();
      await _chartController.clearData();
      await FirebaseAuth.instance.currentUser!.updateDisplayName(signupName);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('info')
          .doc()
          .set({'name': signupName});
      await FirebaseFirestore.instance
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
        'title': 'ex) 꾹 눌러서 삭제',
        'titleColorIndex': 0,
        'uid': 'initData'
      });
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todoTitle')
          .doc('initData1')
          .set({
        'boolOfTime': true,
        'endHour': 18,
        'endMinute': 0,
        'startHour': 9,
        'startMinute': 0,
        'title': 'ex) 회사',
        'titleColorIndex': 1,
        'uid': 'initData1'
      });
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todoTitle')
          .doc('initData2')
          .set({
        'boolOfTime': false,
        'endHour': 1,
        'endMinute': 0,
        'startHour': 0,
        'startMinute': 0,
        'title': 'ex) 밥',
        'titleColorIndex': 2,
        'uid': 'initData2'
      });
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todoTitle')
          .doc('initData3')
          .set({
        'boolOfTime': true,
        'endHour': 21,
        'endMinute': 0,
        'startHour': 19,
        'startMinute': 0,
        'title': 'ex) 운동',
        'titleColorIndex': 3,
        'uid': 'initData3'
      });
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todoTitle')
          .doc('initData4')
          .set({
        'boolOfTime': false,
        'endHour': 1,
        'endMinute': 0,
        'startHour': 0,
        'startMinute': 0,
        'title': 'ex) 공부',
        'titleColorIndex': 4,
        'uid': 'initData4'
      });
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todos')
          .doc('initData')
          .set({
        'uid': 'initData',
        'year': DateTime.now().year,
        'month': DateTime.now().month,
        'day': DateTime.now().day,
        'title': 'ex) 회사',
        'memoText': '',
        'startHour': 9,
        'startMinute': 0,
        'endHour': 18,
        'endMinute': 0,
        'hourMinute': '9시간',
        'value': 540,
        'color': 1
      });
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todos')
          .doc('initData1')
          .set({
        'uid': 'initData1',
        'year': DateTime.now().year,
        'month': DateTime.now().month,
        'day': DateTime.now().day,
        'title': 'ex) 운동',
        'memoText': '',
        'startHour': 19,
        'startMinute': 0,
        'endHour': 21,
        'endMinute': 0,
        'hourMinute': '2시간',
        'value': 120,
        'color': 3
      });
      _signUpController.intiDataSet();
      await Get.off(() => Home());
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

Future<void> firebaseLogIn(String userId, String userPw) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: userId,
      password: userPw,
    )
        .then((value) async {
      _loginController.clickedButton(false);
      await _todoController.initUidTodoList();
      await _todoController.initTodoTitleList();
      await _loginController.clearTextField();
      await _listController.initSearchResult();
      await _listController.clearData();
      await _chartController.clearData();
      await Get.off(() => Home());
    });
  } on FirebaseAuthException catch (e) {
    await Get.showSnackbar(GetBar(
      title: 'ERROR',
      message: setErrorMessage(e.code),
      backgroundColor: errorColor,
      duration: Duration(seconds: 2),
    ));
  }
}

void firebaseForgotUserPassword(String email) async {
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      Get.off(() => LoginPage());
      Get.showSnackbar(GetBar(
        title: 'SUCCESS',
        message: '메일이 발송되었습니다.',
        duration: Duration(seconds: 2),
        backgroundColor: successColor,
      ));
      _loginController.forgotEmailController.value.clear();
      _loginController.forgotPasswordEmail('');
    });
  } on FirebaseAuthException catch (error) {
    await Get.showSnackbar(GetBar(
      title: 'ERROR',
      message: setErrorMessage(error.code),
      duration: Duration(seconds: 2),
      backgroundColor: errorColor,
    ));
  }
}

void deleteUser() async {
  try {
    deleteUserData();
    await FirebaseAuth.instance.currentUser!.delete();
    Get.back();
    await Get.showSnackbar(GetBar(
      title: 'SUCCESS',
      message: '계정이 탈퇴되었습니다.',
      duration: Duration(seconds: 2),
      backgroundColor: successColor,
    ));
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      await Get.showSnackbar(GetBar(
        title: 'ERROR',
        message: '재 로그인한 후 다시 시도해 주세요.',
        duration: Duration(seconds: 2),
        backgroundColor: errorColor,
      ));
    }
  }
}

void deleteUserData() async {
  await FirebaseFirestore.instance
      .collection('delete')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({'uid': FirebaseAuth.instance.currentUser!.uid
      });
}