import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_todo/db/db_helper.dart';
import 'package:my_todo/service/theame_service.dart';
import 'package:my_todo/ui/home_page.dart';
import 'package:my_todo/ui/notification_full_screen.dart';
import 'package:my_todo/ui/themes.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDB();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CustomThemes.light,
      darkTheme: CustomThemes.dark,
      themeMode: TheameService().theme,
      home:  NotificationFullScreen(id:'1'),
    );
  }
  
}

