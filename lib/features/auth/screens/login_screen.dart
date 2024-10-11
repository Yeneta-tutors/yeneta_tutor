import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/features/auth/screens/forgot_password.dart';
import 'package:yeneta_tutor/widgets/text_field.dart';
import 'package:yeneta_tutor/widgets/button.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/widgets/snackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      ref.read(authControllerProvider).login(
            context: context,
            email: email,
            password: password,
          );
    } else {
      showSnackBar(context, "Please enter your email and password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Yeneta Tutor"),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/bro.png',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFieldInput(
                      textEditingController: _emailController,
                      hintText: "Email",
                      icon: Icons.email,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextFieldInput(
                        textEditingController: _passwordController,
                        hintText: "Password",
                        isPass: true,
                        icon: Icons.lock,
                        textInputType: TextInputType.text),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    MyButtons(
                      onTap: login,
                      text: "Login",
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: const Text(
                        "Don't have an account? Signup",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}
