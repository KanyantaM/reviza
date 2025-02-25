import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:reviza/features/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:reviza/features/forgot_password/cubit/forgot_password_state.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listenWhen: (previous, current) => (previous.email == current.email),
        listener: (context, state) {
          if (!state.status.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Password reset failed'),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state.status.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset email sent!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.jpeg',
                  width: 100,
                ),
                const SizedBox(height: 16),
                Text(
                  'Reset Your Password',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _EmailInput(),
                        const SizedBox(height: 16),
                        _ResetPasswordButton(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) =>
              context.read<ForgotPasswordCubit>().emailChanged(email),
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }
}

class _ResetPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isValid
                ? () => context.read<ForgotPasswordCubit>().resetPassword()
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
            ),
            child: state.status.isInProgress
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'RESET PASSWORD',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }
}

// class EmailVerificationScreen extends StatelessWidget {
//   const EmailVerificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Email Verification')),
//       body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
//         listener: (context, state) {
//           if (state is EmailVerificationChecked) {
//             if (state.isVerified) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Email verified!'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//               Navigator.of(context).pushReplacementNamed('/home');
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Email not verified yet.'),
//                   backgroundColor: Colors.orange,
//                 ),
//               );
//             }
//           }
//         },
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Check your email for a verification link.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () =>
//                     context.read<AuthenticationCubit>().checkEmailVerification(),
//                 child: const Text('Check Verification Status'),
//               ),
//               TextButton(
//                 onPressed: () =>
//                     context.read<AuthenticationCubit>().sendPasswordResetEmail(''),
//                 child: const Text('Resend Verification Email'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
