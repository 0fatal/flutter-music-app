import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/model/lyric.dart';
import 'package:music_app/widget/common_text_style.dart';

class LyricView extends CustomPainter with ChangeNotifier {
  late Lyric lyric;
  late int curLine;
  late Paint linePaint;
  double _offsetY = 0.0;
  Size canvasSize = Size.zero;
  List<TextPainter> lyricPaints = [];
  double totalHeight = 0;// 总高度

  double get offsetY => _offsetY;

  set offsetY(double value){
    _offsetY = value;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvasSize = size;
    var y = _offsetY + size.height / 2 + lyricPaints[0].height / 2;
    for (int i = 0; i < lyric.s.length; i++) {
      if ( y > size.height || y < (0 - lyricPaints[0].height) / 2) {

      } else {
        if (curLine == i) {
          // 如果是当前行
          lyricPaints[i].text =
              TextSpan(text: lyric.s[i].str, style: common14BlueTextStyle);
          lyricPaints[i].layout();
        } else {
          lyricPaints[i].text = TextSpan(text: lyric.s[i].str,style: commonGrayTextStyle);
          lyricPaints[i].layout();
        }
        lyricPaints[i].paint(canvas, Offset((size.width - lyricPaints[i].width)/2, y));

      }

      y += lyricPaints[i].height + ScreenUtil().setWidth(30);
    }
  }

  @override
  bool shouldRepaint(covariant LyricView oldDelegate) {
    return oldDelegate._offsetY != _offsetY;
  }

  LyricView(this.lyric, this.curLine) {
    linePaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = ScreenUtil().setWidth(1).toDouble();
    lyricPaints.addAll(lyric.s.map((l) =>
        TextPainter(
            text: TextSpan(text: l.str,style: commonGrayTextStyle),
            textDirection: TextDirection.ltr
        )).toList());

    _layoutTextPainters();
  }

  void _layoutTextPainters() {
    for (var lp in lyricPaints) {
      lp.layout();
    }

    Future.delayed(const Duration(microseconds: 300),() {
      totalHeight = (lyricPaints[0].height + ScreenUtil().setWidth(30)) * (lyricPaints.length - 1);
    });
  }

  /// 计算传入行和第一行的偏移量
  double computeScrollY(int curLine) {
    return (lyricPaints[0].height + ScreenUtil().setWidth(30)) * (curLine + 1);
  }


}