import 'package:flutter/material.dart';

import 'package:expense_project/model/category.dart';

const categories = {
  Categories.Housing: Category(
    'Housing',
    Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.Transportation: Category(
    'Transportation',
    Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.Food: Category(
    'Food',
    Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.Utilities: Category(
    'Utilities',
    Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.Entertainment: Category(
    'Entertainment',
    Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.Health: Category(
    'Health',
    Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.PersonalCare: Category(
    'PersonalCare',
    Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.Miscellaneous: Category(
    'Miscellaneous',
    Color.fromARGB(255, 191, 0, 255),
  ),
  // Categories.hygiene: Category(
  //   'Hygiene',
  //   Color.fromARGB(255, 149, 0, 255),
  // ),
  // Categories.other: Category(
  //   'Other',
  //   Color.fromARGB(255, 0, 225, 255),
  // ),
};