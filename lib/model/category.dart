import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
  Housing,
  Transportation,
  Food,
  Utilities,
  Entertainment,
  Health,
  PersonalCare,
  Miscellaneous
}

class Category {
  //costructor
  const Category(this.title, this.color);

  final String title;
  final Color color;
}
