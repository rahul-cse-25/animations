import 'package:flutter/material.dart';

class ImpCursor extends StatefulWidget {
  const ImpCursor({super.key});

  @override
  State<ImpCursor> createState() => _ImpCursorState();
}

class _ImpCursorState extends State<ImpCursor> {






  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.grey,
              cursorHeight: 30,
              cursorWidth: 5,
              cursorRadius: Radius.circular(30),
              cursorOpacityAnimates: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
          ),
        ),
      ),
    );
  }
}