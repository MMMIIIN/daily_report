import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  int touchedIndex = -1;
  final TodoController _todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                    setState(() {
                      final desiredTouch =
                          pieTouchResponse.touchInput is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                      if (desiredTouch &&
                          pieTouchResponse.touchedSection != null) {
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      } else {
                        touchedIndex = -1;
                      }
                      print(touchedIndex);
                    });
                  }),
                  startDegreeOffset: 270,
                  sectionsSpace: 4,
                  centerSpaceRadius: 60,
                  sections: List<PieChartSectionData>.generate(
                      _todoController.chartClassList.length, (index) {
                    final isTouched = index == touchedIndex;
                    final radius = isTouched ? 100.0 : 80.0;
                    final title = isTouched
                        ? _todoController
                            .chartClassList[index].chartSectionData.title
                        : '';
                    return PieChartSectionData(
                      title: title,
                      color: _todoController
                          .chartClassList[index].chartSectionData.color,
                      value: _todoController
                          .chartClassList[index].chartSectionData.value,
                      radius: radius,
                    );
                  }),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(30),
              width: double.infinity,
              height: 200,
              // color: Colors.orangeAccent,
              child: Obx(
                () => GridView.builder(
                  itemCount: _todoController.chartClassList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 50,
                    mainAxisExtent: 30,
                    // mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _todoController.chartClassList[index]
                                  .chartSectionData.color),
                        ),
                        SizedBox(width: 4),
                        Row(
                          children: [
                            Text(
                              _todoController
                                  .chartClassList[index].chartSectionData.title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' ${_todoController.chartClassList[index].percent} %',
                              style: TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                        // Text(_todoController.chartClassList[index].chartSectionData.value.toString()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
