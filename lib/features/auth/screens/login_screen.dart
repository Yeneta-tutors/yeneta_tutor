// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/login_controller.dart';
import 'package:yeneta_tutor/features/student/screens/student_home.dart';
import 'package:yeneta_tutor/widgets/button.dart';
import 'package:yeneta_tutor/widgets/text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      ref.read(loginControllerProvider.notifier).login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('images/logo.jpg', height: 150), // Add your logo here
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Email',
                      icon: Icons.email,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: 'Password',
                      icon: Icons.lock,
                      textInputType: TextInputType.text,
                      isPass: true,
                    ),
                    const SizedBox(height: 24),
                    loginState.when(
                      data: (user) {
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentHomePage(),
                            ),
                          );
                          return Text('Login successful, user: ${user.email}');
                        }
                        return MyButtons(onTap: _login, text: "Log In");
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, _) => Text('Error: $error'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
