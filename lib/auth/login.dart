import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/auth/signup.dart';
import 'package:testing_api/controllers/passwordController.dart';
import 'package:testing_api/services/apis_services/auth_apis/auth_apis.dart';
import 'package:testing_api/views/menu.dart';
import 'package:testing_api/widgets/auth_input.dart';
import 'package:testing_api/widgets/my_button.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Passwordcontroller getPasswordcontroller =
        Get.find<Passwordcontroller>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Login",
          style: TextStyle(
            fontFamily: "Lobster",
            color: Colors.amber,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Form(
            key: formState,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 150,
                    backgroundImage: AssetImage(
                      "assets/images/login _logo.jpg",
                    ),
                  ),
                  AuthInput(
                    title: "Username",
                    controller: usernameController,
                    isObsecure: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () {
                      return AuthInput(
                        title: "Password",
                        controller: passwordController,
                        isObsecure: !getPasswordcontroller.showPassword.value,
                        suffixWidget: IconButton(
                          onPressed: () {
                            getPasswordcontroller.changeVisibility();
                          },
                          icon: Icon(!getPasswordcontroller.showPassword.value
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye_rounded),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    title: "Login",
                    color: Colors.amber,
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        bool result = await AuthApis.login(
                          username: usernameController.text,
                          password: passwordController.text,
                        );

                        //if result true go to home page
                        //else show an error message
                        if (result) {
                          Get.off(
                            () => Menu(),
                            duration: const Duration(milliseconds: 500),
                            transition: Transition.fadeIn,
                          );
                        } else {
                          await AwesomeDialog(
                            context: context,
                          ).show();
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    child: const Text(
                      "Register Instead",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 17,
                        fontFamily: "Lobster",
                      ),
                    ),
                    onPressed: () {
                      Get.off(
                        () => Signup(),
                        transition: Transition.fade,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
