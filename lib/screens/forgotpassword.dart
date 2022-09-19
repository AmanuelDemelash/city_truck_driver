import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();
  TextEditingController forgot_email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/citytruck.jpg"))),
        ),
        Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7))),
        SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.start,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                width: Get.width,
                child: Column(
                  children: const [
                    Icon(
                      Icons.account_circle,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Enter your Email to forget your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontSize: 15, letterSpacing: 3),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Material(
                              elevation: 10,
                              color: Colors.white,
                              shadowColor: Colors.white,
                              child: TextFormField(
                                  controller: forgot_email,
                                  onSaved: (newValue) =>
                                      forgot_email.text != newValue,
                                  validator: (value) {
                                    if (value == null ||
                                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)) {
                                      return 'Enter a valid email!';
                                    }
                                    return null;
                                  },
                                  autofocus: false,
                                  cursorColor: Colors.orange,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.white,
                                      hintText: "Enter your email",
                                      hintStyle: TextStyle(fontSize: 12),
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ))),
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          // forgot button
                          Obx(
                            () => Get.find<AuthController>().isforget.value ==
                                    true
                                ? SpinKitFadingCircle(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: index.isEven
                                              ? Colors.orange
                                              : Colors.orange.shade300,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Colors.orange,
                                          blurRadius: 50,
                                          offset: Offset(10, 5))
                                    ]),
                                    width: Get.width,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: RaisedButton(
                                        highlightColor: Colors.orange,
                                        padding: const EdgeInsets.all(13),
                                        onPressed: () {
                                          _formkey.currentState!.save();
                                          if (_formkey.currentState!
                                              .validate()) {
                                            Get.find<AuthController>()
                                                .forgot_password(
                                                    forgot_email.text);
                                          }
                                        },
                                        color: Colors.orange,
                                        elevation: 5,
                                        child: const Text("Get password",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
