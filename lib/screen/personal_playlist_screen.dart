import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/state/playlist_state.dart' as PlaylistState;
import 'package:music_app/widget/loading.dart';

import 'music_curlist_screen.dart';

class PersonalPlaylistScreen extends StatefulWidget {
  const PersonalPlaylistScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_PersonalPlaylistScreenState();

}

class _PersonalPlaylistScreenState extends State<PersonalPlaylistScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    // Future.delayed(Duration.zero,() {
    //   _isLoading = true;
    //   var textController = TextEditingController();
    //   // showCupertinoDialog(context: context, builder: (context) {
    //   //   return CupertinoAlertDialog(
    //   //     title: Text('温馨提醒'),
    //   //     content: Card(
    //   //       elevation: 0.0,
    //   //       child: Column(
    //   //         children: [
    //   //           Text('请输入您的uuid'),
    //   //           CupertinoTextField(
    //   //             controller: textController,
    //   //           )
    //   //         ],
    //   //       ),
    //   //     ),
    //   //     actions:  [
    //   //       CupertinoDialogAction(child: Text('确定'),onPressed: () {Navigator.pop(context);})
    //   //     ],
    //   //   );
    //   // });
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text("我的歌单")),
      body: _isLoading
          ? _buildTextInput(context)
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          print(PlaylistState.pPlaylists[index].picUrl);
          return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                    MusicCurListScreen.routeName,
                    arguments: PlaylistState.pPlaylists[index].id);
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
                                        PlaylistState.pPlaylists[index].picUrl),
                                    fit: BoxFit.cover)),
                          )),
                      Padding(
                        child: Text(
                          PlaylistState.pPlaylists[index].name,
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
        itemCount: PlaylistState.pPlaylists.length,
      ),
    );
  }

  final TextEditingController _textController = TextEditingController();

  Widget _buildTextInput(BuildContext context) {
    return Center(
      child:Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "网易云id",
            ),
            controller: _textController,
          ),
          TextButton(
            onPressed: () {
              print(_textController.text);
              PlaylistState.loadPlaylistPersonal(int.parse(_textController.text))
                  .whenComplete(() => setState(() => _isLoading = false));
            },
            child: Text('确定'),
          ),
        ],
      )
    );
  }
}
