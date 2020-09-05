import 'dart:io';

import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pustackv1/image_detail.dart';
import 'package:pustackv1/subscription.dart';
import 'package:pustackv1/ui/search_screen.dart';
import 'package:path/path.dart' show join;
import 'package:pustackv1/ui/widgets/appbar.dart';

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class CameraExampleHome extends StatefulWidget {
  @override
  _CameraExampleHomeState createState() => _CameraExampleHomeState();
}

class _CameraExampleHomeState extends State<CameraExampleHome>
    with WidgetsBindingObserver {
  CameraController controller;
  String imagePath;
  FlashMode flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0.0,

        // ),
        body: Stack(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Container(
        //     height: 200,
        //     width: MediaQuery.of(context).size.width,
        //     child: _cameraPreviewWidget()),

        _cameraTogglesRowWidget(),

        Container(child: _cameraPreviewWidget()),
        Container(
            padding: EdgeInsets.symmetric(vertical: 50), child: brandName()),

        // Container(
        //   child: Text("hey"),
        //   color: Colors.red,
        // )

        _captureControlRowWidget(),
      ],
    ));
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    } else {
      return Container(
        // aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  /// Display the control bar with buttons to take pictures and flash light

  Widget _captureControlRowWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: GestureDetector(
              onTap: () {
                getImage(ImageSource.gallery);
              },
              child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Icon(
                    Icons.perm_media,
                    color: Colors.white,
                    size: 40,
                  )),
            ),
          ),
          //Galley Icon

          Container(
            padding: EdgeInsets.only(
              left: 40.0,
            ),
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.redAccent, shape: BoxShape.circle),
              ),
              onTap: () {
                print("click camera");
                onTakePictureButtonPressed();
              },
            ),
          ),

          // SEARCH PAGE ICO
          Container(
            padding: const EdgeInsets.only(left: 50),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(body: SearchScreen()),
                    ));
              },
              child: Container(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.text_fields,
                    color: Colors.white,
                    size: 40,
                  )),
            ),
          ),

          Container(
            // padding: EdgeInsets.only(bottom: 30.0, left: 30),
            child: Container(
                alignment: Alignment.bottomRight, child: _flashButton()),
          ),

          // END SEARCH PAGE ICON
        ]),
      );
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filepath) {
      if (mounted) {
        setState(() {
          imagePath = filepath;
        });
        if (filepath != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(imagePath),
            ),
          );
        }
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      print("Select a camera first");
      return null;
    }

    final filePath =
        join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      print("Camera Exception occurs");
      return null;
    }
    return filePath;
  }

  void getImage(ImageSource source) async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(image.path),
        ),
      );
    }
  }

  Widget _flashButton() {
    IconData iconData = Icons.flash_off;
    Color color = Colors.white;

    if (flashMode == FlashMode.alwaysFlash) {
      iconData = Icons.flash_on;
      color = Colors.blue;
    } else if (flashMode == FlashMode.autoFlash) {
      iconData = Icons.flash_auto;
      color = Colors.red;
    }
    return IconButton(
      icon: Icon(
        iconData,
        size: 30,
      ),
      color: color,
      onPressed: controller != null && controller.value.isInitialized
          ? _onFlashButtonPressed
          : null,
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else if (controller == null || !controller.value.isInitialized) {
      for (CameraDescription cameraDescription in cameras) {
        return Container(
          width: 1000,
          height: 1000,
          child: Center(
              child: IconButton(
            icon: Icon(
              Icons.camera_enhance,
              color: Colors.black,
              size: 50,
            ),
            onPressed: () {
              onNewCameraSelected(cameraDescription);
            },
          )),
        );
      }
    }
    return Container();

    // return Row(mainAxisAlignment: MainAxisAlignment.center, children: toggles);
  }

  /// Toggle Flash
  Future<void> _onFlashButtonPressed() async {
    bool hasFlash = false;
    if (flashMode == FlashMode.off || flashMode == FlashMode.torch) {
      // Turn on the flash for capture
      flashMode = FlashMode.alwaysFlash;
    } else if (flashMode == FlashMode.alwaysFlash) {
      // Turn on the flash for capture if needed
      flashMode = FlashMode.autoFlash;
    } else {
      // Turn off the flash
      flashMode = FlashMode.off;
    }
    // Apply the new mode
    await controller.setFlashMode(flashMode);

    // Change UI State
    setState(() {});
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    print("!!!!! camera selected");
    if (controller != null) {
      print("Not Null");
      await controller.dispose();
    }

    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    print("Controller is $controller");

    // If the controller is updated then update the UI.

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        print("!!!!!camera Error!");
      }
    });

    try {
      await controller.initialize();
    } on Exception catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }
}

List<CameraDescription> cameras = [];

Future<void> main() async {
  // Fetch the available cameras before initializing the app.

  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }

  runApp(CameraApp());
}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SubcriptionPage(),
    );
  }
}
