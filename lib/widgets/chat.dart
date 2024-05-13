import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').orderBy(
          'sendTime' , 
          descending: true,

        ).snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No messages yet "));
          }

          if (snapshot.hasError) {
            const Center(child: Text("error.... "));
          }

          return ListView.builder(
              itemBuilder: (ctx, index) =>
                  Text(snapshot.data!.docs[index]['mssg']));
        });
  }
}
