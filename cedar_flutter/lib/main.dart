import 'dart:developer';
//import 'dart:ffi';
import 'dart:typed_data';
import 'package:fixnum/src/int64.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as dart_widgets;
import 'cedar.pbgrpc.dart';
import 'google/protobuf/duration.pb.dart';
import 'get_cedar_client_for_web.dart'
    if (dart.library.io) 'get_cedar_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cedar',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cedar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

double durationToMs(Duration duration) {
  return duration.seconds.toDouble() * 1000 +
      (duration.nanos.toDouble()) / 1000000;
}

Duration msToDuration(int ms) {
  var duration = Duration();
  duration.seconds = Int64(ms ~/ 1000);
  duration.nanos = (ms * 1000000) % 1000000000;
  return duration;
}

// The various exposure times (ms) selected by the exposure time slider.
// TODO: build from the min/max exposure times in the CalibrationData.
var expValuesMs = [10, 20, 50, 100, 200, 500, 1000];

// Return the largest index in expValuesMs array that is <= the given value.
// If the given value is too small returns 0.
int expValueIndex(double value) {
  if (value <= expValuesMs[0]) {
    return 0;
  }
  int index = 0;
  while (++index < expValuesMs.length) {
    if (expValuesMs[index] > value) {
      return index - 1;
    }
  }
  return expValuesMs.length - 1;
}

class _MyHomePageState extends State<MyHomePage> {
  // Information from most recent FrameResult.
  Uint8List imageBytes = Uint8List(1);
  int width = 0;
  int height = 0;

  int centerPeakWidth = 0;
  int centerPeakHeight = 0;
  Uint8List centerPeakImageBytes = Uint8List(1);

  int prevFrameId = -1;
  int numStarCandidates = 0;
  int numBinnedStarCandidates = 0;
  int numHotPixels = 0;
  double exposureTimeMs = 0.0;

  // Values set from on-screen controls.
  bool doRefreshes = false;
  bool expAuto = true;
  int expSliderValue = 0;

  Future<void> getFocusFrameFromServer() async {
    final CedarClient client = getClient();

    final request = FrameRequest()
      ..prevFrameId = prevFrameId
      ..mainImageMode = ImageMode.IMAGE_MODE_BINNED;
    try {
      final response = await client.getFrame(request);
      setState(() {
        // TODO(smr): check response.operatingMode and extract information
        // accordingly. Also render widgets according to the operatingMode.
        prevFrameId = response.frameId;
        numStarCandidates = response.starCandidates.length;
        numBinnedStarCandidates = response.binnedStarCandidateCount;
        numHotPixels = response.hotPixelCount;
        if (response.hasImage()) {
          imageBytes = Uint8List.fromList(response.image.imageData);
          width = response.image.rectangle.width;
          height = response.image.rectangle.height;
        }
        if (response.hasExposureTime()) {
          exposureTimeMs = durationToMs(response.exposureTime);
        }
        expAuto = durationToMs(response.operationSettings.exposureTime) == 0.0;
        centerPeakImageBytes =
            Uint8List.fromList(response.centerPeakImage.imageData);
        centerPeakWidth = response.centerPeakImage.rectangle.width;
        centerPeakHeight = response.centerPeakImage.rectangle.height;
      });
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> refreshStateFromServer() async {
    await Future.doWhile(() async {
      await getFocusFrameFromServer();
      return doRefreshes;
    });
  }

  Future<void> updateOperationSettings(OperationSettings request) async {
    final CedarClient client = getClient();
    try {
      await client.updateOperationSettings(request);
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> setExpTimeFromSlider() async {
    var request = OperationSettings();
    request.exposureTime = msToDuration(expValuesMs[expSliderValue]);
    await updateOperationSettings(request);
  }

  Widget runSwitch() {
    return Switch(
        value: doRefreshes,
        onChanged: (bool value) {
          setState(() {
            doRefreshes = value;
            if (doRefreshes) {
              refreshStateFromServer();
            }
          });
        }); // Switch
  }

  Widget expControl() {
    return Column(children: <Widget>[
      expAuto
          ? const SizedBox(height: 48)
          : Slider(
              min: 0,
              max: expValuesMs.length - 1,
              divisions: expValuesMs.length - 1,
              value: expValueIndex(exposureTimeMs).toDouble(),
              onChanged: (double value) => {
                    setState(() {
                      expSliderValue = value.toInt();
                      if (!expAuto) {
                        setExpTimeFromSlider();
                      }
                    })
                  }),
      Row(
        children: <Widget>[
          Switch(
              value: expAuto,
              onChanged: (bool value) => {
                    setState(() {
                      expAuto = value;
                      if (expAuto) {
                        var request = OperationSettings();
                        request.exposureTime = msToDuration(0);
                        updateOperationSettings(request);
                      } else {
                        setExpTimeFromSlider();
                      }
                    })
                  }),
          const Text("Auto"),
        ],
      ),
      Text("$exposureTimeMs"),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState() is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    runSwitch(),
                    const Text("Run"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("$numStarCandidates"),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text("Stars"),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("$numBinnedStarCandidates"),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text("Binned stars"),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("$numHotPixels"),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text("Hot pixels"),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    expControl(),
                    const Text("Exp time (ms)"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 2),
            Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                prevFrameId != -1
                    ? dart_widgets.Image.memory(imageBytes,
                        height: height.toDouble() / 2,
                        width: width.toDouble() / 2,
                        fit: BoxFit.fill,
                        gaplessPlayback: true)
                    : const SizedBox(height: 2),
                prevFrameId != -1
                    ? dart_widgets.Image.memory(centerPeakImageBytes,
                        height: centerPeakHeight.toDouble() * 3,
                        width: centerPeakWidth.toDouble() * 3,
                        fit: BoxFit.fill,
                        gaplessPlayback: true)
                    : const SizedBox(height: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
