import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_rest/screens/home.dart';
import 'package:test_rest/bloc/rec_combo_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2412),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => RecComboBloc(),
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Home(),
          ),
        );
      },
    );
  }
}