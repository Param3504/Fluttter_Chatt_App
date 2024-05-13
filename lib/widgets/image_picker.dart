import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  const PickImage(this.pickMyImage, {super.key});

  final void Function(File img) pickMyImage;

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? pickedImg;
  void pickImage() async {
    final myimg = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if (myimg == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('image not picked ')));
    }

    setState(() {
      pickedImg = File(myimg!.path);
    });
    widget.pickMyImage(pickedImg!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          foregroundImage: pickedImg != null ? FileImage(pickedImg!) : null,
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton.icon(
          onPressed: pickImage,
          icon: const Icon(Icons.person),
          label: Text(
            "Select a Profile picture",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
