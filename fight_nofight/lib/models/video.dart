import 'package:geolocator/geolocator.dart';

class Video {
  String videoOutput;
  String videoCaptureTime;
  Position videoLocation;

  Video(
      {required this.videoOutput,
      required this.videoCaptureTime,
      required this.videoLocation});
}
