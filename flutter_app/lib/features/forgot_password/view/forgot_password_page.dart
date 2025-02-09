import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:reviza/features/forgot_password/view/forgot_password_view.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: ForgotPasswordPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) =>
              ForgotPasswordCubit(context.read<AuthenticationRepository>()),
          child: const ForgotPasswordForm(),
        ),
      ),
    );
  }
}
