import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences? pref = await SharedPreferences.getInstance();
  runApp(MainApp(
    pref: pref,
  ));
}

const String numberKey = "myNumber";

class MainApp extends StatefulWidget {
  final SharedPreferences pref;
  const MainApp({
    super.key,
    required this.pref,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController textEditingController = TextEditingController();

  String numberResultStr = " - ";

  Future<void> storeNumber(int number) async {
    await widget.pref.setInt(numberKey, number);
  }

  Future<int?> readNumber() async {
    return widget.pref.getInt(numberKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: textEditingController,
                ),
              ),
              gapH32,
              ElevatedButton(
                onPressed: () async {
                  // Text auslesen vom UI (eine Zahleneingabe des Nutzers)
                  int number = int.parse(textEditingController.text);
                  // Speichern in SharedPrefs
                  await storeNumber(number);
                },
                child: const Text("Zahl in SharedPrefs speichern"),
              ),
              gapH32,
              ElevatedButton(
                onPressed: () async {
                  // Auslesen aus SharedPrefs und in `numberFromStorage` speichern
                  final int? numberFromStorage = await readNumber();

                  // den ausgelesenen Wert im UI anzeigen
                  setState(() {
                    // Gib Zahl aus, falls sie nicht 0 ist
                    // falls sie null ist, gib aus, dass keine gefunden wurde
                    numberResultStr = numberFromStorage?.toString() ??
                        "Konnte keine Zahl finden";
                  });
                },
                child: const Text("Zahl aus SharedPrefs auslesen"),
              ),
              gapH32,
              Text(numberResultStr),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

const gapH32 = SizedBox(
  height: 32,
);
