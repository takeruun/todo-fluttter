import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/db/db_provider.dart';
import 'package:todo/models/shared_prefs.dart';
import 'package:todo/models/todo_list.dart';
import 'package:todo/main.dart';
import 'package:todo/pages/using_database_completed_lists.dart';
import 'package:todo/pages/edit_todo_list.dart';

var globalContext;
int todoId;

class UsingDatabasePage extends StatelessWidget {
  UsingDatabasePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return MaterialApp(
      title: 'DatabasePage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/edit': (BuildContext context) => EditTodoList(id: todoId),
        '/databaseCompleted': (BuildContext context) =>
            UsingDatabaseCompletedLists(),
      },
      home: DatabasePage(),
    );
  }
}

class DatabasePage extends StatefulWidget {
  @override
  _DatabasePageState createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  bool _validate = false;
  final TextEditingController eCtrlT = TextEditingController();
  final TextEditingController eCtrlS = TextEditingController();

  @override
  void _init() async {
    await SharePrefs.setInstance();
    eCtrlT.text = SharePrefs.getDraft(true);
    eCtrlS.text = SharePrefs.getDraft(false);
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
        title: Text('Using Database'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              setState(() {});
              Navigator.of(context).pushNamed('/databaseCompleted');
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.7),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: eCtrlT,
                        decoration: InputDecoration(
                          hintText: 'Todo title',
                          errorText: _validate ? 'This input is empty' : null,
                          contentPadding: const EdgeInsets.only(
                              top: 10.0, left: 25.0, bottom: 10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                        autocorrect: true,
                        onSubmitted: (title) async {
                          if (title.isEmpty) {
                            _validate = true;
                            setState(() {});
                          } else {
                            _validate = false;
                            setState(() {});
                          }
                        },
                        onChanged: (text) {
                          SharePrefs.setDraft(text, true);
                        },
                      ),
                      TextField(
                        controller: eCtrlS,
                        decoration: InputDecoration(
                          hintText: 'Todo sub title',
                          errorText: _validate ? 'This input is empty' : null,
                          contentPadding: const EdgeInsets.only(
                              top: 15.0, left: 25.0, bottom: 10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                        onSubmitted: (subTitle) async {
                          if (subTitle.isEmpty) {
                            _validate = true;
                            setState(() {});
                          } else {
                            _validate = false;
                            setState(() {});
                          }
                        },
                        onChanged: (text) {
                          SharePrefs.setDraft(text, false);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.7)),
                    onPressed: () {},
                    color: Colors.blueAccent,
                    child: IconButton(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      color: Colors.white,
                      hoverColor: Colors.white,
                      icon: Icon(IconData(57669, fontFamily: 'MaterialIcons')),
                      onPressed: () async {
                        if (eCtrlT.text.isEmpty || eCtrlS.text.isEmpty) {
                          _validate = true;
                          setState(() {});
                        } else {
                          _validate = false;
                          SharePrefs.deleteDraft();
                          String title = eCtrlT.text;
                          String subTitle = eCtrlS.text;
                          TodoList newTodo;
                          newTodo.title = eCtrlT.text;
                          newTodo.sub_title = eCtrlS.text;
                          await DBProvider.db.insertTodoList(newTodo);
                          setState(() {});
                          eCtrlT.clear();
                          eCtrlS.clear();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TodoList>>(
              future: DBProvider.db.getAllTodoLists(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TodoList>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        TodoList todo = snapshot.data[index];
                        return Container(
                          child: Dismissible(
                            key: Key(index.toString()),
                            child: ListTile(
                              title: Text('Title : ${todo.title}'),
                              subtitle: Text('sub title : ${todo.sub_title}'),
                              onTap: () {
                                setState(() {
                                  todoId = todo.id;
                                });
                                Navigator.of(context).pushNamed('/edit');
                              },
                            ),
                            background: Container(
                              color: Colors.greenAccent,
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                            ),
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                await DBProvider.db.deleteTodoList(todo.id);
                                Scaffold.of(context).removeCurrentSnackBar();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                  '削除しました',
                                  style: TextStyle(color: Colors.greenAccent),
                                )));
                                setState(() {});
                              } else {
                                await DBProvider.db.completeTodo(todo.id, 1);
                                Scaffold.of(context).removeCurrentSnackBar();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                  '完了しました',
                                  style: TextStyle(color: Colors.greenAccent),
                                )));
                                setState(() {});
                              }
                            },
                          ),
                        );
                      });
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.all(10.0),
              child: InkWell(
                child: Text('Link to using sharedPref',
                    style: TextStyle(fontSize: 20)),
                onTap: () => Navigator.of(globalContext).pop(),
              ))
        ],
      ),
    );
  }
}
