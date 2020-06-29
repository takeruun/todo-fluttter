import 'package:flutter/material.dart';
import 'models/shared_prefs.dart';
import 'package:todo/pages/completed_list.dart';
import 'pages/using_database_page.dart';
import 'package:todo/pages/using_database_completed_lists.dart';
import 'package:todo/pages/edit_todo_list.dart';

var homePageKey = GlobalKey<_MyListsState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ToDo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/database': (BuildContext context) => UsingDatabasePage(),
        '/completed': (BuildContext context) => CompletedLists(),
      },
      home: MyLists(key: homePageKey),
    );
  }
}

class MyLists extends StatefulWidget {
  MyLists({Key key}) : super(key: key);
  @override
  _MyListsState createState() => _MyListsState();
}

class _MyListsState extends State<MyLists> {
  List<String> listItems = [];
  List<String> completedItems = [];

  bool _validate = false;

  final TextEditingController eCtrl = TextEditingController();

  void _init() async {
    await SharePrefs.setInstance();
    listItems = SharePrefs.getListItems();
    completedItems = SharePrefs.getCompletedItems();
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    eCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Lists'),
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              setState(() {});
              Navigator.of(context).pushNamed('/completed');
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.7),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: eCtrl,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Things to do',
                          errorText: _validate ? 'This input is empty' : null,
                          contentPadding: const EdgeInsets.only(
                              top: 15.0, left: 25.0, bottom: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                        autocorrect: true,
                        onSubmitted: (text) {
                          if (text.isEmpty) {
                            _validate = true;
                            setState(() {});
                          } else {
                            _validate = false;
                            completedItems.add('false');
                            listItems.add(text);
                            SharePrefs.setCompletedItems(completedItems)
                                .then((_) {
                              setState(() {});
                            });
                            SharePrefs.setListItems(listItems).then((_) {
                              setState(() {});
                            });
                            eCtrl.clear();
                          }
                        },
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
                          icon: Icon(
                              IconData(57669, fontFamily: 'MaterialIcons')),
                          onPressed: () {
                            if (eCtrl.text.isEmpty) {
                              _validate = true;
                              setState(() {});
                            } else {
                              _validate = false;
                              completedItems.add('false');
                              listItems.add(eCtrl.text);
                              SharePrefs.setListItems(listItems).then((_) {
                                setState(() {});
                              });
                              SharePrefs.setCompletedItems(completedItems)
                                  .then((_) {
                                setState(() {});
                              });
                              eCtrl.clear();
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listItems.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(child: Text(listItems[index])),
                            Container(
                              width: 40,
                              child: InkWell(
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.redAccent,
                                ),
                                onTap: () {
                                  listItems.removeAt(index);
                                  completedItems.removeAt(index);
                                  SharePrefs.setListItems(listItems).then((_) {
                                    setState(() {});
                                  });
                                  SharePrefs.setCompletedItems(completedItems)
                                      .then((_) {
                                    setState(() {});
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: 30,
                              child: InkWell(
                                  child: Icon(
                                    completedItems[index] == 'false'
                                        ? Icons.check_box_outline_blank
                                        : Icons.check_box,
                                    color: Colors.greenAccent,
                                  ),
                                  onTap: () {
                                    if (completedItems[index] == 'false') {
                                      completedItems[index] = 'true';
                                    } else {
                                      completedItems[index] = 'false';
                                    }
                                    setState(() {});
                                  }),
                            )
                          ],
                        ),
                        onTap: () {
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: InkWell(
                  child: Text(
                    'Link to TodoLists using DB',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () => Navigator.of(context).pushNamed('/database'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
