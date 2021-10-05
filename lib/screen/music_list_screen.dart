import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/screen/music_detail_screen.dart';
import 'package:music_app/state/music_state.dart' as MusicState;
import 'package:music_app/widget/loading.dart';

import '../application.dart';

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MusicListState();

}

class MusicListState extends State<MusicListScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() {
    _isLoading = true;
    MusicState.initHomeMusicList().then((value) =>
        setState(() {
          _isLoading = false;
        })).whenComplete(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('热门歌曲'),
        elevation: 0,
      ),
      body: _isLoading ? const Loading() : ListView.builder(
          itemCount: MusicState.homeMusicList!.length,
          itemBuilder: (context, index) {
            // return Row(
            //   children: [
            //     Text(MusicState.homeMusicList![index].name),
            //     Expanded(
            //       child: Text(''), // 中间用Expanded控件
            //     ),
            //     IconButton(
            //       icon: Icon(Icons.play_circle),
            //       onPressed: (){
            //         Navigator.of(context).pushNamed(
            //           MusicDetailScreen.routeName,
            //           arguments: MusicState.homeMusicList![index].id,
            //         );
            //       },
            //     )
            //   ],
            // );
            return ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundImage:
                NetworkImage(MusicState.homeMusicList![index].picUrl),
                radius: 30,
              ),
              title: Text(MusicState.homeMusicList![index].name),
              trailing: IconButton(
                icon: Icon(Icons.play_circle),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    MusicDetailScreen.routeName,
                    arguments: MusicState.homeMusicList![index].id,
                  );
                },
              ),
              subtitle: Text(
                  MusicState.homeMusicList![index].artists.map((e) => e.name)
                      .join('/')
              )
              ,
            );
          }),
    );
  }

}