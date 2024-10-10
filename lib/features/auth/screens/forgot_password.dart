import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeneta_tutor/widgets/text_field.dart';
import 'package:yeneta_tutor/widgets/button.dart';
import 'package:yeneta_tutor/features/auth/controllers/auth_controller.dart';
import 'package:yeneta_tutor/widgets/snackbar.dart';
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const routeName = '/forgot-password';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void sendPasswordResetLink() {
    final email = _emailController.text.trim();

    if(email.isNotEmpty){
      ref.read(authControllerProvider).sendPasswordResetEmail(
        context: context,
        email: email,
      );
    } else {
      showSnackBar(context, "Please enter your email");
    }
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/amico.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                "Enter your Email address below and we will send you code to reset it",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFieldInput(
                textEditingController: _emailController,
                hintText: "Email",
                icon: Icons.email,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              MyButtons (
                onTap: sendPasswordResetLink,
                text: "Send",
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
