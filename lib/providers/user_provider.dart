import 'package:climate/models/user.dart';
import 'package:climate/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? _user; //_ makes it private
  final AuthMethods _authMethods = AuthMethods();
  User get getUser =>
      _user!; //used to access the user model through the private object _user
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners(); //used to notify the clients about changs in the object
  } //updates the values of the user.
}
