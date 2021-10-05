import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/data/music_data.dart';

void main() {
  test('testMusicData', () async{
    var res = await SongApi.getNewSongPersonalized();
    print(res.toString());
  });

  test('testPlaylistData',()async{
    var res = await PlaylistApi.getPlaylistPersonalized();
    print(res.toString());
  });
}