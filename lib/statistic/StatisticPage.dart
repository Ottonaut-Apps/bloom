import 'package:flutter/material.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> with TickerProviderStateMixin {
  int focusTimes = 201;
  double progress = 0.0;
  String hours = "20";
  String minutes = "10";
  String giveUp = "2";
  double cardsPerDay = 4.2;
  int cards = 12;

  late AnimationController controller1;

  @override
  void initState() {
    controller1 = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    controller1.repeat();

    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5)),
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        title: const Text(
          'Statistik',
          style: TextStyle(
            color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5)
          ),
        ),
        backgroundColor: Color.fromARGB(550, 0x06, 0x4e, 0x3b),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
              "Hier findest du deine Statistiken zu deinem Lernfortschritt.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                  fontSize: 15,
                  fontWeight: FontWeight.w300
              )
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Fokussieren",
            style: TextStyle(
              color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              ConstrainedBox(
                constraints: new BoxConstraints(
                  minWidth: 120,
                  minHeight: 120,
                ),
                child:
                TweenAnimationBuilder(
                  /// [AnimationController]s can be created with `vsync: this` because of
                  /// [TickerProviderStateMixin].
                  tween: Tween<double>(begin: 0.0, end: 1),
                  duration: const Duration(milliseconds: 1600),
                  builder: (context, value, _) {
                    progress = value;
                    return CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(0xff, 0x6, 0x41, 0x30),
                      color: Color.fromARGB(500, 0x34, 0xd3, 0x99),
                      value: value,

                      strokeWidth: 10,
                    );
                  }
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text(
                        (progress * focusTimes).toStringAsFixed(0),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
                          fontSize: 25,
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Du warst schon " + focusTimes.toString() + " mal fokussiert.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                    fontSize: 15,
                    fontWeight: FontWeight.w300
                  )
                ),
                Text(
                  "Das waren insgesamt " + hours + " Stunden und " + minutes + " Minuten.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                      fontSize: 15,
                      fontWeight: FontWeight.w300
                  )
                ),
                Text(
                    "Dabei hast du " + giveUp + " aufgegeben.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                        fontSize: 15,
                        fontWeight: FontWeight.w300
                    )
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
              "Flash Cards",
              style: TextStyle(
                color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              )
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              ConstrainedBox(
                constraints: new BoxConstraints(
                  minWidth: 120,
                  minHeight: 120,
                ),
                child:
                TweenAnimationBuilder(
                  /// [AnimationController]s can be created with `vsync: this` because of
                  /// [TickerProviderStateMixin].
                    tween: Tween<double>(begin: 0.0, end: 1),
                    duration: const Duration(milliseconds: 1600),
                    builder: (context, value, _) {
                      progress = value;
                      return CircularProgressIndicator(
                        backgroundColor: Color.fromARGB(0xff, 0x6, 0x41, 0x30),
                        color: Color.fromARGB(500, 0x34, 0xd3, 0x99),
                        value: value,

                        strokeWidth: 10,
                      );
                    }
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text(
                        (progress * cards).toStringAsFixed(0),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
                          fontSize: 25,
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Du erstellst durchschnittlich " + cardsPerDay.toString() + " Flash Cards pro Tag.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                      fontSize: 15,
                      fontWeight: FontWeight.w300
                  )
                ),
                Text(
                  "Insgesamt hast du " + cards.toString() + " Flash Cards erstellt.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                      fontSize: 15,
                      fontWeight: FontWeight.w300
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
