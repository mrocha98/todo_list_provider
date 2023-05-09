import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/notifiers/notifiers.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/core/widgets/widgets.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list_provider/app/modules/tasks/widgets/widgets.dart';
import 'package:validatorless/validatorless.dart';

class TaskCreatePage extends StatefulWidget {
  const TaskCreatePage({
    super.key,
  });

  static const routeName = '/task/create';

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(
      notifier: context.read<TaskCreateController>(),
    ).listen(
      context,
      onSuccess: (_, __) => Navigator.pop(context),
    );
  }

  Future<void> _handleSubmit() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (formValid) {
      final controller = context.read<TaskCreateController>();
      await controller.save(_descriptionEC.text);
    }
  }

  @override
  void dispose() {
    _descriptionEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleSubmit,
        label: const Text(
          'Salvar Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: context.primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Criar Nota',
                  style: context.titleStyle.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomInput(
                label: '',
                controller: _descriptionEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Campo obrigatório'),
                  Validatorless.max(280, 'Máximo 280 caracteres'),
                ]),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 20,
              ),
              const CalendarButton(),
            ],
          ),
        ),
      ),
    );
  }
}
