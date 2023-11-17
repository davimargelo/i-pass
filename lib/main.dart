import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: MediaQuery.platformBrightnessOf(context),
      seedColor: Colors.pink[50]!,
    );

    return MaterialApp(
      title: 'Test Average Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.tertiary,
          foregroundColor: colorScheme.onTertiary,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController scoreController1 = TextEditingController();
  TextEditingController scoreController2 = TextEditingController();
  TextEditingController substituteTestController = TextEditingController();
  double average1 = 0.0;
  double average2 = 0.0;
  double averageMeta = 7.0;

  String errorText1 = '';
  String errorText2 = '';
  String substituteTestErrorText = '';

  void validateInputs() {
    double score1 = double.tryParse(scoreController1.text) ?? -1.0;
    double score2 = double.tryParse(scoreController2.text) ?? -1.0;
    double substituteTestScore =
        double.tryParse(substituteTestController.text) ?? -1.0;

    setState(() {
      errorText1 = (score1 < 0 || score1 > 10)
          ? 'Enter a valid score between 0 and 10'
          : '';
      errorText2 = (score2 < 0 || score2 > 10)
          ? 'Enter a valid score between 0 and 10'
          : '';
      substituteTestErrorText =
          (substituteTestScore < 0 || substituteTestScore > 10)
              ? 'Enter a valid score between 0 and 10'
              : '';

      if (errorText1.isEmpty && errorText2.isEmpty) {
        calculateAverage1();
      } else {
        // Set averages to 0.0 when there's an invalid input
        average1 = 0.0;
        average2 = 0.0;
      }

      if (substituteTestErrorText.isEmpty) {
        calculateAverage2();
      } else {
        average2 = 0.0;
      }
    });
  }

  void calculateAverage1() {
    double score1 = double.tryParse(scoreController1.text) ?? 0.0;
    double score2 = double.tryParse(scoreController2.text) ?? 0.0;
    setState(() {
      average1 = (score1 + score2) / 2;
    });
  }

  void calculateAverage2() {
    double substituteTest =
        double.tryParse(substituteTestController.text) ?? 0.0;
    setState(() {
      average2 = (average1 + substituteTest) / 2;
    });
  }

  Color getAverage1TextColor() {
    return average1 < averageMeta ? Colors.red : Colors.blue;
  }

  Color getAverage2TextColor() {
    return average2 < averageMeta ? Colors.red : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de médias de prova'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 85,
              child: TextField(
                controller: scoreController1,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Nota na primeira prova (0-10)',
                  errorText: errorText1.isNotEmpty ? errorText1 : null,
                ),
                onChanged: (value) {
                  validateInputs();
                },
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 85,
              child: TextField(
                controller: scoreController2,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Nota na segunda prova (0-10)',
                  errorText: errorText2.isNotEmpty ? errorText2 : null,
                ),
                onChanged: (value) {
                  validateInputs();
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Média: ',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      average1 > 0.0 ? average1.toStringAsFixed(2) : '',
                      style: TextStyle(
                        fontSize: 18,
                        color: average1 > 0.0
                            ? getAverage1TextColor()
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (average1 > 0.0 && average1 < averageMeta) ...[
              const SizedBox(height: 16),
              Container(
                height: 85,
                child: TextField(
                  controller: substituteTestController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Nota da prova substitutiva (0-10)',
                    errorText: substituteTestErrorText.isNotEmpty
                        ? substituteTestErrorText
                        : null,
                  ),
                  onChanged: (value) {
                    validateInputs();
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'Média final: ',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        substituteTestController.text != '' && average2 > 0.0
                            ? average2.toStringAsFixed(2)
                            : '',
                        style: TextStyle(
                          fontSize: 18,
                          color: average2 > 0.0
                              ? getAverage2TextColor()
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
