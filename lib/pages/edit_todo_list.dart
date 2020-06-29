import 'package:flutter/material.dart';
import 'package:todo/db/db_provider.dart';
import 'package:todo/main.dart';
import 'package:todo/models/todo_list.dart';
import 'package:todo/pages/using_database_page.dart';

var globalContext;

class EditTodoList extends StatelessWidget {
  EditTodoList({Key key, this.id}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return MaterialApp(
      title: 'Edit todo list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/database': (BuildContext context) => UsingDatabasePage(),
      },
      home: Edit(id: id),
    );
  }
}

class Edit extends StatefulWidget {
  Edit({Key key, this.id}) : super(key: key);

  final int id;

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final TextEditingController eCtrlT = TextEditingController();
  final TextEditingController eCtrlS = TextEditingController();
  TodoList todo;
  String title = "";
  String subTitle = "";
  bool _validate = false;

  @override
  void _init() async {
    var res = await DBProvider.db.getTodoList(widget.id);
    todo = res;
    eCtrlT.text = todo.title;
    eCtrlS.text = todo.sub_title;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    eCtrlT.dispose();
    eCtrlS.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Todo'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              TextField(
                controller: eCtrlT,
                decoration: InputDecoration(
                  hintText: 'Title',
                  errorText: _validate ? 'This input is empty' : null,
                  contentPadding: const EdgeInsets.only(
                      top: 10.0, left: 25.0, bottom: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
                autocorrect: true,
                onSubmitted: (title) {
                  if (title.isEmpty) {
                    _validate = true;
                    setState(() {});
                  } else {
                    _validate = false;
                    setState(() {});
                  }
                },
              ),
              TextField(
                controller: eCtrlS,
                decoration: InputDecoration(
                  hintText: 'Sub Title',
                  errorText: _validate ? 'This input is empty' : null,
                  contentPadding: const EdgeInsets.only(
                      top: 10.0, left: 25.0, bottom: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
                autocorrect: true,
                onSubmitted: (subTitle) {
                  if (subTitle.isEmpty) {
                    _validate = true;
                    setState(() {});
                  } else {
                    _validate = false;
                    setState(() {});
                  }
                },
              ),
              Container(
                  child: RaisedButton(
                child: Text(
                  '更新',
                  style: TextStyle(fontSize: 30),
                ),
                onPressed: () async {
                  todo.title = eCtrlT.text;
                  todo.sub_title = eCtrlS.text;
                  await DBProvider.db.updateTodoList(todo);
                  Navigator.of(context).popAndPushNamed('/database');
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
