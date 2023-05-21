import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wpm/notification_service.dart';
import 'package:wpm/selector/SettingsStore.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  var focus = false;
  var card = false;

  late final NotificationService notificationService;
  SettingsStore settingsStore = SettingsStore();

  @override
  void initState() {
    notificationService = NotificationService();
    //notificationService.initializePlatformNotifications();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        setBool();
      });
    });


    super.initState();
  }

  Future<void> setBool() async {
    focus = await settingsStore.readFocus() as bool;
    card = await settingsStore.readCard() as bool;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorSchemeSeed: const Color.fromARGB(550, 0x06, 0x4e, 0x3b), useMaterial3: true),
      home: Scaffold(
          backgroundColor: Color.fromARGB(500, 0x06, 0x4e, 0x3b),
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5)),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            title: RichText (
              text: TextSpan (
                text: 'Einstellungen',
                style: TextStyle(
                  color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                  fontSize: 25,
                ),
              ),
            ),
            backgroundColor: Color.fromARGB(550, 0x06, 0x4e, 0x3b),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                  "Benachrichtigungen",
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
              Text(
                "Möchtest du täglich um diese Uhrzeit daran erinnert werden dich "
                    "zu fokussieren oder Flash Cards zu erstellen?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SwitchListTile(
                title: const Text(
                  'Fokussieren',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                  ),
                ),
                activeColor: Color.fromARGB(500, 0xea, 0xb3, 0x08),
                value: focus,
                onChanged: (bool value) async {
                  setState(() {
                    focus = value;
                    settingsStore.writeJson("focus", focus);
                    settingsStore.readJson();
                  });
                  if (focus == true) {
                    await notificationService.showPeriodicLocalNotification(
                      id: 1,
                      title: "Es ist Zeit sich wieder zu Fokussieren",
                      body: "Gehe auf Bloom 🌼, um dich zu fokussieren.",
                      payload: "Schreibe neue Flash Cards!",
                    );
                  } else {
                    notificationService.cancelSingleNotifications();
                  }
                },
                secondary: const Icon(Icons.mobile_off, color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5)),
              ),
              SwitchListTile(
                title: const Text(
                  'Flash Cards',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5),
                  ),
                ),
                activeColor: Color.fromARGB(500, 0xea, 0xb3, 0x08),
                value: card,
                onChanged: (bool value) async {
                  setState(() {
                    card = value;
                    settingsStore.writeJson("cards", card);
                    settingsStore.readJson();
                  });
                  if (card == true) {
                    await notificationService.showPeriodicLocalNotification(
                      id: 1,
                      title: "Schreibe neue Flash Cards",
                      body: "Gehe auf Bloom 🌼, um dir neue Flash Cards für heute zu erstellen.",
                      payload: "Schreibe neue Flash Cards!",
                    );
                  } else {
                    notificationService.cancelSingleNotifications();
                  }
                },
                secondary: const Icon(Icons.library_books_outlined, color: Color.fromARGB(500, 0xd1, 0xfa, 0xe5)),
              ),
            ],
          )
      ),
    );
  }
}

