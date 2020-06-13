import 'package:flutter/material.dart';
import 'package:todo/main.dart';

class CompletedLists extends StatelessWidget {
  CompletedLists({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed List'),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView.builder(
        itemCount: homePageKey.currentState.completedItems.length,
        itemBuilder: (BuildContext context, int index) {
          if (homePageKey.currentState.completedItems[index] == 'true') {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(homePageKey.currentState.listItems[index]),
                ),
                Divider(
                  height: 10.0,
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
