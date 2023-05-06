import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:todo_list_provider/app/core/notifiers/notifiers.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/widgets/widgets.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_controller.dart';
import 'package:todo_list_provider/app/modules/auth/register/register_page.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailEC = TextEditingController();

  final _passwordEC = TextEditingController();

  final _emailFocus = FocusNode();

  void _handleGoogleLogin() => context.read<LoginController>().googleLogin();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(notifier: context.read<LoginController>()).listen(
      context,
      onListen: (notifier, __) {
        if (notifier.hasInfo) {
          Messages.of(context).showInfo(notifier.info!);
        }
      },
    );
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (formValid) {
      await context
          .read<LoginController>()
          .login(_emailEC.text, _passwordEC.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: SafeArea(
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      const Logo(),
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
                                focusNode: _emailFocus,
                              ),
                              const SizedBox(height: 20),
                              CustomInput(
                                label: 'Senha',
                                controller: _passwordEC,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                validator: Validatorless.multiple([
                                  Validatorless.required('Senha obrigatória'),
                                  Validatorless.min(6, 'Mínimo 6 caracteres'),
                                ]),
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                  _submit();
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      if (_emailEC.text.isNotEmpty) {
                                        context
                                            .read<LoginController>()
                                            .forgotPassword(_emailEC.text);
                                      } else {
                                        Messages.of(context).showError(
                                          // ignore: lines_longer_than_80_chars
                                          'Digite um e-mail para recuperar a senha',
                                        );
                                        _emailFocus.requestFocus();
                                      }
                                    },
                                    child: const Text('Esqueceu sua senha?'),
                                  ),
                                  ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('Login'),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F3F7),
                            border: Border(
                              top: BorderSide(
                                width: 2,
                                color: Colors.grey.withAlpha(50),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              Container(),
                              SignInButton(
                                Buttons.google,
                                onPressed: _handleGoogleLogin,
                                text: 'Continue com o Google',
                                padding: const EdgeInsets.all(5),
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Não tem conta?'),
                                  TextButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed(RegisterPage.routeName),
                                    child: const Text('Cadastre-se'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
