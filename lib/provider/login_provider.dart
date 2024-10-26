import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool _obscureText = true;
  bool _isValidEmail = true;
  bool _isValidPassword = true;

  bool get obscureText => _obscureText;
  bool get isValidEmail => _isValidEmail;
  bool get isValidPassword => _isValidPassword;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Toggle password visibility
  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  // Validate email
  void validateEmail(String email) {
    _isValidEmail = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(email);
    notifyListeners();
  }

  // Validate password
  void validatePassword(String password) {
    _isValidPassword = password.length >= 8;
    notifyListeners();
  }

//sign up with email and password
  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.sendEmailVerification();
      return "Signup Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An error occurred";
    }
  }

  Future<void> saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // Sign in with email and password
  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return "Please verify your email to login";
      }
      await saveLoginState(true);
      return "Login Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An error occurred";
    }
  }

  // Logout function
  Future<void> signOut() async {
    await _auth.signOut();
    await saveLoginState(false);
  }
}
