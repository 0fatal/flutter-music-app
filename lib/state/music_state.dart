import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:music_app/data/music_data.dart';
import 'package:music_app/model/lyric.dart';
import 'package:music_app/model/song.dart';

List<Music>? homeMusicList;
Music? currentMusic;
List<Music>? currentMusicList;
int currentMusicIndex = 0;

bool lockRateChange = false;


bool _isPlaying = false;
ValueNotifier<double> currentRate = ValueNotifier(0.0);
ValueNotifier<int> currentLine = ValueNotifier(0);
AudioPlayer _audioPlayer = AudioPlayer();

void init() {
  _audioPlayer.onAudioPositionChanged.listen((Duration d) async {
    // print(currentRate.value);
    if(currentMusic== null) return;
    var val = d.inMilliseconds / await _audioPlayer.getDuration();
    if(currentMusic?.lyric!.raw != '') {
      currentLine.value = currentMusic!.lyric!.findLyricIndex(d.inMilliseconds);
    }
    print(currentLine.value);
    if (lockRateChange) return;
    currentRate.value = val.compareTo(1.0) >= 0 ? 1.0 : val;
  });
}

Future<void> initHomeMusicList() async {
  homeMusicList = await SongApi.getNewSongPersonalized();
}


Future<void> loadCurrentMusic(int id,{ List<Music>? curList  })async {
  currentMusicList = curList ?? homeMusicList;
  currentMusic = (await SongApi.getSongsDetail([id.toString()]))[0];
  currentMusic!.lyric = Lyric(await SongApi.getLyric(currentMusic!.id) ?? '');
  currentLine.value = -1;
  currentMusicIndex = currentMusicList!.indexWhere((e) => e.id == id);
}

bool isPlaying() {
  return _isPlaying;
}

Future<void> play() async {
  var res = await _audioPlayer.play('https://music.163.com/song/media/outer/url?id=${currentMusic!.id}',stayAwake:true);
  if (res == 1) {
    _isPlaying = true;
  }
}

Future<void> changeProcess(double rate) async {
  var len = await _audioPlayer.getDuration();
  int newPos = (len * rate).toInt();
  _audioPlayer.seek(Duration(milliseconds: newPos));
}

Future<void> next() async {
  if (currentMusicIndex + 1 >= 0 && currentMusicIndex + 1 < currentMusicList!.length) {
    currentMusicIndex++;
    await loadCurrentMusic(currentMusicList![currentMusicIndex].id);
    await play();
  }
}

Future<void> prev() async {
  if (currentMusicIndex - 1 >= 0 && currentMusicIndex - 1 < currentMusicList!.length) {
    currentMusicIndex--;
    await loadCurrentMusic(currentMusicList![currentMusicIndex].id);
    await play();
  }
}


Future<void> stop()async {
  var res = await _audioPlayer.stop();
  if (res == 1) {
    _isPlaying = false;
  }
}

Future<void> pause() async {
  var res = await _audioPlayer.pause();
  if (res == 1) {
    _isPlaying = false;
  }
}
