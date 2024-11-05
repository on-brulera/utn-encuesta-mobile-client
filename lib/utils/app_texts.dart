import 'package:flutter/material.dart';

class AppTexts {
  static title(String text) => Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
  static subTitle(String text) => Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
      );

  static textNotification(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      );
  static commentNotification(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      );
  static numberNotification(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      );
}
