import 'package:music_app/data/music_data.dart';
import 'package:music_app/model/playlist.dart';

List<Playlist> playlists = <Playlist>[];
List<Playlist> pPlaylists = <Playlist>[];
Playlist? curPlaylist;


Future loadPlaylistPersonalized() async{
  playlists = await PlaylistApi.getPlaylistPersonalized();
}

Future loadPlaylist(int playlistId) async{
  curPlaylist = await PlaylistApi.getPlaylistDetail(playlistId);
}

Future loadPlaylistPersonal(int uuid) async {
  pPlaylists = await PlaylistApi.getPlaylistPersonal(uuid);
}

