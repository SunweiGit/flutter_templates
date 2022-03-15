import 'package:audioplayers/audioplayers.dart';

class AudioPlugin {
  AudioPlayer audioPlugin = AudioPlayer();

  AudioPlayer play(String url) {
    audioPlugin.play(url, isLocal: true);
    return audioPlugin;
  }

}
