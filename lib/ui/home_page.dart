import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_todo/controllres/task_controller.dart';
import 'package:my_todo/models/task.dart';
import 'package:my_todo/service/notification_helper.dart';
import 'package:my_todo/service/theame_service.dart';
import 'package:my_todo/ui/add_task_page.dart';
import 'package:my_todo/ui/themes.dart';
import 'package:my_todo/ui/widgets/button_widgets.dart';
import 'package:my_todo/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _slectedDate = DateTime.now();
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotificationHelper();
    notifyHelper.initializeNotification();

    ///for Ios Request
    //notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            _addTaskbar(),
            _addDatebar(),
            const SizedBox(
              height: 10.0,
            ),
            _showTasks(),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _addDatebar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 15),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
        onDateChange: (date) {
          setState(() {
            _slectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskbar() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: CustomThemes().subHeadingStyle(24),
              ),
              Text(
                "Today",
                style: CustomThemes().headingStyle(30),
              ),
            ],
          ),
          ButtonWidgets(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(const AddTaskPage());
              _taskController.getTask();
            },
          )
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            Task task = _taskController.taskList[index];
            print(task.tojson());

            if (task.repeat == 'Daily') {
              DateTime date = DateFormat.jm().parse(task.startTime.toString());
              var myTime = DateFormat('HH:mm').format(date);
              notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(':')[0]),
                  int.parse(myTime.toString().split(':')[1]),
                  task);
              return buildTaskListCard(index, context, task);
            }
            if (task.date == DateFormat.yMd().format(_slectedDate)) {
              return buildTaskListCard(index, context, task);
            } else {
              return Container();
            }
          });
    }));
  }

  AnimationConfiguration buildTaskListCard(
      int index, BuildContext context, Task task) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: SlideAnimation(
        child: FadeInAnimation(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  print('On Tap ');
                  _showBottomSheet(context, task);
                },
                child: TaskTile(task),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 5),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * .28
          : MediaQuery.of(context).size.height * .35,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          const Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSeetButton(
                  label: 'Task Complete',
                  press: () {
                    _taskController.markedTaskCompleted(task.id!);
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context),
          const SizedBox(height: 20.0),
          _bottomSeetButton(
              label: 'Delete Task',
              press: () {
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context),
          const SizedBox(height: 20.0),
          _bottomSeetButton(
              label: 'Close',
              press: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
              isClose: true),
          const SizedBox(height: 10.0),
        ],
      ),
    ));
  }

  _bottomSeetButton({
    required String label,
    required Function() press,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55.0,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: isClose == true ? Colors.transparent : clr,
            border: Border.all(
              width: 2,
              color: isClose == true
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
            ),
            borderRadius: BorderRadius.circular(20.0)),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? CustomThemes().titleStyle
                : CustomThemes().titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          TheameService().switchTheme();

          notifyHelper.displayNotification(
              title: 'Theme Change',
              body: Get.isDarkMode ? 'Active Light Theme' : 'Active Dart Mode');
          //  notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
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
}
