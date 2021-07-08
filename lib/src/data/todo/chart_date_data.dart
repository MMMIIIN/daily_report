class TestTodo {
  // final List<TestTodoList> todoList;

  TestTodo({required this.uid,
    required this.year,
    required this.month,
    required this.day,
    required this.title,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.value,
    required this.colorIndex,
    this.percent = 0.0});

  String uid;
  int year;
  int month;
  int day;
  String title;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  int value;
  int colorIndex;
  double percent;

  factory TestTodo.fromJson(Map<String, dynamic> json) =>
      TestTodo(
          uid: json["uid"],
          year: json["year"],
          month: json["month"],
          day: json["day"],
          title: json["title"],
          startHour: json["startHour"],
          startMinute: json["startMinute"],
          endHour: json["endHour"],
          endMinute: json["endMinute"],
          value: json["value"],
          colorIndex: json["color"]);

  Map<String, dynamic> toJson() =>
      {
        "uid": uid,
        "year": year,
        "month": month,
        "day": day,
        "title": title,
        "startHour": startHour,
        "startMinute": startMinute,
        "endHour": endHour,
        "endMinute": endMinute,
        "value": value,
        "color": colorIndex
      };
}

class TodoUidList {
  final List<TestTodo> todoList;

  TodoUidList({required this.todoList});

  factory TodoUidList.fromJson(List<dynamic> json) {
    List<TestTodo> todoList1;
    todoList1 = json.map((e) => TestTodo.fromJson(e)).toList();

    return new TodoUidList(todoList: todoList1);
  }
}
