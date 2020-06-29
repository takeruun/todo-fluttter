import 'package:flutter/material.dart';
import 'package:todo/models/todo_list.dart';
import 'package:todo/db/db_provider.dart';

class UsingDatabaseCompletedLists extends StatelessWidget {
  UsingDatabaseCompletedLists({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Using Database Completed Lists',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DatabaseCompletedLists(),
    );
  }
}

class DatabaseCompletedLists extends StatefulWidget {
  @override
  _DatabaseCompletedListsState createState() => _DatabaseCompletedListsState();
}

class _DatabaseCompletedListsState extends State<DatabaseCompletedLists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Lists'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<TodoList>>(
              future: DBProvider.db.getAllCompleteTodoList(),
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
                              subtitle: Text('sub title : ${todo.sub_title}'),
                              title: Text('Title : ${todo.title}'),
                            ),
                            background: Container(),
                            secondaryBackground: Container(
                              color: Colors.red,
                            ),
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                await DBProvider.db.uncompletedTodo(todo.id, 0);
                                Scaffold.of(context).removeCurrentSnackBar();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                  '戻しました',
                                  style: TextStyle(color: Colors.greenAccent),
                                )));
                                setState(() {});
                              } else {
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
          )
        ],
      ),
    );
  }
}
