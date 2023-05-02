import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:todo_list_provider/app/core/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

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
                          child: Column(
                            children: [
                              TextFormField(),
                              const SizedBox(height: 20),
                              TextFormField(),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('Esqueceu sua senha?'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
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
                                onPressed: () {},
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
                                    onPressed: () {},
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
