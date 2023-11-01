// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:camera/camera.dart';

import './camera_mode_enum.dart';

class CameraFile {
  final CameraMode cameraMode;
  final XFile file;

  CameraFile({
    required this.cameraMode,
    required this.file,
  });

  @override
  String toString() => 'CameraFile(cameraMode: $cameraMode, file: $file)';
}
