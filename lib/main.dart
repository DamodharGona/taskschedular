import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskschedular/bloc/auth_bloc/auth_bloc.dart';
import 'package:taskschedular/bloc/subject_bloc/subject_bloc.dart';
import 'package:taskschedular/core/services/exam_firestore.dart';
import 'package:taskschedular/core/services/task_firestore.dart';
import 'package:taskschedular/cubit/exam/cubit/exam_cubit.dart';
import 'package:taskschedular/cubit/task_cubit/task_cubit.dart';
import 'package:taskschedular/screens/on-boarding/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => SubjectBloc()),
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit(TaskFirestore()),
        ),
        BlocProvider<ExamCubit>(
          create: (context) => ExamCubit(ExamFirestore()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
