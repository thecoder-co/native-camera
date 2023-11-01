<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Straightforward setup for the [camera](https://pub.dev/packages/camera) package, if you'd rather not deal with all the design work.

## Features

Pick image or video with hardware camera or gallery and specify options.

## Getting started

See setup for [camera](https://pub.dev/packages/camera) and [image_picker](https://pub.dev/packages/image_picker) to continue

## Usage

Import package

```dart
import 'package:native_camera/native_camera.dart';
```

```dart
final CameraFile? picked = await NativeCamera.launch(
  context,
  allowGallery: true,
  cameraMode: CameraMode.both,
);
```

## Images

![Package implementation](https://github.com/thecoder-co/native-camera/blob/main/photo_2023-11-01%2010.00.00.jpeg?raw=true)

![Package implementation](https://github.com/thecoder-co/native-camera/blob/main/photo_2023-11-01%2010.00.13.jpeg?raw=true)
