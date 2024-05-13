import 'package:flutter/material.dart';
class LoadScreen extends StatelessWidget {
  const LoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loading..."),
      ),
      body:  Container(
        height: 250 , width: 250,
        child:const  Icon(Icons.face_retouching_natural , size: 250 ,),
      ),
    );
  }
}