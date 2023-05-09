import 'dart:developer';

import 'package:todo_list_provider/app/core/notifiers/notifiers.dart';
import 'package:todo_list_provider/app/services/tasks/tasks.dart';

class TaskCreateController extends DefaultChangeNotifier {
  TaskCreateController(this._tasksService);

  final TasksService _tasksService;

  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? selectedDate) {
    resetState();
    _selectedDate = selectedDate;
    notifyListeners();
  }

  Future<void> save(String description) async {
    showLoadingAndResetState();
    notifyListeners();
    try {
      if (_selectedDate != null) {
        await _tasksService.save(_selectedDate!, description);
      } else {
        error = 'Data não definida';
      }
      success();
    } catch (e, st) {
      log('TaskCreateController.save', error: e, stackTrace: st);
      error = 'Erro ao cadastrar task';
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
