import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:horizon/components/index.dart';
import 'package:horizon/constants/index.dart';
import 'package:horizon/main_screens/index.dart';
import 'package:horizon/provider/index.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [black, darkBlue],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 40 * Dimensions.heightF(context),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, top: 50, right: 24, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Join Our\nCommunity Today",
                      style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                    Gap(16 * Dimensions.heightF(context)),
                    Text(
                      "Get connected, find gamers",
                      style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                    Gap(40 * Dimensions.heightF(context)),
                    GradientButton(
                      onTap: () {
                        RoutingService.goto(context, const SignupScreen());
                      },
                      text: "Signup",
                    ),
                    Gap(24 * Dimensions.heightF(context)),
                    const Center(
                      child: Text(
                        "Or, login with",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF3E334E),
                        ),
                      ),
                    ),
                    Gap(16 * Dimensions.heightF(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100 * Dimensions.widthP(context),
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8)),
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "This Feature will be available in the future. Stay Tuned!"),
                                ),
                              );
                            },
                            child: const Center(
                              child: Text("Facebook"),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 100 * Dimensions.widthP(context),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8)),
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "This Feature will be available in the future. Stay Tuned!"),
                                ),
                              );
                            },
                            child: const Center(
                              child: Text("Linked In"),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 100 * Dimensions.widthP(context),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8)),
                          child: InkWell(
                            onTap: () {},
                            child: InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "This Feature will be available in the future. Stay Tuned!"),
                                  ),
                                );
                              },
                              child: const Center(
                                child: Text("Google"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(45 * Dimensions.heightF(context)),
                    Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor),
                    ),
                    Gap(8 * Dimensions.heightF(context)),
                    TextFormField(
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
                      controller: _emailController,
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
                            : "Invalid password",
                      ),
                      onChanged: (value) {
                        loginProvider.validatePassword(value);
                      },
                    ),
                    Gap(18 * Dimensions.heightF(context)),
                    GradientButton(
                        onTap: () async {
                          final result = await loginProvider.signIn(
                            _emailController.text,
                            _passwordController.text,
                          );

                          if (result == "Login Success") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result.toString())));
                            RoutingService.gotoWithoutBack(
                                context, const Homepage());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.toString()),
                              ),
                            );
                          }
                        },
                        text: "Login"),
                    Gap(5 * Dimensions.heightF(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => _showForgotPasswordDialog(),
                          child: const Text("Forgot Password?"),
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

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Forgot Password"),
          content: TextField(
            controller: _emailController,
            decoration: const InputDecoration(
                labelText: "Enter your email", border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Call the send password reset email method
                _sendPasswordResetEmail(_emailController.text);
                RoutingService.goBack(context); // Close the dialog
              },
              child: const Text("Send"),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                RoutingService.goBack(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Method to send the password reset email
  Future<void> _sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an email address")),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset link sent!")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An error occurred")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred")),
      );
    }
  }
}
