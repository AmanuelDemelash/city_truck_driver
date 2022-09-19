import 'package:city_truck_driver/model/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var issignup = false.obs;
  var issignin = false.obs;
  var isforget = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offNamed("/signin");
  }

  Future<void> forgot_password(String email) async {
    isforget.value = true;
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      isforget.value = false;
      Get.snackbar(
          "Forgottrn password", "Cheek your email to forgot your password",
          snackPosition: SnackPosition.BOTTOM,
          padding: const EdgeInsets.all(5),
          duration: const Duration(seconds: 2));
    });
    Get.offNamed("/signin");
  }

  Future<void> Signup_driver(Driver driver, String password) async {
    issignup.value = true;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: driver.email,
        password: password,
      );
      if (credential.user != null) {
        // store user information
        create_driver(driver);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("weak password", "make your password strong",
            snackPosition: SnackPosition.BOTTOM,
            padding: const EdgeInsets.all(5),
            duration: const Duration(seconds: 2));
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("account already in use",
            "The account already exists for that email",
            snackPosition: SnackPosition.BOTTOM,
            padding: const EdgeInsets.all(5),
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> create_driver(
    Driver driver,
  ) async {
    firestore
        .collection("drivers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'id': FirebaseAuth.instance.currentUser!.uid.toString(),
      'name': driver.name,
      'email': driver.email,
      'phone': driver.phone,
      'experiance': driver.experiance,
      'license_validity': driver.license_validity,
      'rate': driver.rate,
      'profile_image': driver.profile_image
    }).then((value) {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      issignup.value = false;
      Get.snackbar("Verify your email",
          "we send you an email to verify your account.. cheek your email and verify",
          snackPosition: SnackPosition.BOTTOM,
          padding: const EdgeInsets.all(5),
          duration: const Duration(seconds: 4));
      Get.toNamed("/signin");
    }).catchError((error) {
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          padding: const EdgeInsets.all(5),
          duration: const Duration(seconds: 4));
    });
  }

  Future<void> Signin_driver(String email, String password) async {
    issignin.value = true;

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          issignin.value = false;
          Get.offNamed("/homepage");
        } else {
          issignin.value = false;
          Get.snackbar("Email is not verified", "Verify your email account",
              snackPosition: SnackPosition.BOTTOM,
              padding: const EdgeInsets.all(5),
              duration: const Duration(seconds: 3));
        }
      }
    } on FirebaseAuthException catch (e) {
      issignin.value = false;
      if (e.code == 'user-not-found') {
        Get.snackbar("Erorr", "No user found for that email",
            snackPosition: SnackPosition.BOTTOM,
            padding: const EdgeInsets.all(5),
            duration: const Duration(seconds: 2));
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Erorr", "Wrong password provided for that user",
            snackPosition: SnackPosition.BOTTOM,
            padding: const EdgeInsets.all(5),
            duration: const Duration(seconds: 2));
      }
    }
  }
}
