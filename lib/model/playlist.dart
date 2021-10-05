import 'package:music_app/model/song.dart';

class Playlist {
  late int id;
  late String name;
  late String picUrl;
  late int playCount;
  late int trackCount;
  late bool highQuality;
  late List<Music> songs;

  Playlist({
    this.id = 0,
    this.name = '',
    this.picUrl = '',
    this.playCount = 0,
    this.highQuality = false,
    this.trackCount = 0,
    this.songs = const [],
  });

  factory Playlist.fromJson(Map<String,dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      picUrl: json['picUrl'] ?? json['coverImgUrl'],
      playCount: json['playCount'],
      highQuality: json['highQuality'],
      trackCount: json['trackCount'],
    );
  }

  void setSongs(List<Music> songs) => this.songs = songs;
}
