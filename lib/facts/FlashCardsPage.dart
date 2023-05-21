import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flip_card/flip_card.dart';
import 'package:wpm/facts/AllFlashCards.dart';
import 'package:wpm/selector/Home.dart';

class FlashCardsPage extends StatefulWidget {
  static bool dialog = false;
  const FlashCardsPage({Key? key}) : super(key: key);

  @override
  State<FlashCardsPage> createState() => _FlashCardsPageState();
}

class _FlashCardsPageState extends State<FlashCardsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Size buttonSize = Size(350, 70);

  bool dialog = FlashCardsPage.dialog;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => _showButtomDialog(context));
    return Scaffold(
        backgroundColor: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5)),
              onPressed: () {
                FlashCardsPage.dialog = false;
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(500, 0xea, 0xb3, 0x08),
          onPressed: () {
            dialog = true;
            _showButtomDialog(context);
          },
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
            size: 30,
          ),
        ),
        body: Column(
          children: [
            Card(
              color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
              child: TableCalendar(
                firstDay: DateTime.utc(2023, 01, 01),
                //man kann keine Flashcards für die Zukunft erstellen, daher ist
                //der last day immer der heutige Tag
                lastDay: DateTime.now(),
                focusedDay: DateTime.now(),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  // Use `selectedDayPredicate` to determine which day is currently selected.
                  // If this returns true, then `day` will be marked as selected.

                  // Using `isSameDay` is recommended to disregard
                  // the time-part of compared DateTime objects.
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: buttonSize,
                  backgroundColor: Color.fromARGB(500, 0xea, 0xb3, 0x08),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllFlashCards()
                      )
                  );
                },
                child: Text(
                  'Alle anzeigen',
                  style: TextStyle(
                    color: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )
            ),
            SizedBox(height: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlashCard("Halli", "Hallo"),
              ],
            ),
          ],
        )
    );
  }

  void _showButtomDialog(BuildContext context) {
    if(dialog == true) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () async {
              dialog = false;
              return true;
            },
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                color: Color.fromARGB(500, 0xea, 0xb3, 0x08),
                child: SizedBox(
                    height: 400,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Gib einen Text für 'Frage' und 'Antwort' ein, um eine Karte zu erstellen.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Frage",
                              labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                          Spacer(),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Antwort",
                              labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              FlashCardsPage.dialog = false;
                              dialog = false;
                            },
                            child: Text(
                              "Fertig",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: buttonSize,
                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              _dismissDialog(context);
                              dialog = false;
                            },
                            child: Text(
                              "Schließen",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(350, 40),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            )
          )
      );
    }
  }

  _dismissDialog(BuildContext context) {
    Navigator.pop(context);
  }
}

class FlashCard extends StatefulWidget {
  String question = "null";
  String answer = "null";

  FlashCard(String question, String answer) {
    this.question = question;
    this.answer = answer;
  }

  @override
  State<FlashCard> createState() => _FlashCardState(question, answer);
}

class _FlashCardState extends State<FlashCard> {
  late String question;
  late String answer;

  _FlashCardState(String question, String answer) {
    this.question = question;
    this.answer = answer;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 250,
      child: FlipCard(
        front: Card(
          elevation: 4,
          color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
          child: Center(
            child: Text(question),
          ),
        ),
        back: Card(
          elevation: 4,
          color: Color.fromARGB(500, 0xea, 0xb3, 0x08),
          child: Center(
            child: Text(answer),
          ),
        ),
      )
    );
  }
}
