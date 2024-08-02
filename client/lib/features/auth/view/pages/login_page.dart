import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/repository/auth_remote_repositries.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/view_model/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide State;

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
          data: (data) {
            // TODO: navigate to homepage
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return const Homepage();
            }), (_) => false);
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: formKey,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign In.",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomField(
                      hintText: "Email",
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomField(
                      hintText: "Password",
                      controller: passwordController,
                      isObscure: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthGradientButton(
                      text: "Sign In",
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await ref
                              .read(authViewModelProvider.notifier)
                              .LoginUser(
                                  email: emailController.text,
                                  password: passwordController.text);
                        } else {
                          showSnackBar(context, "Missing fields");
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const SignUpPage();
                        }));
                      },
                      child: RichText(
                        text: TextSpan(
                            text: "Don't have an account ? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                              TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(color: Pallete.gradient2))
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
