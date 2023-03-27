import 'dart:io';

import 'package:figure_flutter/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'backend.dart';
import 'figure_page.dart';

class UploadWidget extends StatefulWidget {
  const UploadWidget({super.key});

  @override
  State<StatefulWidget> createState() => UploadState();
}

class UploadState extends State<UploadWidget> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  late String title;
  late String description;


  @override
  Widget build(BuildContext context) {
    return (
    SafeArea(
      child: ListView(children: [
        ElevatedButton(onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
          if (result != null) {
            File file = File(result.files.single.path!);
            setState(() {
              image = file;
            });
          }
        }, child: const Text("Choose an image")),
        image == null ? Container() :
            Column(children: [
              Image.file(image!),
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    validator: (value) => (value == null || value.isEmpty) ? "Please enter a title." : null,
                    onChanged: (value) => title = value,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  TextFormField(
                    validator: (value) => (value == null || value.isEmpty) ? "Please enter a description." : null,
                    onChanged: (value) => description = value,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var result = await upload(title, description, image?.readAsBytesSync(), sessionToken);
                          if (result != null) {
                            setState(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => FigurePage(result)));
                            });
                          }
                        }
                      },
                      child: const Text("Upload"))
                ])
              )

            ])
      ])
    )
    );
  }
}
