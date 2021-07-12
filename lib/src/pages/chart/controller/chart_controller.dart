import 'package:daily_report/src/data/todo/chart_date_data.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:get/get.dart';

final TodoController _todoController = Get.put(TodoController());

class ChartController extends GetxController {
  RxInt currentTodoIndex = 0.obs;
  RxInt currentIndex = 0.obs;
  Rx<TodoUidList> chartPageList = TodoUidList(todoList: []).obs;
  double totalSum = 0;
  RxBool mode = false.obs;

  void makeMonthChart(int month) {
    chartPageList.value.todoList.clear();
    chartPageList.value.todoList.addAll(_todoController
        .todoUidList.value.todoList
        .where((element) => element.ymd.month == month));
    sortChartList();
    setPercent();
    setHourMinute();
  }

  void setHourMinute() {
    for(int i = 0; i < chartPageList.value.todoList.length; i++){
      chartPageList.value.todoList[i].hourMinute = '${(chartPageList.value.todoList[i].value / 60).toInt()}h '
      '${chartPageList.value.todoList[i].value % 60}m';
    }
  }

  void setMode() {
    mode(!mode.value);
    print(mode.value);
  }

  // void initChartPageList() {
  //   chartPageList
  //       .add(ChartDateData(ymd: YMD(year: 2019, month: 1, day: 1), data: [
  //     // ChartDataPercent(
  //     //     data: PieChartSectionData(
  //     //         title: 'test', value: 50, color: Colors.green))
  //   ]));
  // }
  //
  // void setCurrentTodoIndex(DateTime _dateTime) {
  //   var index = _todoController.todoUidList.todoList.indexWhere((element) =>
  //       element.year == _dateTime.year &&
  //       element.month == _dateTime.month &&
  //       element.day == _dateTime.day);
  //   print('index = $index');
  //   if (index == -1) {
  //     currentIndex(0);
  //   } else {
  //     currentTodoIndex(index);
  //   }
  //   print('currentTodoIndex.value = ${currentTodoIndex.value}');
  //   if (currentTodoIndex.value != 0) {
  //     addChartPageList(_dateTime);
  //   }
  // }
  //
  // void addChartPageList(DateTime _dateTime) {
  //   chartPageList.clear();
  //
  //   chartPageList.add(ChartDateData(
  //       ymd: YMD(
  //           year: _dateTime.year, month: _dateTime.month, day: _dateTime.day),
  //       data: []));
  //   for (int index = 0;
  //       index <
  //           _todoController.chartClassList[currentTodoIndex.value].data.length;
  //       index++) {
  //     print('add실행 $index');
  //     // chartPageList[index].data.add(value)
  //     chartPageList.first.data.add(ChartDataPercent(
  //         data: _todoController
  //             .chartClassList[currentTodoIndex.value].data[index].data,
  //         timeRange: _todoController
  //             .chartClassList[currentTodoIndex.value].data[index].timeRange));
  //   }
  //   sortChartList();
  // }
  //
  // void setCurrentIndex(DateTime _dateTime) {
  //   var index = chartPageList.indexWhere((element) =>
  //       element.ymd.year == _dateTime.year &&
  //       element.ymd.month == _dateTime.month &&
  //       element.ymd.day == _dateTime.day);
  //   currentIndex(index);
  //   print('currentIndex = ${currentIndex.value}');
  // }
  //
  // RxList indexList = [].obs;
  //
  // void setIndexList(DateTimeRange dateTimeRange) {
  //   indexList.clear();
  //   print(dateTimeRange);
  //   for (int index = 0;
  //       index < dateTimeRange.end.day - dateTimeRange.start.day;
  //       index++) {
  //     int addIndex = _todoController.chartClassList.indexWhere((element) =>
  //         element.ymd.year == dateTimeRange.start.year &&
  //         element.ymd.month == dateTimeRange.start.month &&
  //         element.ymd.day == dateTimeRange.start.day + index);
  //     if (addIndex != -1) {
  //       indexList.add(addIndex);
  //     }
  //   }
  //   addChartListRange(dateTimeRange);
  // }
  //
  // void addChartListRange(DateTimeRange dateTimeRange) {
  //   chartPageList.clear();
  //   chartPageList.add(ChartDateData(
  //       ymd: YMD(
  //           year: dateTimeRange.start.year,
  //           month: dateTimeRange.start.month,
  //           day: dateTimeRange.start.day),
  //       data: []));
  //
  //   for (int index = 0; index < indexList.length; index++) {
  //     for (int i = 0;
  //         i < _todoController.chartClassList[indexList[index]].data.length;
  //         i++) {
  //       chartPageList.first.data.add(ChartDataPercent(
  //           data: _todoController.chartClassList[indexList[index]].data[i].data,
  //           timeRange: _todoController
  //               .chartClassList[indexList[index]].data[i].timeRange));
  //     }
  //   }
  //   sortChartList();
  //   setPercent();
  // }
  //
  void setPercent() {
    totalSum = 0;
    for (int i = 0; i < chartPageList.value.todoList.length; i++) {
      totalSum += chartPageList.value.todoList[i].value;
    }
    for (int i = 0; i < chartPageList.value.todoList.length; i++) {
      chartPageList.value.todoList[i].percent =
          (chartPageList.value.todoList[i].value / totalSum * 100)
              .roundToDouble();
    }
  }

  //
  void sortChartList() {
    chartPageList.value.todoList.sort((a, b) => b.value.compareTo(a.value));
    // update();
  }

  int getDay(int currentMonth) {
    var day = 0;
    if (currentMonth == 1) {
      day = 31;
    }
    if (currentMonth == 2) {
      day = 28;
    }
    if (currentMonth == 3) {
      day = 31;
    }
    if (currentMonth == 4) {
      day = 30;
    }
    if (currentMonth == 5) {
      day = 31;
    }
    if (currentMonth == 6) {
      day = 30;
    }
    if (currentMonth == 7) {
      day = 31;
    }
    if (currentMonth == 8) {
      day = 31;
    }
    if (currentMonth == 9) {
      day = 30;
    }
    if (currentMonth == 10) {
      day = 31;
    }
    if (currentMonth == 11) {
      day = 30;
    }
    if (currentMonth == 12) {
      day = 31;
    }
    return day;
  }

  @override
  void onInit() {
    super.onInit();
    makeMonthChart(DateTime.now().month);
  }
}
