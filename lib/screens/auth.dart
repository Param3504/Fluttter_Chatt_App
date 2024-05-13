import 'dart:io';

import 'package:chat_app/widgets/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authObj = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLogin = true;
  var email;
  var pwd;
  var username;
  File? pickedImage;
  var isSaving = false;

  final formkey = GlobalKey<FormState>();
  void submit() async {
    if (isLogin == false && pickedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload Image first ')));
      print("kabhi nhi ");
      return;
    }
    if (formkey.currentState!.validate()) {
      setState(() {
        isSaving = true;
      });
      formkey.currentState!.save();

      if (!isLogin) {
        try {
          final userDetails = await authObj.createUserWithEmailAndPassword(
              email: email, password: pwd);
          final storage = FirebaseStorage.instance
              .ref()
              .child('userImages')
              .child('${userDetails.user!.uid}.jpg');
          await storage.putFile(pickedImage!);
          final url = await storage.getDownloadURL();

          final r = await FirebaseFirestore.instance
              .collection('users')
              .doc(userDetails.user!.uid)
              .set({
            'username': username,
            'email': email,
            'img_url': url,
          });
          print('succcccccccccccccccccccccccccccccccccccc');
        } on FirebaseAuthException catch (error) {
          // if(error.code='')
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message ?? 'Authentication failed'),
            ),
          );
          setState(() {
            isSaving = false;
          });
        }
      } else {
        try {
          final userDetails = await authObj.signInWithEmailAndPassword(
              email: email, password: pwd);

          print(userDetails);
        } on FirebaseAuthException catch (error) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message ?? 'Authentication failed'),
            ),
          );
        }
      }

      // print('$email , $pwd');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                margin: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 20, right: 20),
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        if (!isLogin)
                          PickImage((value) {
                            pickedImage = value;
                          }),
                        const SizedBox(
                          height: 16,
                        ),
                        if(!isLogin)
                          TextFormField(
                          decoration: const InputDecoration(
                            label: Text(
                              "Username",
                            ),
                          ),
                          autocorrect: false,
                          // textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 5) {
                              return 'Username cannot be smaller than 5 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            username = value;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text(
                              "Enter email",
                            ),
                          ),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Enter valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Enter Passsword"),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 8) {
                              return 'Password must be 8 characters long  ';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            pwd = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (isSaving) const CircularProgressIndicator(),
                        if (!isSaving)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            onPressed: submit,
                            icon: isLogin
                                ? const Icon(Icons.login_outlined)
                                : const Icon(Icons.create),
                            label: isLogin
                                ? const Text('Login')
                                : const Text('sign-up'),
                          ),
                        if (!isSaving)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                formkey.currentState!.reset();
                                isLogin = !isLogin;
                              });
                            },
                            icon: Icon(isLogin ? Icons.create : Icons.login),
                            label: isLogin
                                ? const Text('Create Acoount ')
                                : const Text("Already have an account ?"),
                          )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
