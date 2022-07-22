import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_memo_app/Enum/user_account_action_state.dart';
import 'package:flutter/material.dart';

import 'package:firebase_memo_app/Enum/sign_in_state.dart';
import 'package:firebase_memo_app/Enum/sign_up_state.dart';
import 'package:firebase_memo_app/ViewModel/sign_in_view_model.dart';

class SignInView extends StatefulWidget {
  SignInView({Key? key, required this.state}) : super(key: key);
  UserAccountActionState state;

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool passwordVisibleState = false;
  final signInViewModel = SignInViewModel();

  @override
  void initState() {
    super.initState();
    // 텍스트필드 초기화
    signInViewModel.initTextField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.state.getTitle()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                signInViewModel.updateID(value);
              },
            ),
            TextField(
              obscureText: !passwordVisibleState,
              obscuringCharacter: "*",
              onChanged: (value) {
                signInViewModel.updatePW(value);
              },
            ),
            Row(
              children: [
                Checkbox(
                    value: passwordVisibleState,
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        if (passwordVisibleState == false) {
                          passwordVisibleState = true;
                        } else {
                          passwordVisibleState = false;
                        }
                      });
                    }),
                const Text('비밀번호 보이게'),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await signInViewModel.userAccountButtonClicked(
                    context, widget.state);
                if (result) {
                  Navigator.of(context);
                }
              },
              child: Text(widget.state.getTitle()),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     final result = await signInViewModel.signUpEmail();
            //     // _showSnackBar(context, result.getString());
            //     if (result == SignUpState.success) {
            //       Navigator.pop(context);
            //     }
            //   },
            //   child: Text(widget.state.getTitle()),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await FirebaseAuth.instance.signOut();
            //   },
            //   child: const Text('로그아웃'),
            // ),
          ],
        ),
      ),
    );
  }
}
