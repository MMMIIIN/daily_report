import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SelectDate { TODAY, WEEK, MONTH, CUSTOM }

extension SelectDateExtension on SelectDate {
  String get name {
    switch (this) {
      case SelectDate.TODAY:
        return '오 늘';
      case SelectDate.WEEK:
        return '1 주';
      case SelectDate.MONTH:
        return '1 달';
      case SelectDate.CUSTOM:
        return '직접 입력';
    }
  }
}

final ChartController _chartController = Get.put(ChartController());

class ChartPage extends StatelessWidget {
  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  print(DateTime.now());
                  _chartController.setCurrentTodoIndex(DateTime.now());
                  print(_chartController.currentIndex.value);
                },
                child: Container(
                  child: Text('${SelectDate.values[0].name}'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var date1 = DateTime(now.year, now.month, now.day - 3);
                  var date2 = DateTime(now.year, now.month, now.day + 4);
                  print(date1);
                  print(date2);
                },
                child: Container(
                  child: Text('${SelectDate.values[1].name}'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var date1 = DateTime(now.year, now.month, 1);
                  var date2 = DateTime(
                      now.year, now.month, _chartController.getDay(now.month));
                  print(date1);
                  print(date2);
                },
                child: Container(
                  child: Text('${SelectDate.values[2].name}'),
                ),
              ),
              Container(
                child: Text('${SelectDate.values[3].name}'),
              ),
            ],
          ),
          Obx(() => Expanded(
            child: _chartController.currentIndex.value != 0 ? PieChart(
              PieChartData(
                sections: List<PieChartSectionData>.generate(
                  _chartController.chartPageList[_chartController.currentIndex.value].data.length,
                  (index) {
                    return PieChartSectionData(
                      title: _chartController
                          .chartPageList[_chartController.currentIndex.value]
                          .data[index]
                          .data
                          .title,
                      value: _chartController
                          .chartPageList[_chartController.currentIndex.value]
                          .data[index]
                          .data
                          .value,
                      color: _chartController
                          .chartPageList[_chartController.currentIndex.value]
                          .data[index]
                          .data
                          .color,
                    );
                  },
                ),
              ),
            ) : Container()
          ),
          ),
        ],
      ),
    ));
  }
}
