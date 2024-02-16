import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text,Color colors){

  final snackbar = SnackBar(
    backgroundColor: colors,
    content: Row(
      children: [
        Icon(Icons.info_outline,color: Colors.white),
        SizedBox(width: 20),
        Expanded(
          child: Text(text,
            style: TextStyle(fontSize: 16),),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}