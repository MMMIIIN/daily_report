import 'package:daily_report/src/data/todo/todo_controller.dart';
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

// final ChartController _chartController = Get.put(ChartController());

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
      child: Column(
        // children: [
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       GestureDetector(
        //         onTap: () {
        //           print(DateTime.now());
        //           print(_chartController.currentIndex.value);
        //           _chartController.setCurrentTodoIndex(DateTime.now());
        //         },
        //         child: Container(
        //           child: Text('${SelectDate.values[0].name}'),
        //         ),
        //       ),
        //       GestureDetector(
        //         onTap: () {
        //           var date1 = DateTime(now.year, now.month, now.day - 3);
        //           var date2 = DateTime(now.year, now.month, now.day + 3);
        //           print(date1);
        //           print(date2);
        //           _chartController
        //               .setIndexList(DateTimeRange(start: date1, end: date2));
        //         },
        //         child: Container(
        //           child: Text('${SelectDate.values[1].name}'),
        //         ),
        //       ),
        //       GestureDetector(
        //         onTap: () {
        //           var date1 = DateTime(now.year, now.month, 1);
        //           var date2 = DateTime(
        //               now.year, now.month, _chartController.getDay(now.month));
        //           print(date1);
        //           print(date2);
        //           _chartController
        //               .setIndexList(DateTimeRange(start: date1, end: date2));
        //         },
        //         child: Container(
        //           child: Text('${SelectDate.values[2].name}'),
        //         ),
        //       ),
        //       GestureDetector(
        //         onTap: () {},
        //         child: Container(
        //           child: Text('${SelectDate.values[3].name}'),
        //         ),
        //       ),
        //     ],
        //   ),
        //   Obx(
        //     () => Flexible(
        //       flex: 3,
        //       child: _chartController.chartPageList.isNotEmpty
        //           ? PieChart(
        //               PieChartData(
        //                 pieTouchData:
        //                     PieTouchData(touchCallback: (pieTouchResponse) {
        //                   setState(() {
        //                     final desiredTouch = pieTouchResponse.touchInput
        //                             is! PointerExitEvent &&
        //                         pieTouchResponse.touchInput is! PointerUpEvent;
        //                     if (desiredTouch &&
        //                         pieTouchResponse.touchedSection != null) {
        //                       touchedIndex = pieTouchResponse
        //                           .touchedSection!.touchedSectionIndex;
        //                     } else {
        //                       touchedIndex = -1;
        //                     }
        //                     // print(touchedIndex);
        //                   });
        //                 }),
        //                 startDegreeOffset: 270,
        //                 sectionsSpace: 4,
        //                 centerSpaceRadius: 130,
        //                 sections: List<PieChartSectionData>.generate(
        //                   _chartController.chartPageList.first.data.length,
        //                   (index) {
        //                     final isTouched = index == touchedIndex;
        //                     final radius = isTouched ? 70.0 : 50.0;
        //                     final title = isTouched
        //                         ? _chartController
        //                             .chartPageList.first.data[index].data.title
        //                         : '';
        //                     return PieChartSectionData(
        //                       title: title,
        //                       radius: radius,
        //                       value: _chartController
        //                           .chartPageList.first.data[index].data.value,
        //                       color: _chartController
        //                           .chartPageList.first.data[index].data.color,
        //                     );
        //                   },
        //                 ),
        //               ),
        //             )
        //           : Container(),
        //     ),
        //   ),
        //   Obx(
        //     () => Flexible(
        //       flex: 1,
        //       child: _chartController.chartPageList.first.data.isNotEmpty
        //           ? GridView.builder(
        //               itemCount:
        //                   _chartController.chartPageList.first.data.length,
        //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //                 crossAxisCount: 2,
        //                 crossAxisSpacing: 50,
        //                 mainAxisExtent: 30,
        //                 // mainAxisSpacing: 5,
        //               ),
        //               itemBuilder: (context, index) => Padding(
        //                 padding: EdgeInsets.symmetric(horizontal: 10),
        //                 child: SingleChildScrollView(
        //                   scrollDirection: Axis.horizontal,
        //                   child: Row(
        //                     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                     // crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       Container(
        //                         width: 16,
        //                         height: 16,
        //                         decoration: BoxDecoration(
        //                             shape: BoxShape.circle,
        //                             color: _chartController.chartPageList.first
        //                                 .data[index].data.color),
        //                       ),
        //                       SizedBox(width: 4),
        //                       Row(
        //                         children: [
        //                           Text(
        //                             _chartController.chartPageList.first
        //                                 .data[index].data.title,
        //                             style: TextStyle(
        //                                 fontSize: 16,
        //                                 fontWeight: FontWeight.bold),
        //                           ),
        //                           Text(
        //                             ' ${_chartController.chartPageList.first.data[index].percent} %',
        //                             style: TextStyle(fontSize: 13),
        //                             overflow: TextOverflow.ellipsis,
        //                           )
        //                         ],
        //                       ),
        //                       // Text(_todoController.chartClassList[index].chartSectionData.value.toString()),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             )
        //           : Container(),
        //     ),
        //   ),
        // ],
      ),
    ));
  }
}
