import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/notifiers/notifiers.dart';
import 'package:todo_list_provider/app/models/models.dart';
import 'package:todo_list_provider/app/services/tasks/tasks.dart';

class HomeController extends DefaultChangeNotifier {
  HomeController(this._tasksService);

  final TasksService _tasksService;

  TaskFilterEnum filterSelected = TaskFilterEnum.today;

  bool get isTodaySelected => filterSelected == TaskFilterEnum.today;

  bool get isTomorrowSelected => filterSelected == TaskFilterEnum.tomorrow;

  bool get isWeekSelected => filterSelected == TaskFilterEnum.week;

  TotalTasksModel? todayTotalTasks;

  TotalTasksModel? tomorrowTotalTasks;

  TotalTasksModel? weekTotalTasks;

  List<TaskModel> allTasks = [];

  List<TaskModel> filteredTasks = [];

  DateTime? initialDateOfWeek;

  DateTime? selectedDay;

  bool showFinishedTasks = false;

  Future<void> loadTotalTasks() async {
    final allTasks = await Future.wait([
      _tasksService.getTasksForToday(),
      _tasksService.getTasksForTomorrow(),
      _tasksService.getTasksForWeek(),
    ]);

    final todayTasks = allTasks.first as List<TaskModel>;
    final tomorrowTasks = allTasks[1] as List<TaskModel>;
    final weekTasks = allTasks.last as WeekTasksModel;

    todayTotalTasks = TotalTasksModel(
      totalTasks: todayTasks.length,
      totalTasksFinished: _countTotalTasksFinished(todayTasks),
    );

    tomorrowTotalTasks = TotalTasksModel(
      totalTasks: tomorrowTasks.length,
      totalTasksFinished: _countTotalTasksFinished(tomorrowTasks),
    );

    weekTotalTasks = TotalTasksModel(
      totalTasks: weekTasks.tasks.length,
      totalTasksFinished: _countTotalTasksFinished(weekTasks.tasks),
    );
  }

  int _countFinishedTasks(int total, TaskModel task) =>
      task.finished ? total + 1 : total;

  int _countTotalTasksFinished(List<TaskModel> tasks) =>
      tasks.fold<int>(0, _countFinishedTasks);

  Future<void> findTasks({required TaskFilterEnum filter}) async {
    filterSelected = filter;
    showLoading();
    notifyListeners();
    final List<TaskModel> tasks;

    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _tasksService.getTasksForToday();
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTasksForTomorrow();
        break;
      case TaskFilterEnum.week:
        final weekModel = await _tasksService.getTasksForWeek();
        tasks = weekModel.tasks;
        initialDateOfWeek = weekModel.startDate;
        break;
    }

    filteredTasks = [...tasks];
    allTasks = [...tasks];

    if (filter == TaskFilterEnum.week) {
      if (selectedDay != null) {
        filterByDay(selectedDay!);
      } else if (initialDateOfWeek != null) {
        filterByDay(initialDateOfWeek!);
      }
    } else {
      selectedDay = null;
    }

    if (!showFinishedTasks) {
      filteredTasks = filteredTasks.where((task) => !task.finished).toList();
    }

    hideLoading();
    notifyListeners();
  }

  void filterByDay(DateTime date) {
    selectedDay = date.copyWith();
    filteredTasks = allTasks
        .where((task) => DateUtils.isSameDay(task.dateTime, date))
        .toList();
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await Future.wait([
      findTasks(filter: filterSelected),
      loadTotalTasks(),
    ]);
    notifyListeners();
  }

  Future<void> checkOrUncheckTask(TaskModel task) async {
    showLoadingAndResetState();
    notifyListeners();

    final taskUpdate = task.copyWith(finished: !task.finished);
    await _tasksService.checkOrUncheckTask(taskUpdate);

    hideLoading();
    await refreshPage();
  }

  void showOrHideFinishedTasks() {
    showFinishedTasks = !showFinishedTasks;
    refreshPage();
  }
}
