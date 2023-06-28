import 'dart:convert';

//import 'package:expense_project/model/balance.dart';
import 'package:expense_project/widget/chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_project/data/categories.dart';

import 'package:expense_project/model/grocery_item.dart';
import 'package:expense_project/widget/new_item.dart';
import 'package:http/http.dart' as http;

class ExpenseList extends StatefulWidget {
  const ExpenseList({
    super.key,
  });

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  List<GroceryItem> expenseItems = [];
  double balance = 5000.0;
  var _isLoading = true;
  String? _error;

  // nak pastikan bila first time instane class in created die akan panggil function ni
  @override
  void initState() {
    super.initState();
    loadItems();
  }

  List<GroceryItem> getList() {
    return expenseItems;
  }

  // lepas dah add new data daripada database
  // perlu ke kita buat request balik daripada database??
  // tak peru sebab data yg sebelum ni dah ada dah
  // kita just append jer dekat list yang dah retrive dalam database sebelum insert data
  // kalau tak nnti kita akan buat unnsecessary request
  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      return;
    } else {
      setState(() {
        expenseItems.add(newItem);
        _isLoading = false;
      });
    }
  }

  void _removeItem(GroceryItem item) async {
    // dapatkan index item sbb nnti bole insert balik kat tempat asal die
    // kalau delete failed
    final index = expenseItems.indexOf(item);
    setState(() {
      //update local list
      expenseItems.remove(item);
    });

    final url = Uri.https('xpense-yourfirebase-database.firebaseio.com',
        '/expense-list/${item.id}.json'); // kne target spesific id
    final response = await http.delete(url);

    // kalau time nak delete dekat database ada error
    // kita add balik item dalam list local
    if (response.statusCode >= 400) {
      setState(() {
        expenseItems.insert(index, item);
      });
    }
  }

  void calculateBalance() {
    for (final expense in expenseItems) {
      balance = balance - expense.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      calculateBalance();
    });

    Widget content = const Center(
      child: Text('No items added yet'),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (expenseItems.isNotEmpty) {
      content = Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Colors.indigo, Colors.blue]),
        ),
        child: ListView.builder(
          itemCount: expenseItems.length,
          itemBuilder: (ctx, index) => Dismissible(
            //apa yang jadi bila die swipe kanan
            onDismissed: (direction) {
              _removeItem(expenseItems[index]);
            },

            //untuk dismissible die pon mesti kne ada key utk buat die boleh delete
            key: ValueKey(expenseItems[index].id),
            child: ListTile(
              title: Text(
                  expenseItems[index].name[0].toUpperCase() +
                      expenseItems[index].name.substring(1).toLowerCase(),
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              leading: Container(
                width: 24,
                height: 24,
                color: expenseItems[index].category.color,
              ),
              trailing: Text(
                ' RM ${double.parse((expenseItems[index].quantity).toStringAsFixed(2))} ',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xpense Tracker'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.purple, Colors.blue]),
          ),
        ),
      ),
      body: content,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        // color: Color.fromARGB(255, 16, 55, 87),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.purple, Colors.blue]),
          ),
          child: Row(
            children: [
              Text(
                '  Balance: RM ${double.parse((balance).toStringAsFixed(2))}',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const Spacer(),
              const Text(
                'Chart Report',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChartPage(expenseItems: expenseItems))),
                  icon: const Icon(
                    Icons.chrome_reader_mode_rounded,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
    );
  }


  void loadItems() async {

    //url expense list
    final url = Uri.https(
        'xpense-6e508-default-rtdb.firebaseio.com', 'expense-list.json');

    // better error handling
    try {
      final response = await http.get(url);

      //cara nak handle error kalau salah request
      // if (response.statusCode >= 400 || response2.statusCode >= 400) {
      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later';
        });
      }

      print(response.body);
      //untuk jsondecode ni kalau response body die null
      // nnti akan ada problem sbb null bukan subtye of Map<String, dynamic>

      // if (response.body == 'null' || response2.body == 'null') {
      if (response.body == 'null') {
        //dekat sini null die special dlm string sbb firebase yg return mcmtu
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        loadedItems.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category));
      }

      setState(() {
        expenseItems = loadedItems;
      });
    } catch (err) {
      setState(() {
        _error = 'Failed to fetch data. Please try again later';
      });
    }
  }
}
