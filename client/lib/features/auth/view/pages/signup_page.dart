import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';

import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
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
            showSnackBar(context, "Account created successfully");
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const LoginPage();
            }));
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: formKey,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up.",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomField(
                      hintText: "Name",
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 15,
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
                        text: "Sign Up",
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .SignUpUser(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text);
                          } else {
                            showSnackBar(context, "Missing fields");
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const LoginPage();
                        }));
                      },
                      child: RichText(
                        text: TextSpan(
                            text: 'Already have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                  text: "Sign In",
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
