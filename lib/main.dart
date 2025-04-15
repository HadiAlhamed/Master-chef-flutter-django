import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/auth/login.dart';
import 'package:testing_api/bindings/my_bindings.dart';
import 'package:get_storage/get_storage.dart';
import 'package:testing_api/views/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBindings(),
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.amber,
            backgroundColor: Colors.white,
          )),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/menu', page: () => Menu()),
      ],
    );
  }
}
