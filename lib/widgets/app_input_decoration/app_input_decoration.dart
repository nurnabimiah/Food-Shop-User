import 'package:flutter/material.dart';

appInputDecoration(String hintText,Icon prefixIcon) {
  return InputDecoration(

    filled: true,
    fillColor: Colors.grey,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),

        ),
        borderSide: BorderSide.none),
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),

  );
}
