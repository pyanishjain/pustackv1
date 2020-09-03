import 'package:flutter/material.dart';

Widget brandName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(child: Icon(Icons.book, color: Colors.white)),
      Text(
        "PuStack",
        style: TextStyle(
            color: Colors.white, fontFamily: 'Overpass', fontSize: 30),
      )
    ],
  );
}
