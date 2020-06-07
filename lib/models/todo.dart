class Todo {
  String id;
  String title;
  DateTime dueTime;
  String note;

  Todo(this.title, this.dueTime, this.note);

  Todo.newTodo() {
    title = "";
    dueTime = DateTime.now();
    note = "";
  }
}
