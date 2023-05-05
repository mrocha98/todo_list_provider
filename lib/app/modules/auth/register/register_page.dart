import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/notifiers/notifiers.dart';
import 'package:todo_list_provider/app/core/ui/size_extensions.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/core/validators/validators.dart';
import 'package:todo_list_provider/app/core/widgets/widgets.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_page.dart';
import 'package:todo_list_provider/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailEC = TextEditingController();

  final _passwordEC = TextEditingController();

  final _confirmPasswordEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(
      notifier: context.read<RegisterController>(),
    ).listen(
      context,
      onSuccess: (_, __) =>
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName),
    );
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (formValid) {
      await context.read<RegisterController>().registerUser(
            _emailEC.text,
            _passwordEC.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: ClipOval(
            child: Container(
              color: context.primaryColor.withAlpha(20),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Todo List',
              style: TextStyle(
                fontSize: 10,
                color: context.primaryColor,
              ),
            ),
            Text(
              'Cadastro',
              style: TextStyle(
                fontSize: 15,
                color: context.primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: context.percentWidth(.5),
            child: const FittedBox(
              fit: BoxFit.fitHeight,
              child: Logo(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomInput(
                    label: 'E-mail',
                    controller: _emailEC,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validatorless.multiple([
                      Validatorless.required('E-mail obrigatório'),
                      Validatorless.email('E-mail inválido'),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    label: 'Senha',
                    controller: _passwordEC,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    validator: Validatorless.multiple([
                      Validatorless.required('Senha obrigatória'),
                      Validatorless.min(
                        6,
                        'Senha deve ter pelo menos 6 caracteres',
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    label: 'Confirmar Senha',
                    controller: _confirmPasswordEC,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      _submit();
                    },
                    validator: Validatorless.multiple([
                      Validatorless.required('Confirmar Senha é obrigatório'),
                      Validators.compare(
                        _passwordEC,
                        'Senha diferente da digitada',
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Salvar'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
