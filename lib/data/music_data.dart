import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:music_app/model/playlist.dart';
import 'package:music_app/model/song.dart';

const String baseUrl = "https://netease-music-api.fe-mm.com";

class SongApi {
  static Future<List<Music>> getNewSongPersonalized() async {
    List<Music> data;
    var response = await _getData('/personalized/newsong');
    var items = response['result'];
    data = List<Music>.from(items.map((item) => Music.fromJson(item)));
    return data;
  }

  static Future<List<Music>> getSongsDetail(List<String> ids) async {
    List<Music> data;
    var response = await _getData('/song/detail?ids=${ids.join(',')}');
    var items = response['songs'];
    data = List<Music>.from(items.map((item) {
      item['picUrl'] = item['al']['picUrl'];
      item['song'] = {};
      item['song']['artists'] = item['ar'];
      return Music.fromJson(item);
    }));
    return data;
  }

  static Future<String?> getLyric(int id) async {
    var data = await _getData('/lyric?id=$id');
    return data['lrc']?['lyric'].toString();
  }

  static String _filterLyric(String lyric) {
    RegExp reg = RegExp(r'\[\d\d:\d\d\.\d+\]');
    return lyric.replaceAll(reg, '');
  }
}

class PlaylistApi {
  static Future<List<Playlist>> getPlaylistPersonalized() async {
    List<Playlist> data = [];
    var response = await _getData('/personalized');
    var items = response['result'];
    // data = List<Playlist>.from(items.map((item) {
    //   await getPlaylistDetail(item['id']);
    // }));
    for (var item in items) {
      // var tmp = await getPlaylistDetail(item['id']);
      var tmp = Playlist.fromJson(item);
      data.add(tmp);
    }
    return data;
  }

  static Future<Playlist> getPlaylistDetail(int id) async {
    var response = await _getData('/playlist/detail?id=$id');
    var data = response['playlist'];
    var trackIds =
        List<String>.from(data['trackIds'].map((v) => v['id'].toString()));
    Playlist pl = Playlist(
        id: data['id'],
        name: data['name'],
        picUrl: data['coverImgUrl'] ?? '',
        playCount: data['playCount'],
        highQuality: data['highQuality'],
        trackCount: data['trackCount']);
    pl.setSongs(await SongApi.getSongsDetail(trackIds));
    return pl;
  }

  static Future<List<Playlist>> getPlaylistPersonal(int uuid) async {
    var data = await _getData('/user/playlist?uid=$uuid');
    var res = List<Playlist>.from(
        data['playlist'].map((v) => Playlist.fromJson(v)));
    return res;
  }
}

dynamic _getData(String path) async {
  String url = '$baseUrl$path';
  try {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };
    var response = await dio.get(url);
    return response.data;
  } on DioError catch (e) {
    print(e.error.toString());
  }
  return null;
}
