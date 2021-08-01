class TestTodo {
  TestTodo(
      {required this.uid,
      required this.ymd,
      required this.title,
      required this.startHour,
      required this.startMinute,
      required this.endHour,
      required this.endMinute,
      required this.value,
      required this.colorIndex,
      this.percent = 0.0,
      this.hourMinute = ''});

  String uid;
  DateTime ymd;
  String title;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  int value;
  int colorIndex;
  double percent;
  String hourMinute;
}

class TodoUidList {
  final List<TestTodo> todoList;

  TodoUidList({required this.todoList});
}
