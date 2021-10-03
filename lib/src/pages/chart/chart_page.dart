import 'package:daily_report/color.dart';
import 'package:daily_report/src/pages/chart/controller/chart_controller.dart';
import 'package:daily_report/src/pages/chart/controller/select_date_controller.dart';
import 'package:daily_report/src/pages/chart/select_date_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

final ChartController _chartController = Get.put(ChartController());
final SelectDateController _selectDateController =
    Get.put(SelectDateController());

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
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text('기간 선택'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  selectDateTime(),
                  toggleButton(),
                ],
              ),
              showChart(context),
              chartList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget toggleButton() {
    return ToggleSwitch(
      minWidth: 40,
      minHeight: 30,
      totalSwitches: 2,
      initialLabelIndex: _chartController.modeIndex.value,
      labels: ['h', '%'],
      inactiveBgColor: context.theme.primaryColor.withOpacity(0.2),
      activeBgColor: [context.theme.primaryColor],
      onToggle: (index) {
        _chartController.setMode(index);
      },
    );
  }

  Widget selectDateTime() {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Get.to(() => SelectDatePage());
      },
      child: Container(
        width: context.mediaQuery.size.width * 0.65,
        height: 40,
        decoration: BoxDecoration(
            border: Border.all(color: context.theme.primaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_selectDateController.rangeStart.value.year}.'
              '${_selectDateController.rangeStart.value.month}.'
              '${_selectDateController.rangeStart.value.day} - '
              '${_selectDateController.rangeEnd.value.year}.'
              '${_selectDateController.rangeEnd.value.month}.'
              '${_selectDateController.rangeEnd.value.day}',
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showChart(BuildContext context) {
    return Obx(
      () => Flexible(
        flex: 3,
        child: _chartController.checkChartPageList.value.todoList.isNotEmpty
            ? PieChart(
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
                    });
                  }),
                  startDegreeOffset: 270,
                  sectionsSpace: 4,
                  centerSpaceRadius: context.mediaQuery.size.width / 5,
                  sections: List<PieChartSectionData>.generate(
                    _chartController.checkChartPageList.value.todoList.length,
                    (index) {
                      final isTouched = index == touchedIndex;
                      final radius = isTouched ? 70.0 : 50.0;
                      final title = _chartController.checkChartPageList.value
                                  .todoList[index].percent <
                              5
                          ? ''
                          : '${_chartController.checkChartPageList.value.todoList[index].percent.toStringAsFixed(0)}%';
                      return PieChartSectionData(
                        title: title,
                        radius: radius,
                        value: _chartController
                            .checkChartPageList.value.todoList[index].value
                            .toDouble(),
                        color: colorList[_chartController.checkChartPageList
                            .value.todoList[index].colorIndex],
                        badgeWidget: isTouched
                            ? Container(
                                width: 60,
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: colorList[_chartController
                                            .checkChartPageList
                                            .value
                                            .todoList[index]
                                            .colorIndex]
                                        .withOpacity(0.6)),
                                child: Center(
                                  child: Text(
                                    '${_chartController.checkChartPageList.value.todoList[index].title}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : null,
                        badgePositionPercentageOffset: 1.4,
                      );
                    },
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  Widget chartList() {
    return _chartController.checkChartPageList.value.todoList.isNotEmpty
        ? Flexible(
            flex: 1,
            child: GridView.builder(
              itemCount:
                  _chartController.checkChartPageList.value.todoList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 50,
                mainAxisExtent: 30,
              ),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorList[_chartController.checkChartPageList
                                .value.todoList[index].colorIndex]),
                      ),
                      SizedBox(width: 4),
                      Row(
                        children: [
                          Text(
                            '${_chartController.checkChartPageList.value.todoList[index].title}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          _chartController.modeIndex.value == 1
                              ? Text(
                                  ' ${_chartController.checkChartPageList.value.todoList[index].percent.toStringAsFixed(1)} %',
                                  style: TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  ' ${_chartController.checkChartPageList.value.todoList[index].hourMinute}',
                                  style: TextStyle(fontSize: 13))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  @override
  void initState() {
    // TODO: implement initState
    _chartController.makeRangeDate();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
