import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

ColorScheme lightThemeColors(context) {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF202020),
    onPrimary: Color(0xFF505050),
    secondary: Color(0xFFBBBBBB),
    onSecondary: Color(0xFFEAEAEA),
    error: Color(0xFFF32424),
    onError: Color(0xFFF32424),
    background: Color(0xFFF1F2F3),
    onBackground: Color(0xFFFFFFFF),
    surface: Color(0xFF54B435),
    onSurface: Color(0xFF54B435),
  );
}

ColorScheme darkThemeColors(context) {
  return ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFFF1F2F3),
    onPrimary: const Color(0xFFFFFFFF),
    secondary: const Color(0xFFBBBFFF),
    onSecondary: const Color(0xFFEAFAEF),
    error: const Color(0xFFF32424),
    onError: const Color(0xFFF32424),
    background: const Color(0xFF202020),
    onBackground: const Color(0xFF505050),
    surface: Colors.grey.shade900,
    onSurface: Colors.white,
  );
}

void main() {
  runApp(const MyApp());
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class Activity {
  final String activity;
  final String type;
  final int participants;
  final int price;
  final String link;
  final String key;
  final int access;

  Activity(this.activity, this.type, this.participants, this.price, this.link,
      this.key, this.access);

  factory Activity.fromJsonString(String jsonString) {
    var activityJson = json.decode(jsonString);
    return Activity(
        activityJson["activity"],
        activityJson["type"],
        activityJson["participants"],
        activityJson["price"],
        activityJson["link"],
        activityJson["key"],
        activityJson["accessibility"]);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Generator',
      theme: ThemeData(
          primarySwatch: Colors.grey, colorScheme: darkThemeColors(context)),
      home: const MyHomePage(title: 'Activity Generator'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> types = [
    "Education",
    "Recreational",
    "Social",
    "Diy",
    "Charity",
    "Cooking",
    "Relaxation",
    "Music",
    "Busywork"
  ];
  String type = "Education";
  double price = 0;
  int participants = 1;
  double accessibility = 0.0;
  bool expensive = false;
  bool accessible = false;

  String url = "";

  void updateURL() {
    url =
        "https://www.boredapi.com/api/activity/?type=${type.toLowerCase()}&minparticipants=${participants.toString()}&maxprice=${price.toString()}&minaccessiblity=${accessibility.toString()}";
  }

  @override
  void initState() {
    updateURL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                spacing: 10,
                children: [
                  DropdownButton<String>(
                    alignment: Alignment.center,
                    items: types.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: type,
                    onChanged: (newType) {
                      setState(() {
                        type = newType!;
                        updateURL();
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    icon: const Icon(Icons.arrow_left),
                  ),
                  DropdownButton<int>(
                    alignment: Alignment.center,
                    items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    value: participants,
                    onChanged: (newNum) {
                      setState(() {
                        participants = newNum!;
                        updateURL();
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    icon: const Icon(Icons.people),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5);
                          }
                          return Theme.of(context)
                              .colorScheme
                              .secondary; // Use the component's default.
                        },
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        expensive = !expensive;
                        if (expensive) {
                          price = 1.0;
                        } else {
                          price = 0.0;
                        }
                        updateURL();
                      });
                    },
                    child: Text(
                      (expensive) ? "Costly" : "Affordable",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5);
                          }
                          return Theme.of(context)
                              .colorScheme
                              .secondary; // Use the component's default.
                        },
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        accessible = !accessible;
                        if (accessible) {
                          accessibility = 1.0;
                        } else {
                          accessibility = 0.0;
                        }
                        updateURL();
                      });
                    },
                    child: Text(
                      (accessible) ? "Accesible" : "Less-Accessible",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const Spacer(
                flex: 1,
              ),
              Flexible(
                flex: 8,
                child: FutureBuilder(
                  future: http.get(Uri.parse(url)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.body ==
                          '{"error":"No activity found with the specified parameters"}') {
                        return Center(
                          child: Text(
                            "no activity was found with those filters 😞"
                                .toTitleCase(),
                            textAlign: TextAlign.center,
                            textScaleFactor: 3,
                          ),
                        );
                      }
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            json.decode(snapshot.data!.body)["activity"],
                            style: const TextStyle(fontSize: 48),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return const Placeholder();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
