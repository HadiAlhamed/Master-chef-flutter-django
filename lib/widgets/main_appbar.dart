import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/auth/login.dart';
import 'package:testing_api/services/apis_services/auth_apis/auth_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/widgets/my_snackbar.dart';

class MainAppBar extends AppBar {
  final String myTitle;
  MainAppBar({required this.myTitle, super.key})
      : super(
          title: Text(myTitle, style: atitleTextStyle1),
          actions: [
            // Your custom icon button
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                bool result = await AuthApis.logout();
                if (result) {
                  Get.off(
                    () => Login(),
                    transition: Transition.native,
                    duration: const Duration(milliseconds: 400),
                  );
                } else {
                  Get.showSnackbar(
                    MySnackbar(
                        success: false,
                        title: 'Error',
                        message: 'An Error Has Occurred, Try Later.'),
                  );
                }
              },
            ),
          ],
        );
}
