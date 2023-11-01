import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_camera/src/camera_file.dart';
import './camera_mode_enum.dart';
import './navigator.dart';
import './camera_appbar.dart';
import './sending_image_preview.dart';
import './sending_video_preview.dart';

late List<CameraDescription> cameras;

class NativeCamera extends StatefulWidget {
  static Future<CameraFile?> launch(
    BuildContext context, {
    CameraMode cameraMode = CameraMode.both,
    bool allowGallery = true,
  }) async {
    cameras = await availableCameras();
    if (!context.mounted) return null;
    final data = await pushTo(
      context,
      NativeCamera(
        allowGallery: allowGallery,
        cameraMode: cameraMode,
      ),
    );
    if (data == null) return null;

    return CameraFile(cameraMode: data.$2, file: data.$1);
  }

  final CameraMode cameraMode;
  final bool allowGallery;

  /// await for (String, bool) path and isVideo
  const NativeCamera({
    super.key,
    this.cameraMode = CameraMode.both,
    this.allowGallery = false,
  });

  @override
  State<NativeCamera> createState() => _NativeCameraState();
}

class _NativeCameraState extends State<NativeCamera> {
  late CameraController _cameraController;
  late Future<void> _cameraValue;
  bool isFlashOn = false;
  bool isCameraFront = true;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    _cameraValue = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: switch (widget.cameraMode) {
        CameraMode.both => 2,
        _ => 1,
      },
      initialIndex: switch (widget.cameraMode) {
        CameraMode.both => 1,
        _ => 0,
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CameraAppBar(
          isFlashOn: isFlashOn,
          onFlashPressed: toggleFlash,
        ),
        bottomSheet: Container(
          height: 100,
          width: MediaQuery.sizeOf(context).width,
          color: Colors.black,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TabBar(
                indicatorWeight: 3,
                dividerColor: Colors.transparent,
                tabs: [
                  if (widget.cameraMode == CameraMode.both ||
                      widget.cameraMode == CameraMode.video)
                    const Tab(
                      text: 'Video',
                    ),
                  if (widget.cameraMode == CameraMode.both ||
                      widget.cameraMode == CameraMode.photo)
                    const Tab(
                      text: 'Photo',
                    ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  FutureBuilder(
                    future: _cameraValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          width: double.infinity,
                          child: CameraPreview(_cameraController),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  Positioned(
                    bottom: 100,
                    child: SizedBox(
                      height: 150,
                      width: MediaQuery.sizeOf(context).width,
                      child: TabBarView(
                        children: [
                          if (widget.cameraMode == CameraMode.both ||
                              widget.cameraMode == CameraMode.video)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (widget.allowGallery)
                                      GestureDetector(
                                        onTap: () => takeVideoGallery(),
                                        child: const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.black38,
                                          child: Icon(
                                            Icons.photo,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    else
                                      const SizedBox(
                                        width: 60,
                                      ),
                                    GestureDetector(
                                      onTap: () => takeVideo(),
                                      onLongPress: () async {
                                        await _cameraController
                                            .startVideoRecording();
                                        setState(() {
                                          isRecording = true;
                                        });
                                      },
                                      onLongPressUp: () async {
                                        XFile videoPath =
                                            await _cameraController
                                                .stopVideoRecording();
                                        setState(() {
                                          isRecording = false;
                                        });
                                        if (!mounted) return;
                                        final shouldContinue = await pushTo(
                                          context,
                                          SendingVideoViewPage(
                                              path: videoPath.path),
                                        );
                                        if (shouldContinue == null ||
                                            !shouldContinue) {
                                          return;
                                        }
                                        if (!mounted) return;
                                        pop(context,
                                            (videoPath, CameraMode.video));
                                      },
                                      child: cameraIcon(),
                                    ),
                                    GestureDetector(
                                      onTap: toggleCameraFront,
                                      child: const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black38,
                                        child: Icon(
                                          Icons.flip_camera_ios,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (widget.cameraMode == CameraMode.both ||
                              widget.cameraMode == CameraMode.photo)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (widget.allowGallery)
                                      GestureDetector(
                                        onTap: () => takePhotoGallery(),
                                        child: const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.black38,
                                          child: Icon(
                                            Icons.photo,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    else
                                      const SizedBox(
                                        width: 60,
                                      ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (!isRecording) takePhoto(context);
                                      },
                                      child: cameraIcon(),
                                    ),
                                    GestureDetector(
                                      onTap: toggleCameraFront,
                                      child: const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black38,
                                        child: Icon(
                                          Icons.flip_camera_ios,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void takeVideoGallery() async {
    final image = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (!mounted) return;
    if (image == null) return;
    final shouldContinue = await pushTo(
      context,
      SendingVideoViewPage(path: image.path),
    );
    if (shouldContinue == null || !shouldContinue) {
      return;
    }
    if (!mounted) return;
    pop(context, (image, CameraMode.video));
  }

  void takeVideo() async {
    if (isRecording) {
      XFile videoPath = await _cameraController.stopVideoRecording();
      setState(() {
        isRecording = false;
      });
      if (!mounted) return;
      final shouldContinue = await pushTo(
        context,
        SendingVideoViewPage(path: videoPath.path),
      );
      if (shouldContinue == null || !shouldContinue) {
        return;
      }
      if (!mounted) return;
      pop(context, (videoPath, CameraMode.video));
    } else {
      await _cameraController.startVideoRecording();
      setState(() {
        isRecording = true;
      });
    }
  }

  void takePhotoGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (image == null) return;
    final shouldContinue = await pushTo(
      context,
      SendingImageViewPage(path: image.path),
    );
    if (shouldContinue == null || !shouldContinue) {
      return;
    }
    if (!mounted) return;
    pop(context, (image, CameraMode.photo));
  }

  Icon cameraIcon() {
    return isRecording
        ? const Icon(
            Icons.radio_button_on,
            color: Colors.red,
            size: 80,
          )
        : const Icon(
            Icons.panorama_fish_eye,
            size: 80,
            weight: 10,
            color: Colors.white,
          );
  }

  void toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    isFlashOn
        ? _cameraController.setFlashMode(FlashMode.torch)
        : _cameraController.setFlashMode(FlashMode.off);
  }

  void toggleCameraFront() {
    setState(() {
      isCameraFront = !isCameraFront;
    });
    int cameraPos = isCameraFront ? 0 : 1;
    _cameraController =
        CameraController(cameras[cameraPos], ResolutionPreset.high);
    _cameraValue = _cameraController.initialize();
  }

  void takePhoto(BuildContext context) async {
    XFile file = await _cameraController.takePicture();
    if (!mounted) return;
    final shouldContinue = await pushTo(
      context,
      SendingImageViewPage(path: file.path),
    );
    if (shouldContinue == null || !shouldContinue) return;
    if (!mounted) return;
    pop(context, (file, CameraMode.photo));
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }
}
