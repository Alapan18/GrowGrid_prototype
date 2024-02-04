// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growgrid/core/common/loader.dart';
import 'package:growgrid/core/common/sign_in_button.dart';
import 'package:growgrid/core/constants/constants.dart';
import 'package:growgrid/features/auth/controlller/auth_controller.dart';
import 'package:growgrid/responsive/responsive.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      body: isLoading
          ? const Loader()
          : Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Constants.loginEmotePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Dive into anything ..',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Color.fromARGB(255, 255, 255, 1),
                        shadows: [
                          Shadow(
                            offset: Offset(8.0, 8.0),
                            blurRadius: 17.0,
                            color: Color.fromARGB(226, 0, 0,
                                0), // Set your desired shadow color here
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40), // Adjust spacing as needed
                  Responsive(child: SignInButton()),
                ],
              ),
            ),
    );
  }
}
