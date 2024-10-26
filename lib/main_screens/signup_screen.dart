import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:horizon/components/index.dart';
import 'package:horizon/constants/index.dart';
import 'package:horizon/main_screens/index.dart';
import 'package:horizon/provider/index.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [black, darkBlue], // Same gradient as in LoginPage
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 80 * Dimensions.heightF(context)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, top: 50, right: 30, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Your\nAccount",
                      style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                    Gap(16 * Dimensions.heightF(context)),
                    Text(
                      "Join our community of gamers",
                      style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                    Gap(40 * Dimensions.heightF(context)),
                    Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor),
                    ),
                    Gap(8 * Dimensions.heightF(context)),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: loginProvider.isValidEmail
                            ? null
                            : "Please enter a valid email",
                      ),
                      onChanged: (value) {
                        loginProvider.validateEmail(value);
                      },
                    ),
                    Gap(8 * Dimensions.heightF(context)),
                    Text(
                      "Password",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor),
                    ),
                    Gap(8 * Dimensions.heightF(context)),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: loginProvider.obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(loginProvider.obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            loginProvider.toggleObscureText();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: loginProvider.isValidPassword
                            ? null
                            : "Password should be 8 letters",
                      ),
                      onChanged: (value) {
                        loginProvider.validatePassword(value);
                      },
                    ),
                    Gap(8 * Dimensions.heightF(context)),
                    Text(
                      "Confirm Password",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor),
                    ),
                    Gap(8 * Dimensions.heightF(context)),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: loginProvider.obscureText,
                      decoration: InputDecoration(
                        // No suffix icon; feel free to add to show/hide
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: _confirmPasswordController.text ==
                                _passwordController.text
                            ? null
                            : "Passwords do not match",
                      ),
                    ),
                    Gap(18 * Dimensions.heightF(context)),
                    GradientButton(
                        onTap: (_emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty &&
                                _confirmPasswordController.text.isNotEmpty)
                            ? () async {
                                final result = await loginProvider.signUp(
                                  _emailController.text,
                                  _passwordController.text,
                                );

                                log("result is   $result");

                                if (result == "Signup Success") {
                                  // Show a dialog informing the user to verify their email
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Verification Email Sent"),
                                        content: const Text(
                                          "A verification link has been sent to your email. Please check your email and verify before logging in.",
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text("OK"),
                                            onPressed: () {
                                              RoutingService.goBack(context);
                                              RoutingService.gotoWithoutBack(
                                                  context, const LoginPage());
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(result.toString()),
                                    ),
                                  );
                                }
                              }
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Fields can't be empty"),
                                  ),
                                );
                              },
                        text: "Sign Up"),
                    Gap(10 * Dimensions.heightF(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Already have an account?"),
                        const Gap(5),
                        InkWell(
                          onTap: () {
                            RoutingService.goto(context, const LoginPage());
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
