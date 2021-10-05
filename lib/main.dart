import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:music_app/screen/music_curlist_screen.dart';
import 'package:music_app/screen/music_detail_screen.dart';
import 'package:music_app/screen/music_list_screen.dart';
import 'package:music_app/screen/personal_playlist_screen.dart';
import 'package:music_app/screen/playlist_screen.dart';
import 'package:music_app/state/music_state.dart' as MusicState;

import 'application.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(750, 1334),
        builder: () => MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const MyHomePage(title: 'Flutter Demo Home Page'),
              routes: {
                MusicDetailScreen.routeName: (context) => MusicDetailScreen(),
                MusicCurListScreen.routeName: (context) => MusicCurListScreen(),
              },
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 750, height: 1334);

    final size = MediaQuery.of(context).size;
    MusicState.init();
    Application.screenWidth = size.width;
    Application.screenHeight = size.height;
    Application.statusBarHeight = MediaQuery.of(context).padding.top;
    Application.bottomBarHeight = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          MusicListScreen(),
          PlaylistScreen(),
          PersonalPlaylistScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.hot_tub), label: '热门歌曲'),
            BottomNavigationBarItem(icon: Icon(Icons.hot_tub), label: '热门歌单'),
            BottomNavigationBarItem(icon: Icon(Icons.hot_tub), label: '我的歌单'),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Theme.of(context).textTheme.headline6!.color,
          onTap: (int index) {
            _currentIndex = index;
            // Vibrate.feedback(FeedbackType.light);
            setState(() {});
          }),
    );
  }
}
