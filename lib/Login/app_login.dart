import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tutionsapp/Login/app_singnup.dart';
import 'package:tutionsapp/Service/Firebase/controller/singup_ctrl.dart';

import '../Screen/home.dart';
import '../Theme/app_fonts.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  TextEditingController emctrl = TextEditingController();
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
                      "Login Up ",
                      style: AppFonts().heading.copyWith(
                        color: Color(0xFF0575E6),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),

                    child: TextField(
                      controller: emctrl,
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
                      enabled: !isloading,
                      controller: passctrl,
                      obscureText: !ispasswrd,
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
                                  if (emctrl.text.isNotEmpty &&
                                      passctrl.text.isNotEmpty) {
                                    await authctrl.loginup(
                                      email: emctrl.text.trim(),
                                      password: passctrl.text.trim(),
                                    );
                                    emctrl.clear();
                                    passctrl.clear();
                                    Get.snackbar(
                                      'Successfully !',
                                      "Login",
                                      colorText: Colors.white,
                                      isDismissible: false,
                                      snackPosition: SnackPosition.TOP,
                                      margin: EdgeInsets.only(bottom: 10),
                                      borderRadius: 0,
                                    );

                                    Get.off(
                                      () => Home(),
                                      transition: Transition.fadeIn,
                                    );
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
                                  String message = "Login failed";

                                  if (e == "user-not-found") {
                                    message = "No account found for this email";
                                  } else if (e == "wrong-password") {
                                    message = "Incorrect password";
                                  } else if (e == "invalid-email") {
                                    message = "Invalid email format";
                                  }

                                  Get.snackbar(
                                    "Opps!",
                                    message,
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red,
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
                                    "Login",
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
                    padding: EdgeInsets.only(left: 70),
                    child: Row(
                      children: [
                        Text(
                          "Don't have an account?  ",
                          style: AppFonts().heading.copyWith(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(
                              () => Signup(),
                              transition: Transition.fadeIn,
                            );
                          },
                          child: Text(
                            "Sign Up",
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
