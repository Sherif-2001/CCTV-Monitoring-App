import 'package:geolocator/geolocator.dart';

class Video {
  String videoOutput;
  String videoCaptureTime;
  Position videoCaptureLocation;

  Video(
      {required this.videoOutput,
      required this.videoCaptureTime,
      required this.videoCaptureLocation});
}
