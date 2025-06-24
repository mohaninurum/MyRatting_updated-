import 'dart:io';

import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValidationUtils {
  static bool validateEmail(String email, var emailError) {
    if (email.isEmpty) {
      emailError.value = 'Email cannot be empty';
      return false;
    } else if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(email)) {
      emailError.value = 'Please enter a valid email';
      return false;
    }
    emailError.value = '';
    return true;
  }

  static bool validateName(String name, var nameError) {
    if (name.isEmpty) {
      nameError.value = 'Enter your name';
      return false;
    }
    nameError.value = '';
    return true;
  }

  static bool validatePassword(String password, var passwordError) {
    if (password.isEmpty) {
      passwordError.value = 'Password cannot be empty';
      return false;
    }
    /*  else if (password.length < 5) {
      passwordError.value = 'Password must be at least 5 characters';
      return false;
    }*/
    passwordError.value = '';
    return true;
  }

  static bool validateReenterPassword(String password, String reenterPassword, var reenterPasswordError) {
    if (reenterPassword.isEmpty) {
      reenterPasswordError.value = 'Enter password';
      return false;
    } else if (password != reenterPassword) {
      reenterPasswordError.value = 'Passwords do not match';
      return false;
    }
    reenterPasswordError.value = '';
    return true;
  }

  // for internet connection

  static Future<bool> checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      showNoInternetDialog();
      print('not connected');
      return false;
    }
    return false;
  }

  static void showNoInternetDialog() {
    Get.defaultDialog(
      title: "No Connection",
      titleStyle: AppFonts.IBMPlexSans.copyWith(
        color: Colors.red, // Custom title color
        fontSize: 18, // Custom title font size
        fontWeight: FontWeight.bold,
      ),
      middleText: "Please check your internet connectivity and try again.",
      middleTextStyle: AppFonts.IBMPlexSans.copyWith(color: AppColors.primaryColor),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // Close the dialog
        },
        child: Text(
          'OK',
          style: AppFonts.IBMPlexSans.copyWith(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          minimumSize: Size(20, 40),
        ),
      ),
    );
  }
}
