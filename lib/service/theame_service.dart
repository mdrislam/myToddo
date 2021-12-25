import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class TheameService{
  final _box= GetStorage();
  final _key ='isDarkMode';

  _saveThemeBox(bool isDark)=>_box.write(_key, isDark);
  bool _loadThemeFromBox()=>_box.read(_key)??false;
  ThemeMode get theme =>_loadThemeFromBox()?ThemeMode.dark:ThemeMode.light;
  void switchTheme(){
    Get.changeThemeMode(_loadThemeFromBox()?ThemeMode.light:ThemeMode.dark);
  _saveThemeBox(!_loadThemeFromBox());
  
  }
}