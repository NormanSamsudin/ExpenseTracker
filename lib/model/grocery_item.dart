import 'package:expense_project/model/category.dart';

class GroceryItem {
  //constructor
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  final String id;
  final String name;
  final double quantity;
  final Category category;
}


