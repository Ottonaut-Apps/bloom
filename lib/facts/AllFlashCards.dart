import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flip_card/flip_card.dart';
import 'package:wpm/selector/Home.dart';

import 'FlashCardsPage.dart';

class AllFlashCards extends StatefulWidget {
  static bool dialog = false;
  const AllFlashCards({Key? key}) : super(key: key);

  @override
  State<AllFlashCards> createState() => _AllFlashCardsState();
}

class _AllFlashCardsState extends State<AllFlashCards> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Size buttonSize = Size(350, 70);

  bool dialog = FlashCardsPage.dialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5)),
              onPressed: () {
                FlashCardsPage.dialog = false;
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FlashCardsPage()
                    )
                );
              }
          ),
          title: const Text(
            'Flash Cards',
            style: TextStyle(color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5)
            ),
          ),
          backgroundColor: Color.fromARGB(550, 0x06, 0x4e, 0x3b),
        ),
        body: Column(
          children: [
            SizedBox(height: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlashCard("Halli", "Hallo"),
              ],
            )
          ],
        )
    );
  }
}

