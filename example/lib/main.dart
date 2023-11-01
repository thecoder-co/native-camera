import 'package:flutter/material.dart';
import 'package:native_camera/native_camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  CameraFile? pickedFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(pickedFile?.toString() ?? ''),
            ElevatedButton(
              onPressed: () {
                NativeCamera.launch(
                  context,
                  allowGallery: false,
                  cameraMode: CameraMode.both,
                ).then((value) {
                  setState(() {
                    pickedFile = value;
                  });
                });
              },
              child: const Text(
                'allowGallery: false,cameraMode: CameraMode.both,',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                NativeCamera.launch(
                  context,
                  allowGallery: false,
                  cameraMode: CameraMode.video,
                ).then((value) {
                  setState(() {
                    pickedFile = value;
                  });
                });
              },
              child: const Text(
                'allowGallery: false,cameraMode: CameraMode.video,',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                NativeCamera.launch(
                  context,
                  allowGallery: false,
                  cameraMode: CameraMode.photo,
                ).then((value) {
                  setState(() {
                    pickedFile = value;
                  });
                });
              },
              child: const Text(
                'allowGallery: false,cameraMode: CameraMode.photo,',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                NativeCamera.launch(
                  context,
                  allowGallery: true,
                  cameraMode: CameraMode.both,
                ).then((value) {
                  setState(() {
                    pickedFile = value;
                  });
                });
              },
              child: const Text(
                'allowGallery: true,cameraMode: CameraMode.both,',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                NativeCamera.launch(
                  context,
                  allowGallery: true,
                  cameraMode: CameraMode.video,
                ).then((value) {
                  setState(() {
                    pickedFile = value;
                  });
                });
              },
              child: const Text(
                'allowGallery: true,cameraMode: CameraMode.video,',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                NativeCamera.launch(
                  context,
                  allowGallery: true,
                  cameraMode: CameraMode.photo,
                ).then((value) {
                  setState(() {
                    pickedFile = value;
                  });
                });
              },
              child: const Text(
                'allowGallery: true,cameraMode: CameraMode.photo,',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
