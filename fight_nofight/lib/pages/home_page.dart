import 'dart:async';
import 'dart:io';
import 'package:fight_nofight/models/video.dart';
import 'package:fight_nofight/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imagePicker = ImagePicker();
  final videoInfo = FlutterVideoInfo();
  late VideoPlayerController videoController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
  IconData videoStateIcon = Icons.pause_circle;
  bool isVideoStateVisible = false;
  bool isVideoAdded = false;
  bool isOutputVisible = true;
  final Video video = Video(
      videoOutput: "",
      videoCaptureTime: "",
      videoLocation: Position(
          longitude: 0,
          latitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0));

  void pickVideoFile(ImageSource source) async {
    // Start picking the video from the source (gallery or camera)
    final videoFile = await imagePicker.pickVideo(source: source);

    // if the no video is picked then exit the function
    if (videoFile == null) return;

    // if a video is picked, execute the below code

    // Get the info of the picked video (name,date,duration,etc...)
    var info = await videoInfo.getVideoInfo(videoFile.path);

    videoController.dispose();
    // Make the videoplayer using the picked video then start playing the video
    videoController = VideoPlayerController.file(File(videoFile.path))
      ..setLooping(true)
      ..initialize().then((_) async {
        videoController.play();
        isVideoAdded = true;
        isOutputVisible = false;
        setState(() {});
      });

    // Start a timer that show the output of the model
    // (Output, Video Capture Time, Video Capture Location) after (20 seconds)
    Timer(const Duration(seconds: 20), () async {
      video.videoOutput = info!.duration! > 60000 ? "Fight" : "No Fight";
      video.videoCaptureTime = info.date!;
      video.videoLocation = await getDeviceLocation();
      isOutputVisible = true;
      setState(() {});
    });
  }

  Future<Position> getDeviceLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void playPauseVideo() {
    // if the controller has no video in it exit the function
    if (videoController.value.isInitialized == false) return;

    // if the controller has a video play/pause on click
    if (videoController.value.isPlaying) {
      videoController.pause();
      videoStateIcon = Icons.pause_circle;
    } else {
      videoController.play();
      videoStateIcon = Icons.play_circle;
    }
    isVideoStateVisible = true;
    setState(() {});

    // Create a timer that hide the video state (play/pause) after (2 seconds)
    Timer(const Duration(seconds: 2), () {
      isVideoStateVisible = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The button at the bottom right corner
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("ADD VIDEO"),
        // On button pressed show the bottom sheet
        onPressed: () => showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          builder: (context) {
            return CustomBottomSheet(
              // On camera button pressed, pick a video from the camera
              onCameraPressed: () {
                pickVideoFile(ImageSource.camera);
                Navigator.pop(context);
              },
              // On gallery button pressed, pick a video from the gallery
              onGalleryPressed: () {
                pickVideoFile(ImageSource.gallery);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      // The app bar at the top of the screen
      appBar: AppBar(title: const Text("Video Fight Check"), centerTitle: true),
      // The body of the app
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Visibility(
                      visible: isVideoAdded,
                      // The part of waiting to add the video
                      replacement: Container(
                        color: Colors.grey.shade600,
                        child: const Center(
                          child: Text(
                            "INSERT VIDEO",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                      // The part of the video player
                      child: GestureDetector(
                        onTap: () => playPauseVideo(),
                        child: Container(
                          color: Colors.grey,
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: videoController.value.aspectRatio,
                              child: VideoPlayer(videoController),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Show the state of the video (play/pause)
                    Visibility(
                      visible: isVideoStateVisible,
                      child: Container(
                        color: Colors.grey.withOpacity(0.7),
                        child: Center(child: Icon(videoStateIcon, size: 80)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    borderRadius: BorderRadius.circular(20)),
                child: Visibility(
                  visible: isOutputVisible,
                  // The loading part waiting for the output of the model
                  replacement: const Center(child: CircularProgressIndicator()),
                  // The part that show the output of the model
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // The output of the model (Fight / No Fight)
                      ListTile(
                        leading: const Icon(Icons.output),
                        title: const Text("Output"),
                        subtitle: Text(video.videoOutput),
                      ),
                      // The capture time of the video
                      ListTile(
                        leading: const Icon(Icons.timer),
                        title: const Text("Capture Time"),
                        subtitle: Text(video.videoCaptureTime),
                      ),
                      // The capture location of the video
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text("Capture Location"),
                        subtitle: Text(
                            "Latitude: ${video.videoLocation.latitude}\nLongitude: ${video.videoLocation.longitude}"),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
