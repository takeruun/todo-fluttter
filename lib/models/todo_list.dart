import 'dart:convert';

TodoList rankFromJson(String str) {
  final jsonData = json.decode(str);
  return TodoList.fromMap(jsonData);
}

class TodoList {
  int id;
  String title;
  String sub_title;
  int is_done;

  TodoList({this.id, this.title, this.sub_title, this.is_done});

  Map<String, dynamic> toMap() =>
      {'id': id, 'title': title, 'sub_title': sub_title, 'is_done': is_done};

  TodoList.fromMap(Map<String, dynamic> data) {
    this.id = data['id'];
    this.title = data['title'];
    this.sub_title = data['sub_title'];
    this.is_done = data['is_done'];
  }
}
