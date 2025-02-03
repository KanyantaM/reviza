import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:reviza/features/login/cubit/login_cubit.dart';
import 'package:reviza/features/sign_up/view/sign_up_page.dart';
import 'package:sign_in_button/sign_in_button.dart' show SignInButton, Buttons;

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login Failed')),
            );
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
                  'Welcome to ReviZa',
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
                        _PasswordInput(),
                        const SizedBox(height: 20),
                        _LoginButton(),
                        const SizedBox(height: 12),
                        _GoogleLoginButton(),
                        const SizedBox(height: 16),
                        _SignUpButton(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'By signing in, you agree to our Terms and Conditions.',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            // errorText:
            //     state.email.displayError != null ? 'Invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          obscureText: _obscureText,
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon:
                  Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            errorText:
                state.password.displayError != null ? 'Invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isValid
                ? () => context.read<LoginCubit>().logInWithCredentials()
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
            ),
            child: const Text('LOGIN',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.google,
      // width: double.infinity,
      // child: ElevatedButton.icon(
      //   icon: Container(
      //     padding: const EdgeInsets.all(6), // Adds spacing around the icon
      //     decoration: const BoxDecoration(
      //       color: Colors.white, // White background for the Google logo
      //       shape:
      //           BoxShape.circle, // Circular shape for better Google-like design
      //     ),
      //     child: Icon(
      //       FontAwesomeIcons.google,
      //       color: Colors.redAccent, // Google's primary blue
      //       size: 20,
      //     ),
      //   ),
      //   label: const Text(
      //     'Sign in with Google',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 16,
      //       color: Colors.white,
      //     ),
      //   ),
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: Colors.orangeAccent, // Google blue
      //     padding: const EdgeInsets.symmetric(vertical: 12),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //   ),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
      // ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: const Text(
        'CREATE ACCOUNT',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }
}
