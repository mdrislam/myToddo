import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_todo/ui/themes.dart';

class MyInputFields extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? textEditingController;
  final Widget? widget;

  MyInputFields(
      {Key? key,
      required this.title,
      required this.hint,
      this.textEditingController,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomThemes().titleStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.only(left: 14.0),
            height: 52.0,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  cursorColor:
                      Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                  controller: textEditingController,
                  style: CustomThemes().subTitleStyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: CustomThemes().subTitleStyle,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: (BorderSide(
                          color: context.theme.backgroundColor, width: 0)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: (BorderSide(
                          color: context.theme.backgroundColor, width: 0)),
                    ),
                  ),
                )),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
