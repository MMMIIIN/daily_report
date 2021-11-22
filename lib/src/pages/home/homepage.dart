import 'package:daily_report/color.dart';
import 'package:daily_report/icons.dart';
import 'package:daily_report/src/data/todo/todo_controller.dart';
import 'package:daily_report/src/pages/add/add_todo.dart';
import 'package:daily_report/src/pages/settings/controller/settings_controller.dart';
import 'package:daily_report/src/service/firestore_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

final TodoController _todoController = Get.put(TodoController());
final SettingsController _settingsController = Get.put(SettingsController());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int touchedIndex = -1;
  DateTime _selectedDay = _todoController.currentDateTime.value;
  bool isPercentOrHour = GetStorage().read('isPercentOrHour') ?? false;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _todoController.initHome(_selectedDay);
        _todoController.selectDateTime(_selectedDay);
      });
    } else {
      setState(() {
        _todoController.initHome(_selectedDay);
        _todoController.selectDateTime(_selectedDay);
      });
    }
  }

  BannerAd? _banner;
  bool _loadingBanner = false;

  Future<void> _createBanner(BuildContext context, String unitId) async {
    final size = await AdSize.getAnchoredAdaptiveBannerAdSize(
        Orientation.portrait, MediaQuery.of(context).size.width.truncate()
        );
    if (size == null) {
      return;
    }
    final banner = BannerAd(
      size: size,
      request: AdRequest(),
      adUnitId: unitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _banner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
      ),
    );
    return banner.load();
  }

  @override
  Widget build(BuildContext context) {
    var unitId = Theme.of(context).platform == TargetPlatform.iOS
        ? 'ca-app-pub-2775109453177746/9063523768'
        : 'ca-app-pub-2775109453177746/4898386775';
    if (!_loadingBanner) {
      _loadingBanner = true;
      _createBanner(context, unitId);
    }
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            showCalendar(),
            if(_banner != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: _banner!.size.width.toDouble(),
                  height: _banner!.size.height.toDouble(),
                  child: AdWidget(
                    ad: _banner!,
                  ),
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    showChart(),
                    showChartList(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showCalendar() {
    return Obx(
      () => TableCalendar(
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, events) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color:
                    colorList[_settingsController.selectPrimaryColorIndex.value]
                        .withOpacity(0.9),
                borderRadius: BorderRadius.circular(10)),
            child: date.year == DateTime.now().year &&
                    date.month == DateTime.now().month &&
                    date.day == DateTime.now().day
                ? Column(
                    children: [
                      Text(
                        'today',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )
                : Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
          ),
          todayBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  'today',
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
                date.weekday == 6 || date.weekday == 7
                    ? Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.redAccent),
                      )
                    : Text(date.day.toString())
              ],
            ),
          ),
          markerBuilder: (context, date, _) {
            if (_.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: markerColorList[
                          _settingsController.selectPrimaryColorIndex.value]),
                ),
              );
            }
          },
        ),
        headerStyle: HeaderStyle(
          // formatButtonVisible: false,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
              color: context.theme.primaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          formatButtonTextStyle: TextStyle(
            color: Colors.white,
          ),
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        rowHeight: 45,
        locale: 'ko-KR',
        firstDay: FirstDay,
        lastDay: LastDay,
        focusedDay: _todoController.currentDateTime.value,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _todoController.calendarFormat.value,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.red),
        ),
        calendarStyle: CalendarStyle(
          weekendTextStyle: TextStyle(color: Colors.red),
          holidayTextStyle: TextStyle(color: Colors.blue),
        ),
        eventLoader: (day) {
          for (var todo in _todoController.loadTodoUidList.value.todoList) {
            if (day.year == todo.ymd.year &&
                day.month == todo.ymd.month &&
                day.day == todo.ymd.day) {
              return [Container()];
            }
          }
          return [];
        },
        onDaySelected: _onDaySelected,
        onFormatChanged: (format) {
          if (_todoController.calendarFormat.value != format) {
            setState(() {
              _todoController.calendarFormat.value = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _todoController.currentDateTime(focusedDay);
        },
      ),
    );
  }

  Widget showChart() {
    return Container(
      height: context.mediaQuery.size.height * 0.3,
      // flex: 3,
      child: GetBuilder<TodoController>(
        init: TodoController(),
        builder: (_) => _todoController.currentIndexList.isNotEmpty
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
                  centerSpaceRadius: 35,
                  sections: List<PieChartSectionData>.generate(
                      _todoController.currentIndexList.length, (index) {
                    final isTouched = index == touchedIndex;
                    final radius = isTouched
                        ? context.mediaQuery.size.width * 0.17
                        : context.mediaQuery.size.width * 0.14;
                    return PieChartSectionData(
                      titleStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      title: _todoController.currentUidList.value
                                  .todoList[index].percent <
                              7
                          ? ''
                          : '${_todoController.currentUidList.value.todoList[index].percent.toStringAsFixed(0)}%',
                      color: colorList[_todoController
                          .currentUidList.value.todoList[index].colorIndex],
                      value: _todoController
                          .currentUidList.value.todoList[index].value
                          .toDouble(),
                      radius: radius,
                      badgeWidget: isTouched
                          ? Container(
                              width: 60,
                              height: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: colorList[_todoController
                                          .currentUidList
                                          .value
                                          .todoList[index]
                                          .colorIndex]
                                      .withOpacity(0.6)),
                              child: Center(
                                child: Text(
                                  '${_todoController.currentUidList.value.todoList[index].title}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : null,
                      badgePositionPercentageOffset: 1.4,
                    );
                  }),
                ),
              )
            : Center(
                child: Text('일정이 없습니다. 일정을 추가해보세요'),
              ),
      ),
    );
  }

  Widget showChartList() {
    return Container(
      // height: context.mediaQuery.size.height * 0.2,
      // flex: 2,
      child: GetBuilder<TodoController>(
        builder: (_) => _todoController.currentIndexList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: _todoController.currentIndexList.length,
                itemBuilder: (context, index) => InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => todoDialog(
                          _todoController
                              .currentUidList.value.todoList[index].colorIndex,
                          _todoController
                              .currentUidList.value.todoList[index].title,
                          _todoController
                              .currentUidList.value.todoList[index].ymd,
                          _todoController
                              .currentUidList.value.todoList[index].memoText,
                          TimeRange(
                            startTime: TimeOfDay(
                                hour: _todoController.currentUidList.value
                                    .todoList[index].startHour,
                                minute: _todoController.currentUidList.value
                                    .todoList[index].startMinute),
                            endTime: TimeOfDay(
                                hour: _todoController.currentUidList.value
                                    .todoList[index].endHour,
                                minute: _todoController.currentUidList.value
                                    .todoList[index].endMinute),
                          ),
                          _todoController
                              .currentUidList.value.todoList[index].uid),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorList[_todoController.currentUidList
                                    .value.todoList[index].colorIndex]),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: context.mediaQuery.size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: context.mediaQuery.size.width * 0.25,
                                  child: Text(
                                    _todoController.currentUidList.value
                                        .todoList[index].title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: context.mediaQuery.size.width * 0.3,
                                  child: Text(
                                    _todoController.currentUidList.value
                                        .todoList[index].memoText,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  width: context.mediaQuery.size.width * 0.25,
                                  child: isPercentOrHour
                                      ? Text(
                                          ' ${_todoController.currentUidList.value.todoList[index].hourMinute}')
                                      : Text(
                                          ' ${_todoController.currentUidList.value.todoList[index].percent.toStringAsFixed(0)} %',
                                          style: TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  Widget todoDialog(int colorIndex, String title, DateTime dateTime,
      String memoText, TimeRange timeRange, String todoUid) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: colorList[colorIndex]),
              ),
              SizedBox(width: 10),
              Container(
                  width: context.mediaQuery.size.width * 0.4,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          IconButton(
              icon: Icon(IconsDB.trash),
              splashRadius: 20,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('삭제 하시겠습니까?'),
                      actions: [
                        InkWell(
                          splashColor:
                              context.theme.primaryColor.withOpacity(0.4),
                          highlightColor:
                              context.theme.primaryColor.withOpacity(0.2),
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: context.mediaQuery.size.width * 0.17,
                            height: context.mediaQuery.size.height * 0.043,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: context.theme.primaryColor)),
                            child: Center(
                              child: Text(
                                '취소',
                                style: TextStyle(
                                    color: context.theme.primaryColor),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            _todoController.todoDelete(todoUid);
                            await todoFirebaseDelete(todoUid).then((value) {
                              _todoController.setCurrentIndex(
                                  _todoController.currentDateTime.value);
                            });
                            Get.back();
                            Get.back();
                            setState(() {});
                            await Get.showSnackbar(
                              GetBar(
                                duration: Duration(seconds: 2),
                                title: 'SUCCESS',
                                message: '성공적으로 삭제되었습니다.',
                                backgroundColor: successColor,
                              ),
                            );
                          },
                          child: Container(
                            width: context.mediaQuery.size.width * 0.17,
                            height: context.mediaQuery.size.height * 0.043,
                            decoration: BoxDecoration(
                                color: context.theme.primaryColor),
                            child: Center(
                              child: Text(
                                '삭제',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              })
        ],
      ),
      content: Container(
        height: memoText.isEmpty
            ? context.mediaQuery.size.height * 0.14
            : context.mediaQuery.size.height * 0.17,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${dateTime.year}.'
                  '${dateTime.month}.'
                  '${dateTime.day} '
                  '${_todoController.getOfDay(dateTime.weekday)}',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            SizedBox(height: 10),
            memoText.isEmpty
                ? SizedBox()
                : Text(
                    memoText,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 25),
                  ),
            SizedBox(height: 10),
            Text(
              '${timeRange.startTime.hour} : '
              '${timeRange.startTime.minute} - '
              ' ${timeRange.endTime.hour} : '
              '${timeRange.endTime.minute}',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
      actions: [
        InkWell(
          splashColor: context.theme.primaryColor.withOpacity(0.4),
          highlightColor: context.theme.primaryColor.withOpacity(0.2),
          onTap: () {
            Get.back();
          },
          child: Container(
            width: context.mediaQuery.size.width * 0.17,
            height: context.mediaQuery.size.height * 0.043,
            decoration: BoxDecoration(
                border: Border.all(color: context.theme.primaryColor)),
            child: Center(
              child: Text(
                '취소',
                style: TextStyle(color: context.theme.primaryColor),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _todoController.currentDateTime(dateTime);
            _todoController.titleTextController.value.text = title;
            _todoController.titleText(title);
            _todoController.memoController.value.text = memoText;
            _todoController.memoText(memoText);
            _todoController.setTime(timeRange);
            _todoController.selectColorIndex(colorIndex);
            _todoController.isEditMode(true);
            _todoController.editTodoUid(todoUid);
            _todoController.clickedAddButton(false);
            Get.to(() => AddTodo());
          },
          child: Container(
            width: context.mediaQuery.size.width * 0.17,
            height: context.mediaQuery.size.height * 0.043,
            color: context.theme.primaryColor,
            child: Center(
              child: Text(
                '수정',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _todoController.initHome(_todoController.currentDateTime.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _banner?.dispose();
  }
}
