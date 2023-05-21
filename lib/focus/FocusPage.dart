import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:is_lock_screen/is_lock_screen.dart';

import '../facts/FlashCardsPage.dart';
import '../notification_service.dart';

class FocusPage extends StatefulWidget {
  const FocusPage({Key? key}) : super(key: key);

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  Duration initalDuration = Duration();
  Duration giveUpDuration = Duration();
  Duration duration = Duration();
  double progress = 1.0;
  Timer? timer;

  bool isPlaying = false;
  bool isSleeping = false;
  bool hasGivenUp = false;
  bool isDone = false;

  String imagePath1 = "assets/images/stage1.png";
  String imagePath2 = "assets/images/stage2.png";
  String imagePath3 = "assets/images/stage3.png";
  String imagePath4 = "assets/images/stage4.png";
  String imagePath5 = "assets/images/stage5.png";

  Size buttonSize = Size(180, 70);
  Size buttonSize2 = Size(350, 70);

  late final NotificationService notificationService;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: initalDuration,
    )..addListener(() {
      setState(() {
        if (controller.isAnimating) {
          setState(() {
            progress = controller.value;
          });
        } else {
          setState(() {
            progress = 1.0;
            isPlaying = false;
          });
        }
      });
    });

    super.initState();

    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
      didChangeAppLifecycleState(WidgetsBinding.instance.lifecycleState!);
    }

    notificationService = NotificationService();
    notificationService.initializePlatformNotifications();
    super.initState();

    reset();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      final isLock = await isLockScreen();
      if(!isLock! && isPlaying){
        await notificationService.showLocalNotification(
            id: 0,
            title: "Kehre zu Bloom zurück!",
            body: "Wenn du nicht in 30 Sekunden nicht zurückkehrst, wirst du automatisch aufgeben.",
            payload: "Kehre zu Bloom zurück"
        );
        isSleeping = true;
        giveUpDuration = Duration(seconds: duration.inSeconds - 30);
      }
    } else if (state == AppLifecycleState.resumed){
      isSleeping = false;
      giveUpDuration = Duration.zero;
    }
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void reset() {
    setState(() => duration = initalDuration);
  }

  void stopTimer() {
    reset();
    setState(() => timer?.cancel());
  }

  void addTime() {
    final addSeconds = -1;

    progress = duration.inSeconds / initalDuration.inSeconds;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if(isSleeping == true && duration.inSeconds == giveUpDuration.inSeconds) {
        controller.stop();
        setState(() {
          isPlaying = false;
        });
        stopTimer();
        _showAlertDialog(context);
      }

      if (seconds < 1) {
        isDone = true;
      }

      if (seconds < 0) {
        timer?.cancel();
        _showButtomDialog(context);
        isPlaying = false;
        notificationService.showLocalNotification(
            id: 0,
            title: "Deine Blume ist gewachsen!",
            body: "Öffne Bloom um sie dir anzusehen und neue Flash Cards zu erstellen.",
            payload: "Fertig!"
        );
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    isDone = false;
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      if (isPlaying == true) {
        return false;
      }
      return true;
    },
    child: Scaffold (
      backgroundColor: Color.fromARGB(500, 0x06, 0x4e, 0x3b),

      appBar: isPlaying == false? AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5)),
          onPressed: () {
            stopTimer();
            controller.reset();
            Navigator.of(context).pop();
          }
        ),
        title: const Text(
          'Fokussieren',
          style: TextStyle(color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5)),
        ),
        backgroundColor: Color.fromARGB(550, 0x06, 0x4e, 0x3b),
      ) : AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(550, 0x06, 0x4e, 0x3b),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
           Text(
             isPlaying == false? "Wähle einen Zeitraum, in dem du dich fokussieren willst.": "Leg dein Handy weg und fokussiere dich auf das Lernen :)",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
              color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
           child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () {
                if(isPlaying == false) {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        height: 300,
                        child: CupertinoTimerPicker(
                          initialTimerDuration: duration,
                          onTimerDurationChanged: (time) {
                            setState(() {
                              initalDuration = time;
                              controller.duration = time;
                              duration = time;
                            });
                          },
                        ),
                      )
                  );
                }
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SizedBox(
                    height: 300,
                    child: Container(
                      margin: EdgeInsets.all(100.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(500, 0xfe, 0xf3, 0xc7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  //Bilder müssen vorher einmal laden
                  Padding(
                    padding: EdgeInsets.all(50),
                    child: Stack(
                      children: [
                        Image.asset(imagePath1),
                        Image.asset(imagePath2),
                        Image.asset(imagePath3),
                        Image.asset(imagePath4),
                        Image.asset(imagePath5),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(28),
                    child: isDone ? Image.asset(imagePath4)
                        : hasGivenUp == true ? Image.asset(imagePath5)
                        : progress < 0.25 ? Image.asset(imagePath4)
                        : progress < 0.50 ? Image.asset(imagePath3)
                        : progress < 0.75 ? Image.asset(imagePath2)
                        : Image.asset(imagePath1),
                  ),
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      minWidth: 260,
                      minHeight: 260,
                    ),
                    child: CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(0xff, 0x6, 0x41, 0x30),
                      color: Color.fromARGB(500, 0x34, 0xd3, 0x99),
                      value: controller.value,
                      strokeWidth: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Column(
              children: [
                buildTime(),
                const SizedBox(height: 25),
                isPlaying == false?
                ElevatedButton(
                  style: duration.inSeconds != 0 ? ElevatedButton.styleFrom(
                    minimumSize: buttonSize,
                    backgroundColor: Color.fromARGB(500, 0x10, 0xb9, 0x81),
                  ) : ElevatedButton.styleFrom(
                    minimumSize: buttonSize,
                    backgroundColor: Color.fromARGB(500, 0x78, 0x71, 0x6c),
                  ),
                  onPressed: () {
                    if(duration.inSeconds != 0) {
                      controller.reset();
                      startTimer();
                      controller.reverse(
                          from: controller.value == 0 ? 1.0 : controller.value);
                      hasGivenUp = false;
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  child: Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color:
                      duration.inSeconds == 0 ?
                        Color.fromARGB(500, 0xe7, 0xe5, 0xe4)
                        : Colors.white,
                    ),
                  ),
                ):
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: buttonSize,
                    backgroundColor: Color.fromARGB(500, 0xea, 0xb3, 0x08),
                  ),
                  onPressed: () async {
                    _showCupertinoDialog(context);
                  },
                  child: Text(
                    "Aufgeben",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          )
        ],
      ),
    ),
  );

  Widget buildTime() {
    //macht aus einstelligen Zahlen eine zweistellige: 9-->09
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return GestureDetector(
      onTap: () {
        if(isPlaying == false) {
          showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                height: 300,
                child: CupertinoTimerPicker(
                  initialTimerDuration: duration,
                  onTimerDurationChanged: (time) {
                    setState(() {
                      initalDuration = time;
                      controller.duration = time;
                      duration = time;
                    });
                  },
                ),
              )
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimeCard(time: hours, header: 'STUNDEN'),
          const SizedBox(width: 8),
          TimeCard(time: minutes, header: 'MINUTEN'),
          const SizedBox(width: 8),
          TimeCard(time: seconds, header: 'SEKUNDEN'),
        ],
      )
    );
  }
  Widget TimeCard({required String time, required String header}) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.w200,
              color: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
              fontSize: 50,
          ),
        )
      ),
      const SizedBox(height: 14),
      Text(
        header,
        style: TextStyle(
          color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
        ),
      )
    ],
  );

  void _showCupertinoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Bist du dir sicher?'),
            content: Text('Hey, gib noch nicht auf. Ich glaube dran, dass du es schaffst!'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog(context);
                  },
                  child: Text('Schließen')),
              TextButton(
                onPressed: () {
                  controller.stop();
                  setState(() {
                    isPlaying = false;
                  });
                  stopTimer();
                  _dismissDialog(context);
                  hasGivenUp = true;
                },
                child: Text('Aufgeben'),
              )
            ],
          );
        }
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Du hast aufgegeben."),
          content: const Text("Wenn du die App verlässt, während du dich fokussierst, gibst du automatisch auf. Aber keine Sorge, beim nächsten Mal schaffst du es!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _dismissDialog(context);
              },
              child: Text('Schließen')
            ),
          ],
        );
      }
    );
  }

  _dismissDialog(BuildContext context) {
    Navigator.pop(context);
  }

  void _showButtomDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        color: Color.fromARGB(500, 0xea, 0xb3, 0x08),
        child: SizedBox(
          height: 260,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                "Möchtest du neue Flash Cards erstellen?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
                  fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    FlashCardsPage.dialog = true;
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FlashCardsPage()
                      )
                    );
                  },
                  child: Text(
                    "Neue Flash Cards erstellen",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: buttonSize2,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _dismissDialog(context);
                  },
                  child: Text(
                    "Schließen",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: buttonSize2,
                  ),
                ),
              ]
            )
          )
        )
      )
    );
  }
}

