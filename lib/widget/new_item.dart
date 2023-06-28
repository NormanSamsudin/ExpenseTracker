import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:expense_project/data/categories.dart';
import 'package:expense_project/model/category.dart';
import 'package:expense_project/model/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  // setiap form mmg akan ada key die
  final _formKey = GlobalKey<FormState>();

  var _enteredName = '';
  var _enteredQtt = 1.0;
  var _selectCategory = categories[Categories.Entertainment]!;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      //validate akan return boolean value
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      // save() akan trigger parameter onSave dalam textformfield
      print(_enteredName);
      print(_enteredQtt);
      print(_selectCategory.title);
      //================================================================================================
      final url = Uri.https('xpense-yourfirebase-database.firebaseio.com',
          '/expense-list.json'); // not complete url
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQtt,
            'category': _selectCategory.title
          },
        ),
      );

      print(response.body);
      print(response.statusCode);

      final Map<String, dynamic> resData = json.decode(response.body);

      //===================================================================================================
      // kalau die not mounted so die akan kekal dekat page yang sama
      if (!context.mounted) {
        return;
      }

      // nnti akan perasan die akan lambat skit untuk pergi page lain sbb tunggu kasi mounted

      // tapi kalo mounted die akan pop untuk patah balik ke page belakang.
      // tapi kalini poop die xde data hanya pop kosong jer
      Navigator.of(context).pop(GroceryItem(
          id: resData['name'],
          name: _enteredName,
          quantity: _enteredQtt,
          category: _selectCategory));

      // Navigator.of(context).pop(GroceryItem(
      //     id: DateTime.now().toString(),
      //     name: _enteredName,
      //     quantity: _enteredQtt,
      //     category: _selectCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.purple, Colors.blue]
              ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.indigo, Colors.blue]
              ),
          ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
              key: _formKey,
              child: Column(
                
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Name', style: TextStyle(color: Colors.white),),
                    ),
                    //return error message
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return 'Must be between 1 and 50 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Price', style: TextStyle(color: Colors.white)),
                            
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: '1',
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                double.tryParse(value) == null ||
                                double.tryParse(value)! <= 0) {
                              return 'Must be a valid, positive number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredQtt = double.parse(value!);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                            value: _selectCategory,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),    
                            ),
                            //style: TextStyle(color: Colors.black),
                            items: [
                              for (final category in categories.entries)
                                DropdownMenuItem(
                                    value: category.value,
                                    child: Row(
                                      children: [
                                        Container(
                                          //decoration: BoxDecoration(color: Colors.black),
                                          width: 16,
                                          height: 16,
                                          color: category.value.color,
                                        ),
                                        const SizedBox(

                                          width: 6,
                                        ),
                                        Text(category.value.title,  style: TextStyle(color: Colors.black))
                                      ],
                                    ))
                            ],
                            //untuk dropdown dah tak perlu pakai onsave dah pakai onchange jer
                            onChanged: (value) {
                              setState(() {
                                _selectCategory = value!;
                              });
                            }),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: _isSending ? null : () {
                            _formKey.currentState!.reset();
                          },
                          child: const Text('Reset', style: TextStyle(color: Colors.white),)),
                      ElevatedButton(
                          onPressed:_isSending ? null : _saveItem, 
                          child: _isSending 
                          ? const  SizedBox(
                            height: 16, 
                            width: 16, 
                            child: CircularProgressIndicator(),
                            ) 
                          : const Text ('Add Item'),
                          )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
