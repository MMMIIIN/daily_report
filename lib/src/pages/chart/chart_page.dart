import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartPage extends StatelessWidget {
  // final ChartController _chartController = Get.put(ChartController());
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
                  pieTouchData: PieTouchData(
                    // touchCallback: (pieTouchResponse){
                    //   final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                    //       pieTouchResponse.touchInput is! PointerUpEvent;
                    //   if(desiredTouch && pieTouchResponse.touchedSection != null) {
                    //     touchedIndex =
                    //   }
                    // }
                  ),
                  startDegreeOffset: 270,
                    sectionsSpace: 4,
                    centerSpaceRadius: 60,
                    sections: List<PieChartSectionData>.generate(
                        _todoController.chartClassList.length,
                        (index) => PieChartSectionData(
                          showTitle: false,
                            // title: _todoController.chartList[index].title,
                            // color: _todoController.chartList[index].color,
                            // value: _todoController.chartList[index].value,
                            title: _todoController.chartClassList[index].chartSectionData.title,
                            color: _todoController.chartClassList[index].chartSectionData.color,
                            value: _todoController.chartClassList[index].chartSectionData.value,
                            radius: 80))),
              ),
            ),
            Container(
              padding: EdgeInsets.all(30),
                width: double.infinity,
                height: 200,
                // color: Colors.orangeAccent,
                child: Obx(() =>  GridView.builder(
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _todoController.chartClassList[index].chartSectionData.color
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(_todoController.chartClassList[index].chartSectionData.title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          // Text(_todoController.chartClassList[index].chartSectionData.value.toString()),
                          Text(' ${_todoController.chartClassList[index].percent} %',
                          style: TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    )))),
          ],
        ),
      ),
    );
  }
}
