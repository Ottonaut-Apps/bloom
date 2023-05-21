import 'package:flutter/material.dart';
import 'package:wpm/selector/Settings.dart';

import '../facts/FlashCardsPage.dart';
import '../focus/FocusPage.dart';
import '../statistic/StatisticPage.dart';

/*
* Die Homepage
*
* Der Nutzer öffnet zu allererst diese Seite und kommt somit zu einer Auswahl
* an Aktionen, die dieser ausführen kann.
*
* Diese Aktionen sind:
*   - Fokussieren
*   - Lernsammlung
*   - Statistiken
*
* Sie leiten jeweils auf eine der Appanwendungen weiter.
*
 */

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(550, 0x06, 0x4e, 0x3b), useMaterial3: true),
      home: Scaffold(
        backgroundColor: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
        appBar: AppBar(
          title: RichText (
            text: TextSpan (
              text: 'Bloom 🌼',
              style: TextStyle(
                color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                fontSize: 25,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()
                    )
                );
              },
              icon: Icon(Icons.settings, color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5))
            ),
          ],
          backgroundColor: Color.fromARGB(550, 0x06, 0x4e, 0x3b),
        ),
        body: Column(
          children: <Widget>[
            const Spacer(flex: 1),
            Text(
              "Willkommen bei Bloom 🌼.\n Fokussiere dich und lerne ohne Ablenkung.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
              ),
            ),
            const Spacer(flex: 1),
            FilledCard(1, "Fokussieren"),
            FilledCard(2, "Flash Cards"),
            FilledCard(3, "Meine Statisik"),
            const Spacer(flex: 3,),
          ],
        ),
      ),
    );
  }
}

class FilledCard extends StatefulWidget {
  int id = 0;
  String name = "null";

  FilledCard(this.id, String title, {super.key}) {
    name = title;
  }

  @override
  State<FilledCard> createState() => _FilledCardState(id, name);
}

class _FilledCardState extends State<FilledCard> {
  late String name;
  late int id;

  _FilledCardState(this.id, String title) {
    name = title;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          elevation: 0,
          color: const Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
          child: InkWell(
            splashColor: Colors.green.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                 MaterialPageRoute(builder: (context) => id == 1?
                 FocusPage()
                  : id == 2? FlashCardsPage()
                     : StatisticPage()
                 )
              );
            },
            child: SizedBox(
              width: 300,
              height: 100,
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                          child: Icon(
                            id == 1? Icons.mobile_off
                            : id == 2? Icons.library_books_outlined
                            : Icons.bar_chart,
                            color: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
                            size: 20,
                          )
                      ),
                      TextSpan(
                        text: " " + name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
                        )
                      )
                    ]
                  )
                )
              ),
            ),
          )
      ),
    );
  }
}
