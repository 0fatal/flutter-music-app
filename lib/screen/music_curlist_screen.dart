import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data/music_data.dart';
import 'package:music_app/model/playlist.dart';
import 'package:music_app/screen/music_detail_screen.dart';
import 'package:music_app/state/music_state.dart' as MusicState;
import 'package:music_app/state/playlist_state.dart' as PlaylistState;
import 'package:music_app/widget/loading.dart';

class MusicCurListScreen extends StatefulWidget {
  const MusicCurListScreen({Key? key}) : super(key: key);
  static const routeName = '/playlist-detail';

  @override
  State<StatefulWidget> createState() => MusicCurListState();
}

class MusicCurListState extends State<MusicCurListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () => _initData());
    super.initState();
  }

  Future _initData() async {
    _isLoading = true;
    print('1111111111111111111');
    int playlistId = ModalRoute.of(context)!.settings.arguments as int;

    print(playlistId);
    await PlaylistState.loadPlaylist(playlistId);
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? Text('loading...')
            : Text(PlaylistState.curPlaylist?.name ?? ''),
        elevation: 0,
        leading: _isLoading ? Icon(Icons.music_note):Image.network(PlaylistState.curPlaylist?.picUrl ?? ''),
      ),
      body: _isLoading
          ? const Loading()
          : ListView.builder(
              itemCount: PlaylistState.curPlaylist!.songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        PlaylistState.curPlaylist!.songs[index].picUrl),
                    radius: 30,
                  ),
                  title: Text(PlaylistState.curPlaylist!.songs[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.play_circle),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        MusicDetailScreen.routeName,
                        arguments: PlaylistState.curPlaylist!.songs[index].id,
                      );
                    },
                  ),
                  subtitle: Text(PlaylistState.curPlaylist!.songs[index].artists
                      .map((e) => e.name)
                      .join('/')),
                );
              }),
    );
  }
}
