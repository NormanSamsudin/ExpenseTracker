import 'package:expense_project/widget/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {

  const StartScreen({super.key});

  @override
  Widget build(context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white
      ),
          //       decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.centerLeft,
          //       end: Alignment.centerRight,
          //       colors: <Color>[Colors.purple, Colors.blue]
          //     ),
          // ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/assets/images/Logo.png',
              width: 300,
              // color:
              //     const Color.fromARGB(168, 255, 255, 255), //overlay color to the image
            ),
    
    
            const SizedBox(height: 80), // nak bagi ada jarak jer
            DefaultTextStyle(
              style: const TextStyle(),
              child: Text(
                'Welcome to SmartXpends',
                
                style: GoogleFonts.lato(
                  color: Color.fromARGB(255, 116, 30, 153),
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
                
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            OutlinedButton.icon(
                   onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpenseList()
                   )),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 116, 30, 153),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.arrow_right_alt),
              label: const Text('Start App'),
            )
          ],
        ),
      ),
    );
  }
}
