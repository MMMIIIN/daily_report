import 'package:daily_report/color.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
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

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  var now = DateTime.now();
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Obx(
        () => Column(
          children: [
            MaterialButton(
              onPressed: () {
                _chartController.setMode();
              },
              child: Icon(Icons.add),
            ),
            Flexible(
              flex: 3,
              child: _chartController.checkChartPageList.value.todoList.isNotEmpty
                  ? PieChart(
                      PieChartData(
                        pieTouchData:
                            PieTouchData(touchCallback: (pieTouchResponse) {
                          setState(() {
                            final desiredTouch = pieTouchResponse.touchInput
                                    is! PointerExitEvent &&
                                pieTouchResponse.touchInput is! PointerUpEvent;
                            if (desiredTouch &&
                                pieTouchResponse.touchedSection != null) {
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            } else {
                              touchedIndex = -1;
                            }
                            // print(touchedIndex);
                          });
                        }),
                        startDegreeOffset: 270,
                        sectionsSpace: 4,
                        centerSpaceRadius: 130,
                        sections: List<PieChartSectionData>.generate(
                          _chartController.checkChartPageList.value.todoList.length,
                          (index) {
                            final isTouched = index == touchedIndex;
                            final radius = isTouched ? 70.0 : 50.0;
                            final title = isTouched
                                ? _chartController
                                    .checkChartPageList.value.todoList[index].title
                                : '';
                            return PieChartSectionData(
                              title: title,
                              radius: radius,
                              value: _chartController
                                  .checkChartPageList.value.todoList[index].value
                                  .toDouble(),
                              color: colorList[_chartController.checkChartPageList
                                  .value.todoList[index].colorIndex],
                            );
                          },
                        ),
                      ),
                    )
                  : Container(),
            ),

            Obx(
              () => Flexible(
                flex: 1,
                child: _chartController.checkChartPageList.value.todoList.isNotEmpty
                    ? GridView.builder(
                        itemCount: _chartController
                            .checkChartPageList.value.todoList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 50,
                          mainAxisExtent: 30,
                          // mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorList[_chartController
                                          .checkChartPageList
                                          .value
                                          .todoList[index]
                                          .colorIndex]),
                                ),
                                SizedBox(width: 4),
                                Row(
                                  children: [
                                    Text(
                                      '${_chartController.checkChartPageList.value.todoList[index].title}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    _chartController.mode.value
                                        ? Text(
                                            ' ${_chartController.checkChartPageList.value.todoList[index].percent} %',
                                            style: TextStyle(fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Text(
                                            ' ${_chartController.checkChartPageList.value.todoList[index].hourMinute}')
                                  ],
                                ),
                                // Text(_todoController.chartClassList[index].chartSectionData.value.toString()),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
