import 'package:flutter/material.dart';
import 'package:notodo_app/themes.dart';
import 'notodo_screen.dart';
import 'dart:async';

class HomePage extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Theme"),
      ),
      body: NotoDoScreen(),

    );
  }
}
