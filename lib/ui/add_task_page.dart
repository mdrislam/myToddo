import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_todo/controllres/task_controller.dart';
import 'package:my_todo/models/task.dart';
import 'package:my_todo/ui/themes.dart';
import 'package:my_todo/ui/widgets/button_widgets.dart';
import 'package:my_todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.find<TaskController>();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController noteEditingController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  String _endTime = '9:30 PM';
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

  int _selectRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'weekly', 'Monthly'];
  int _selectedClr = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Task'),
              MyInputFields(
                title: 'Title',
                hint: 'Enter  title here',
                textEditingController: titleEditingController,
              ),
              MyInputFields(
                title: 'Note',
                hint: 'Enter  note here',
                textEditingController: noteEditingController,
              ),
              MyInputFields(
                title: 'Date',
                hint: DateFormat.yMd().format(_dateTime),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFormuser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputFields(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                        onPressed: () {
                          _getTimePicker(true);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: MyInputFields(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                        onPressed: () {
                          _getTimePicker(false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              MyInputFields(
                title: 'Remind',
                hint: '$_selectRemind minutes early',
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32.0,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: CustomThemes().subTitleStyle,
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectRemind = int.parse(value!);
                    });
                  },
                ),
              ),
              MyInputFields(
                title: 'Repeat',
                hint: '$_selectRepeat ',
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32.0,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: CustomThemes().subTitleStyle,
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectRepeat = value!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _clolorPallete(),
                  ButtonWidgets(
                      label: 'Create Task',
                      onTap: () {
                        _validateData();
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (titleEditingController.text.isNotEmpty &&
        noteEditingController.text.isNotEmpty) {
      _addTaaskToDB();
      Get.back();
    } else if (titleEditingController.text.isEmpty ||
        noteEditingController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All Fields Are Required*',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  _addTaaskToDB() async {
    int value = await _taskController.addTask(Task(
      title: titleEditingController.text,
      note: noteEditingController.text,
      date: DateFormat.yMd().format(_dateTime),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectRemind,
      repeat: _selectRepeat,
      color: _selectedClr,
      isCompleted: 0,
    ));
    print('Add Value MTD: ' + value.toString());
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20.0,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      title: const Text('Todo '),
      actions: const [
        CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.pngitem.com/pimgs/m/579-5794945_circle-profile-hd-png-download.png')),
        SizedBox(
          width: 28,
        )
      ],
    );
  }

  _clolorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: CustomThemes().titleStyle,
        ),
        const SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedClr = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: _selectedClr == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _getDateFormuser() async {
    DateTime? _datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (_datePicker != null) {
      setState(() {
        _dateTime = _datePicker;
      });
    }
  }

  _getTimePicker(bool isStartTime) async {
    final TimeOfDay pickedTime = await _showTimePicker();

    String formatedTime =pickedTime.format(context);
    if (pickedTime == null) {
      print('Start Time Is Null');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = formatedTime;
      });
    }
  }

  _showTimePicker() async {
    return await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
