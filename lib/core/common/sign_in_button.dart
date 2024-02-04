// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growgrid/core/constants/constants.dart';
import 'package:growgrid/features/auth/controlller/auth_controller.dart';
// ignore: unused_import
import 'package:growgrid/theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({Key? key, this.isFromLogin = true}) : super(key: key);

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref
        .refresh(authControllerProvider.notifier)
        .signInWithGoogle(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context, ref),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text(
          "let's Go    >>>",
          style: TextStyle(
            fontSize: 28,
            letterSpacing: 2.7,
            color: Color.fromARGB(255, 255, 255, 1),
            shadows: [
              Shadow(
                offset: Offset(8.0, 8.0),
                blurRadius: 17.0,
                color: Color.fromARGB(226, 0, 0, 0), // Set your desired shadow color here
              ),
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(0, 26, 39, 45),
          minimumSize: const Size(double.minPositive, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
