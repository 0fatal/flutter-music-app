import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/data/music_data.dart';
import 'package:music_app/model/lyric.dart';
import 'package:music_app/model/song.dart';
import 'package:music_app/state/music_state.dart' as MusicState;
import 'package:music_app/widget/loading.dart';
import 'package:music_app/widget/lyric_view.dart';

import '../application.dart';

class MusicDetailScreen extends StatefulWidget {
  static const routeName = '/musicdetailscreen';

  const MusicDetailScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _musicDetailState();
}

class _musicDetailState extends State<MusicDetailScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero, () {
      _initData();
    });
    super.initState();
  }

  _initData() async {
    late int musicId = ModalRoute.of(context)!.settings.arguments as int;
    await MusicState.loadCurrentMusic(musicId);
    _isLoading = false;
    MusicState.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("歌曲详情"),
      ),
      body: _isLoading
          ? const Loading()
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: Stack(
                  alignment: Alignment.topCenter,
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(MusicState.currentMusic!.picUrl),
                            radius: 30,
                          ),
                        ),
                        Text(MusicState.currentMusic!.name,
                            style: TextStyle(fontSize: 20)),
                        SizedBox(height: 10),
                        _buildLyricView(),
                        SizedBox(height: 100)
                      ],
                    ),
                    Positioned(
                      child: Container(
                        child: Column(
                          children: [
                            _buildSlider(),
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.skip_previous),
                                    iconSize: 50,
                                    onPressed: () => MusicState.prev()
                                        .then((v) => setState(() {}))),
                                IconButton(
                                    icon: Icon(MusicState.isPlaying()
                                        ? Icons.pause_circle_outline
                                        : Icons.play_circle_outline),
                                    iconSize: 50,
                                    onPressed: () {
                                      if (MusicState.isPlaying()) {
                                        MusicState.pause().whenComplete(
                                            () => setState(() {}));
                                      } else {
                                        MusicState.play().whenComplete(
                                            () => setState(() {}));
                                      }
                                    }),
                                IconButton(
                                  icon: Icon(Icons.skip_next),
                                  iconSize: 50,
                                  onPressed: () => MusicState.next()
                                      .then((v) => setState(() {})),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border:
                                Border(top: BorderSide(color: Color(0x666)))),
                      ),
                      bottom: 0,
                      width: MediaQuery.of(context).size.width,
                    )
                  ])),
    );
  }

  Widget _buildSlider() {
    return ValueListenableBuilder(
        valueListenable: MusicState.currentRate,
        builder: (BuildContext ctx, double value, Widget? child) {
          return Slider(
            onChangeEnd: (double endValue) {
              MusicState.changeProcess(endValue);
              MusicState.lockRateChange = false;
              print("停止 滚动");
            },
            onChanged: (double value) {
              MusicState.currentRate.value = value;
            },
            onChangeStart: (double value) {
              MusicState.lockRateChange = true;
            },
            value: value,
          );
        });
  }

  late LyricView _LyricView;
  AnimationController? _lyricOffsetYController;

  Widget _buildLyricView() {
    _LyricView = LyricView(MusicState.currentMusic!.lyric ?? Lyric('raw'), 0);
    return ValueListenableBuilder(
        valueListenable: MusicState.currentLine,
        builder: (BuildContext ctx, int value, Widget? child) {
          if (value == -1) {
            return Text('暂无歌词');
          }
          startLineAnim(value);

          return CustomPaint(
            painter: _LyricView,
            size: Size(
                Application.screenWidth,
                Application.screenHeight -
                    kToolbarHeight -
                    ScreenUtil().setWidth(150) -
                    ScreenUtil().setWidth(50) -
                    Application.statusBarHeight -
                    ScreenUtil().setWidth(120)),
          );
        });
  }

  void startLineAnim(int curLine) {
    if (_LyricView.curLine != curLine) {
      _LyricView.curLine = curLine;
      // 如果动画控制器不是空，那么则证明上次的动画未完成，
      // 未完成的情况下直接 stop 当前动画，做下一次的动画
      if (_lyricOffsetYController != null) {
        _lyricOffsetYController!.stop();
      }

      // 初始化动画控制器，切换歌词时间为300ms，并且添加状态监听，
      // 如果为 completed，则消除掉当前controller，并且置为空。
      _lyricOffsetYController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 300))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _lyricOffsetYController!.dispose();
            _lyricOffsetYController = null;
          }
        });
      // 计算出来当前行的偏移量
      var end = _LyricView.computeScrollY(curLine) * -1;
      // 起始为当前偏移量，结束点为计算出来的偏移量
      Animation animation = Tween<double>(begin: _LyricView.offsetY, end: end)
          .animate(_lyricOffsetYController!);
      // 添加监听，在动画做效果的时候给 offsetY 赋值
      _lyricOffsetYController!.addListener(() {
        _LyricView.offsetY = animation.value;
      });
      // 启动动画
      _lyricOffsetYController!.forward();
    }
  }
// Widget _buildLyricView() {
//   return StreamBuilder<String>(stream: widget.model.,builder: (context,snapshot) {
//     // LyricView(MusicState.currentMusic.lyric,)
//     if (snapshot.hasData) {
//       var curTime = double.parse(snapshot.data)
//     }
//   })
// }
}
