import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/extensions.dart';
import 'package:mobile/src/modules/auth/providers/auth_provider.dart';
import 'package:mobile/src/modules/home/home_page.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  static const String routeName = '/auth';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final ValueNotifier<bool> isLoginNotifier = ValueNotifier<bool>(true);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    isLoginNotifier.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to\nPocket",
                      textAlign: TextAlign.start,
                      style: context.textTheme.title1,
                    ),
                    ValueListenableBuilder(
                      valueListenable: emailController,
                      builder: (context, value, child) {
                        return TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: passwordController,
                      builder: (context, value, child) {
                        return TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                        );
                      },
                    ),

                    ValueListenableBuilder(
                      valueListenable: isLoginNotifier,
                      builder: (context, isLogin, child) {
                        if (isLogin) return SizedBox.shrink();

                        return ValueListenableBuilder(
                          valueListenable: nameController,
                          builder: (context, value, child) {
                            return TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              ValueListenableBuilder(
                valueListenable: isLoginNotifier,
                builder: (context, isLogin, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      final ap = context.read<AuthProvider>();

                      if (isLogin) {
                        final error = await ap.signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.message)),
                          );
                          return;
                        }
                      } else {
                        final error = await ap.signUp(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.message)),
                          );
                          return;
                        }
                      }

                      context.pushReplacement(HomePage.routeName);
                    },
                    child: Text(isLogin ? 'Login' : 'Signup'),
                  );
                },
              ),

              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ValueListenableBuilder(
                  valueListenable: isLoginNotifier,
                  builder: (context, isLogin, child) {
                    return Text.rich(
                      TextSpan(
                        text: isLogin
                            ? "Don't have an account? Signup."
                            : "Already have an account? Login.",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            isLoginNotifier.value = !isLoginNotifier.value;
                          },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
