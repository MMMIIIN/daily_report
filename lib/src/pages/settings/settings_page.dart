import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';

final SettingsController _settingsController = Get.put(SettingsController());

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  CollectionReference todo = FirebaseFirestore.instance.collection('todo');

  TodoUidList testList = TodoUidList(todoList: []);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: Column(
      //   children: [
      // ToggleSwitch(
      //   totalSwitches: 2,
      //   initialLabelIndex: _settingsController.isDarkModeIndex.value,
      //   onToggle: (index) {
      //     _settingsController.setDarkModeIndex(index);
      //   },
      // ),
      // MaterialButton(
      //   onPressed: () async {
      //     todo.add({
      //       'title': 'game',
      //       'startHour' : 17,
      //       'startMinute' : 0,
      //       'endHour' : 21,
      //       'endMinute' : 0,
      //       'uid' : '9XoRxqBWcORF4AyFvazE5mxEKMv1',
      //       'value' : 240,
      //       'color' : 3,
      //       'year' : 2021,
      //       'month' : 7,
      //       'day' : 27
      //     }).then((value) => print('Todo Added'))
      //     .catchError((error) => print('Failed to add todo: $error'));
      //   },
      //   child: Text('click'),
      // ),

      // FutureBuilder<DocumentSnapshot>(
      //   future: todo.doc('LgqGidT6brJKbfSnwy25').get(),
      //   builder: (BuildContext context,
      //       AsyncSnapshot<DocumentSnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       print(hashCode);
      //       return Text("Something went wrong");
      //     }
      //
      //     if (snapshot.hasData && !snapshot.data!.exists) {
      //       return Text("Document does not exist");
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       Map<String, dynamic> data =
      //           snapshot.data!.data() as Map<String, dynamic>;
      //       return Flexible(
      //         child: StreamBuilder(
      //           stream: todo.snapshots(),
      //             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
      //             return ListView(
      //               children: snapshot.data!.docs.map((todo) {
      //                 return Text(todo['title']);
      //               }).toList(),
      //             );
      //         }),
      //       );
      //     }
      //
      //     return Text("loading");
      //   },
      // ),
      child: StreamBuilder(
          stream: todo.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Column(
              children: [
                MaterialButton(
                  onPressed: () {
                    testList.todoList.clear();
                    for (var todo in snapshot.data!.docs) {
                      testList.todoList.add(
                          TestTodo(uid: todo['uid'],
                              ymd: DateTime(
                                  todo['year'], todo['month'], todo['day']
                              ),
                              title: todo['title'],
                              startHour: todo['startHour'],
                              startMinute: todo['startMinute'],
                              endHour: todo['endHour'],
                              endMinute: todo['endMinute'],
                              value: todo['value'],
                              colorIndex: todo['color'])
                      );
                    }
                    testList.todoList.forEach((element) {
                      print(element.title);
                      print(element.value);
                      print(element.ymd);
                      print(element.startHour);
                      print(element.startMinute);
                      print(element.endHour);
                      print(element.endMinute);
                      print(element.colorIndex);
                      print(element.uid);



                    });
                  },
                  child: Text('asdf'),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: TableCalendar(
                      calendarBuilders: CalendarBuilders(
                        selectedBuilder: (context, date, events) =>
                            Container(
                              margin: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              // decoration: BoxDecoration(
                              //     color: isDarkMode
                              //         ? Colors.grey
                              //         : primaryColor,
                              //     borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        todayBuilder: (context, date, events) =>
                            Container(
                              margin: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xff95afc0),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        // markerBuilder: (context, date, _) {
                        //   if (isDarkMode && _.isNotEmpty) {
                        //     return Padding(
                        //       padding: const EdgeInsets.only(bottom: 5.0),
                        //       child: Container(
                        //         width: 7,
                        //         height: 7,
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(10),
                        //             color: Colors.white),
                        //       ),
                        //     );
                        //   }
                        // },
                      ),
                      firstDay: DateTime(2020, 1, 1),
                      lastDay: DateTime(2030, 12, 31),
                      focusedDay: DateTime.now(),
                      // selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      // calendarFormat: _calendarFormat,
                      calendarStyle: CalendarStyle(
                        weekendTextStyle: TextStyle(color: Colors.red),
                        holidayTextStyle: TextStyle(color: Colors.blue),
                      ),
                      eventLoader: (day) {
                        for (var checkTodo in testList.todoList) {
                          if (day == checkTodo.ymd) {
                            return [Container()];
                          }
                        }
                        return [];
                      },
                      // onDaySelected: _onDaySelected,
                      // onFormatChanged: (format) {
                      //   if (_calendarFormat != format) {
                      //     setState(() {
                      //       _calendarFormat = format;
                      //     });
                      //   }
                      // },
                      // onPageChanged: (focusedDay) {
                      //   // _focusedDay = focusedDay;
                      //   _todoController.currentDateTime(focusedDay);
                      // },
                    ),
                  ),
                ),
                Flexible(
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                          touchCallback: (pieTouchResponse) {}),
                      startDegreeOffset: 270,
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: List<PieChartSectionData>.generate(
                          testList.todoList.length, (index) {
                        // final isTouched = index == touchedIndex;
                        // final radius = isTouched ? 70.0 : 50.0;
                        // final title = isTouched
                        //     ? _todoController
                        //     .currentUidList.value.todoList[index].title
                        //     : '';
                        return PieChartSectionData(
                          title: testList.todoList[index].title,
                          color: colorList[testList.todoList[index].colorIndex + index],
                          value: testList.todoList[index].value.toDouble(),
                          radius: 50,
                        );
                      }),
                    ),
                  ),
                ),
              ],
            );
          }),
      // MaterialButton(
      //   onPressed: () async {
      //     await FirebaseAuth.instance.signOut();
      //   },
      //   child: Text('logout'),
      // )
      // ],
    );
  }
}
