
import 'dart:io';

import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {

  final File _image;

  const ImageScreen(this._image, {Key? key}) : super(key: key);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(widget._image),
    );
  }
}
