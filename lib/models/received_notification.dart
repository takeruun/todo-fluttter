import 'package:flutter/material.dart';

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id, this.body, this.title, this.payload});
}
