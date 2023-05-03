import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:spacenetic_flutter/Functions/fetch_planetAPI.dart';
// import 'package:spacenetic_flutter/StateManagement/api_cubit/cubit/planet_api_cubit.dart';
import 'package:spacenetic_flutter/UI/homepage.dart';
import 'package:spacenetic_flutter/UI/login_page.dart';
import 'package:spacenetic_flutter/UI/signup_page.dart';
import 'package:spacenetic_flutter/firebase_options.dart';
import 'package:spacenetic_flutter/UI/timeline_page.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        // home: SignUpPage(),
        //home: LoginPage());
        home: HomePage());
    //home: TimelineWidget(),
  }
}
