import 'package:expense_project/model/category.dart';
import 'package:expense_project/widget/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:expense_project/model/chart.dart';
import 'package:expense_project/model/grocery_item.dart';

class ChartPage extends StatelessWidget {
  final List<GroceryItem> expenseItems;

  // constructor
  ChartPage({required this.expenseItems});

  ExpenseList expinstance = ExpenseList();

  List<ChartData> chartData = [];


  //
  double sumEntertainment = 0;
  double sumFood = 0;
  double sumHealth = 0;
  double sumHousing = 0;
  double sumMisc = 0;
  double sumPersonal = 0;
  double sumTransport = 0;
  double sumUtilities = 0;

  double percentEntertainment = 0;
  double percentFood = 0;
  double percentHealth = 0;
  double percentHousing = 0;
  double percentMisc = 0;
  double percentPersonal = 0;
  double percentTransport = 0;
  double percentUtilities = 0;


  @override
  Widget build(BuildContext context) {
    print('list of expense');
    for (final expense in expenseItems) {
      print(expense.name);
      print(expense.quantity);
    }

    calculateChartData();

    print(' food ${sumFood}');

    final List<ChartData> chartData = [
      ChartData('Entertainment', double.parse((percentEntertainment*100).toStringAsFixed(2)), Color.fromARGB(255, 187, 47, 47)),
      ChartData('Food', double.parse((percentFood*100).toStringAsFixed(2)), Colors.blue),
      ChartData('Health', double.parse((percentHealth*100).toStringAsFixed(2)), Colors.green),
      ChartData('Housing', double.parse((percentHousing*100).toStringAsFixed(2)), Colors.orange),
      ChartData('Misc', double.parse((percentMisc*100).toStringAsFixed(2)), Colors.red),
      ChartData('Personal Care', double.parse((percentPersonal*100).toStringAsFixed(2)), Colors.lime),
      ChartData('Transportation', double.parse((percentTransport*100).toStringAsFixed(2)), Colors.purpleAccent),
      ChartData('Utilities', double.parse((percentUtilities*100).toStringAsFixed(2)), Colors.teal),
    ];

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.purple, Colors.blue]
              ),
          ),
        ),
        title: const Text('Expense Distribution'),
      ),
      body: Container(
        decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[Colors.purple, Colors.blue]
                      ),
                  ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: SfCircularChart(
                    legend: Legend(
                        //borderColor: Colors.black,
                        textStyle: const TextStyle(color: Colors.white),
                        isVisible: true,
                        title: LegendTitle(text: 'Expense Type', textStyle: const TextStyle(color: Colors.white))),
                    series: <CircularSeries>[
                      // Render pie chart
                      PieSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
                Container(
                  // decoration: const BoxDecoration(
                  //   gradient: LinearGradient(
                  //       begin: Alignment.centerLeft,
                  //       end: Alignment.centerRight,
                  //       colors: <Color>[Colors.purple, Colors.blue]
                  //     ),
                  // ),
                  child: Column(
                    children: [
                        const Center(
                          child: Text(
                            'Expense Summary'
                            , style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataTable(
                          columns: const [
                            DataColumn(
                              label: Text('Expense Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)  ) 
                            ),
                            DataColumn(
                              label: Text('Total Expense (RM)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)  ) 
                            ),
                          ], 
                          rows: [
                            DataRow(
                              cells: [
                                const DataCell(
                                  Text(
                                    'Entertainment', 
                                    style: TextStyle(
                                      color: Colors.white, 
                                      fontSize: 15, 
                                      fontWeight: FontWeight.normal
                                      ),
                                  )
                                ),
                                DataCell(
                                  Text(sumEntertainment.toString(),
                                  style: const TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white)
                                    )
                                  ), 
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Food',
                                  style: TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))),
                                DataCell(Text(sumFood.toString(),
                                  style: const TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))), 
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Health',
                                  style:  TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))),
                                DataCell(Text(sumHealth.toString(),
                                  style: const TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))), 
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Housing',
                                  style:  TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))),
                                DataCell(Text(sumHousing.toString(),
                                  style: const TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))), 
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Personal Care',
                                  style:  TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))),
                                DataCell(Text(sumPersonal.toString(),
                                  style: const TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))), 
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Transportation',
                                  style: TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))),
                                DataCell(Text(sumTransport.toString(),
                                  style: const TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))), 
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Utilities',
                                  style:  TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))),
                                DataCell(Text(sumUtilities.toString(),
                                  style: const TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))), 
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Misc',
                                  style: TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))),
                                DataCell(Text(sumMisc.toString(),
                                  style: const TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.normal, 
                                    color: Colors.white))), 
                              ],
                            ),
                          ]
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  void calculateChartData() {
    for (final expense in expenseItems) {
      print(expense.category.title);
      if (expense.category.title == Categories.Entertainment.name) {
        sumEntertainment += expense.quantity;
      } else if (expense.category.title == Categories.Food.name) {
        sumFood += expense.quantity;
      } else if (expense.category.title == Categories.Health.name) {
        sumHealth += expense.quantity;
      } else if (expense.category.title == Categories.Housing.name) {
        sumHousing += expense.quantity;
      } else if (expense.category.title ==
          Categories.Miscellaneous.toString()) {
        sumMisc += expense.quantity;
      } else if (expense.category.title == Categories.PersonalCare.name) {
        sumPersonal += expense.quantity;
      } else if (expense.category.title == Categories.Transportation.name) {
        sumTransport += expense.quantity;
      } else if (expense.category.title == Categories.Utilities.name) {
        sumUtilities += expense.quantity;
      } else {
        print('salah');
      }
    }
    percentEntertainment = sumEntertainment /
        (sumEntertainment +
            sumFood +
            sumHealth +
            sumHousing +
            sumMisc +
            sumPersonal +
            sumTransport +
            sumUtilities);
    
    percentFood = sumFood /  (sumEntertainment +
            sumFood +
            sumHealth +
            sumHousing +
            sumMisc +
            sumPersonal +
            sumTransport +
            sumUtilities);
    
    percentHealth = sumHealth /  (sumEntertainment +
            sumFood +
            sumHealth +
            sumHousing +
            sumMisc +
            sumPersonal +
            sumTransport +
            sumUtilities);

    percentHousing = sumHousing /  (sumEntertainment +
            sumFood +
            sumHealth +
            sumHousing +
            sumMisc +
            sumPersonal +
            sumTransport +
            sumUtilities);
    
    percentMisc = sumMisc /  (sumEntertainment +
            sumFood +
            sumHealth +
            sumHousing +
            sumMisc +
            sumPersonal +
            sumTransport +
            sumUtilities);
    
    percentPersonal = sumPersonal / (sumEntertainment +
            sumFood +
            sumHealth +
            sumHousing +
            sumMisc +
            sumPersonal +
            sumTransport +
            sumUtilities);
    
    percentTransport = sumTransport /  (sumEntertainment +
            sumFood +
            sumHealth +
            sumHousing +
            sumMisc +
            sumPersonal +
            sumTransport +
            sumUtilities);
    
    percentUtilities = sumUtilities /  (sumEntertainment +
            sumFood +
            sumHealth +
            sumHousing +
            sumMisc +
            sumPersonal +
            sumTransport +
            sumUtilities);
  }
}
