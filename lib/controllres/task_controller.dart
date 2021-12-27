import 'package:get/get.dart';
import 'package:my_todo/db/db_helper.dart';
import 'package:my_todo/models/task.dart';


class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  Task? task;
  
  @override
  void onReady() {
    // TODO: implement onReady
    getTask();
    super.onReady();
  }

  Future<int> addTask(Task? task) async {
    return await DbHelper.insert(task);
  }
  Future<int> updateTask(Task? task) async {
    return await DbHelper.updateTask(task);
  }
  void getTask() async{
    List<Map<String,dynamic>> tasks = await DbHelper.queryTasks();
    taskList.assignAll(tasks.map((data) =>  Task.fromJson(data)).toList());
  }
  void delete(Task task)async{
    await DbHelper.delete(task);
    getTask();
  }
  void markedTaskCompleted(int id)async{
    await DbHelper.update(id);
    getTask();
  }

  void setTask(Task task){
    this.task = task;
  }
}
