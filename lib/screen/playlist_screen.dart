import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/state/playlist_state.dart' as PlaylistState;
import 'package:music_app/widget/loading.dart';

import 'music_curlist_screen.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    PlaylistState.loadPlaylistPersonalized()
        .whenComplete(() => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text("热门歌单")),
      body: _isLoading
          ? Loading()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                print(PlaylistState.playlists[index].picUrl);
                return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          MusicCurListScreen.routeName,
                          arguments: PlaylistState.playlists[index].id);
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                          child: Column(children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      PlaylistState.playlists[index].picUrl),
                                  fit: BoxFit.cover)),
                        )),
                        Padding(
                          child: Text(
                            PlaylistState.playlists[index].name,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          padding: EdgeInsets.all(10),
                        )
                      ])),
                      shape: RoundedRectangleBorder(
                        //形状
                        //修改圆角
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      elevation: 4.0,
                    ));
              },
              itemCount: PlaylistState.playlists.length,
            ),
    );
  }


}
