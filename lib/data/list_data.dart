import 'package:flutter/material.dart';

class Item {
  String title;
  int value;

  Item({
    required this.title,
    required this.value,
  });
}

class Area {
  List<DropdownMenuItem<Item>> seoulArea = [];
}

class Kind {
  List<DropdownMenuItem> kinds = [];
}