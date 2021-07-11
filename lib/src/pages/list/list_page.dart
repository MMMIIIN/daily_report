import 'package:daily_report/color.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/list/add_todo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ListPage extends StatelessWidget {
  final TodoController _todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        height: Get.mediaQuery.size.height * 0.85,
        color: Colors.transparent,
        child: Obx(
          () => Column(
            children: [
              searchWidget(),
              showListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // border: Border.all()
            color: Colors.black12),
        child: TextField(
          onChanged: (text) {
            _todoController.searchTerm(text);
          },
          controller: _todoController.searchTitleController.value,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: _todoController.searchTerm.value != ''
                  ? IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        _todoController.searchTerm('');
                        _todoController.searchTitleController.value.clear();
                      },
                    )
                  : null,
              hintText: '검색'),
        ),
      ),
    );
  }

  Widget showListView() {
    final searchResult =
        _todoController.searchTitle(_todoController.searchTerm.value);
    return Expanded(
      child: ListView.builder(
        itemCount: searchResult.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onTap: () {
              _todoController.titleTextController.value.text =
                  searchResult[index].title;
              _todoController.setTime(
                TimeRange(
                  startTime: TimeOfDay(
                      hour: searchResult[index].startHour,
                      minute: searchResult[index].startMinute),
                  endTime: TimeOfDay(
                      hour: searchResult[index].endHour,
                      minute: searchResult[index].endMinute),
                ),
              );
              Get.to(AddTodo(editMode: true,));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              height: Get.mediaQuery.size.height * 0.08,
              decoration: BoxDecoration(
                  color: colorList[searchResult[index].colorIndex],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${searchResult[index].ymd.year}.'
                      '${searchResult[index].ymd.month}.'
                      '${searchResult[index].ymd.day}'),
                  Text(searchResult[index].title),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Text('${searchResult[index].startHour} : '
                          '${searchResult[index].startMinute}'),
                      SizedBox(width: 20),
                      Text('${searchResult[index].endHour} : '
                          '${searchResult[index].endMinute}')
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
