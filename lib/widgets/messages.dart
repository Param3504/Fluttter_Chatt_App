import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var msg;

  var controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sendMssg() async {
    msg = controller.text;
        controller.clear();


    final currUser = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance.collection('users').doc(currUser.uid).get();

    await FirebaseFirestore.instance.collection('chats').add({
      'mssg': msg,
      'sendTime':Timestamp.now()   , 
      'userID':currUser.uid ,
      'username':userData.data()!['username'],
      'userImg':userData.data()!['img_url'],
    });

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              label: Text("Message "),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: sendMssg,
          color: const Color.fromARGB(255, 149, 255, 153),
        ),
      ],
    );
  }
}
