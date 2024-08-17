import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskschedular/bloc/auth_bloc/auth_bloc.dart';
import 'package:taskschedular/core/utils/utils.dart';
import 'package:taskschedular/screens/home/home_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(image: AssetImage('assets/images/introimage.png')),
                  SizedBox(height: 30),
                  Text(
                    'CREATE, NOTIFY, TRACK ,FINISH',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Stay organized with tasks and assignments, receive timely reminders for your timetable and upcoming exams, and never miss a priority task with our intuitive app.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    showCustomSnackbar(
                      context,
                      message: state.message,
                      showCloseIcon: true,
                    );
                  }

                  if (state is AuthSuccess) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const CircularProgressIndicator();
                  }

                  return GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(SignInWithGoogleEvent());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            padding: const EdgeInsets.only(left: 4),
                            icon: const Icon(
                              Icons.arrow_circle_right,
                              color: Colors.white,
                              size: 55,
                            ),
                          ),
                          const Text(
                            'continue with',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: const SizedBox(
                              height: 60,
                              width: 60,
                              child: Image(
                                image: AssetImage('assets/images/google.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
