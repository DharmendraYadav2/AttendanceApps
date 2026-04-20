import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tutionsapp/Service/Firebase/controller/singup_ctrl.dart';

import '../Theme/app_fonts.dart';
import 'app_login.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  TextEditingController namectrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController passctrl = TextEditingController();
  bool ispasswrd = false;

  @override
  Widget build(BuildContext context) {
    final isloading = ref.watch(authcontrollerprovider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ClipPath(
            clipper: ArcClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              decoration: BoxDecoration(color: Colors.grey[200]),
            ),
          ),
          ClipPath(
            clipper: ArcClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.7,
              color: Colors.grey[300],
            ),
          ),
          ClipPath(
            clipper: ArcClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0575E6), Color(0xFF021B79)],
                ),
              ),
              child: Center(
                child: Text(
                  "Hajri Book",
                  style: AppFonts().heading.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Sign Up ",
                      style: AppFonts().heading.copyWith(
                        color: Color(0xFF0575E6),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),

                    child: TextField(
                      controller: namectrl,
                      enabled: !isloading,
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF0575E6)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          color: Color(0xFF0575E6),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),

                    child: TextField(
                      controller: emailctrl,
                      enabled: !isloading,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF0575E6)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          color: Color(0xFF0575E6),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),

                    child: TextField(
                      obscureText: !ispasswrd,
                      controller: passctrl,
                      enabled: !isloading,

                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF0575E6)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              ispasswrd = !ispasswrd;
                            });
                          },
                          icon: ispasswrd
                              ? Icon(Icons.remove_red_eye_outlined)
                              : Icon(
                                  Icons.visibility_off_outlined,
                                  color: Color(0xFF0575E6),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0575E6), Color(0xFF021B79)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: isloading
                            ? null
                            : () async {
                                final authctrl = ref.read(
                                  authcontrollerprovider.notifier,
                                );
                                try {
                                  if (namectrl.text.isNotEmpty &&
                                      emailctrl.text.isNotEmpty &&
                                      passctrl.text.isNotEmpty) {
                                    await authctrl.SignUp(
                                      name: namectrl.text.trim(),
                                      email: emailctrl.text.trim(),
                                      password: passctrl.text.trim(),
                                    );
                                    namectrl.clear();
                                    emailctrl.clear();
                                    passctrl.clear();
                                    Get.snackbar(
                                      'Successfully',
                                      "Sign Up",
                                      colorText: Colors.white,
                                      isDismissible: false,
                                      snackPosition: SnackPosition.TOP,
                                      margin: EdgeInsets.only(bottom: 10),
                                      borderRadius: 0,
                                    );
                                    Get.to(() => Login());
                                  } else {
                                    Get.snackbar(
                                      'Opps !',
                                      "One of the Field is Empty",
                                      colorText: Colors.white,
                                      isDismissible: false,
                                      snackPosition: SnackPosition.TOP,
                                      margin: EdgeInsets.only(bottom: 10),
                                      borderRadius: 0,
                                    );
                                  }
                                } catch (e) {
                                  print("error$e");
                                  String message = "Signup failed";

                                  if (e == "email-already-in-use") {
                                    message =
                                        "User already exists with this email";
                                  } else if (e == "weak-password") {
                                    message = "Password is too weak";
                                  }

                                  Get.snackbar(
                                    'Opps!',
                                    message,
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red,
                                    snackPosition: SnackPosition.TOP,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    borderRadius: 0,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isloading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Sign Up",
                                    style: AppFonts().heading.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 80),
                    child: Row(
                      children: [
                        Text(
                          "Already have account?  ",
                          style: AppFonts().heading.copyWith(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(
                              () => Login(),
                              transition: Transition.fadeIn,
                            );
                          },
                          child: Text(
                            "Login",
                            style: AppFonts().heading.copyWith(
                              color: Color(0xFF0575E6),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
