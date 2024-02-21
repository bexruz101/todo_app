import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/ui/auth/pages/widgets/input.dart';
import 'package:todo_app/utils/loading.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.toggleView});

  @override
  createState() => _SignUpPageState();

  final Function toggleView;
}

class _SignUpPageState extends State<SignUpPage> {
  AuthService _auth = AuthService();
  final _fromKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                    child: Form(
                  key: _fromKey,
                  child: Column(
                    children: [
                      const Text(
                        'Create account',
                        style: TextStyle(fontSize: 32),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Email'),
                        validator: (val) =>
                            email.isEmpty ? 'Enter an email' : null,
                        onChanged: (v) {
                          setState(() => email = v);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Password'),
                        validator: (val) => password.length < 6
                            ? 'Enter at least 6 chars'
                            : null,
                        onChanged: (v) {
                          setState(() => password = v);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 60,
                          width: 280,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.teal.withOpacity(0.6)),
                          child: ZoomTapAnimation(
                            onTap: () async {
                              if (_fromKey.currentState!.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        email: email, password: password);
                                if (result == null) {
                                  setState(() {
                                    error =
                                        'please enter a valid email or password';
                                    loading = false;
                                  });
                                }
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            children: [
                              TextSpan(
                                text: ' Register',
                                style: TextStyle(
                                  color: Colors.teal,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    widget.toggleView();
                                  },
                              )
                            ]),
                      ),
                    ],
                  ),
                )),
              ),
            ),
          );
  }
}
