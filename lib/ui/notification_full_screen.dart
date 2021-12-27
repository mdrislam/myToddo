import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_todo/db/db_helper.dart';
import 'package:my_todo/models/task.dart';
import 'package:my_todo/service/theame_service.dart';
import 'package:my_todo/ui/themes.dart';

class NotificationFullScreen extends StatefulWidget {
  final String id;
  NotificationFullScreen({Key? key, required this.id}) : super(key: key);

  @override
  _NotificationFullScreenState createState() => _NotificationFullScreenState();
}

class _NotificationFullScreenState extends State<NotificationFullScreen> {
  Task task = Task();

  @override
  void initState() {
    // TODO: implement initState

    _getTask();
    super.initState();
  }

  _getTask() async {
    task = await DbHelper.readSingleTask(int.parse(widget.id));
    setState(() {
      print(task.tojson());
      print('Payload: ${widget.id}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
        child: Icon(
          Icons.arrow_back,
          size: 20.0,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
          child: Icon(
            Icons.close,
            size: 20.0,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
      title: Text(
        task.title.toString(),
        style: CustomThemes().titleStyle,
      ),
    );
  }
}
