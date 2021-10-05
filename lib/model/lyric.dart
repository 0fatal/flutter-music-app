class Lyric {
  List<LyricSlice> s = [];
  String raw = '';

  Lyric(this.raw) { parse();}

  bool parse() {
    if (raw == '') return false;
    var t = raw.split('\n');
    s = t.map((e) => LyricSlice.parse(e)).toList();
    return true;
  }

  int findLyricIndex(int p) {
    for (int i = 0; i < s.length;i++) {
      if(i == s.length - 1) {
        if (p >= s[i].beginTime) {
          return i;
        }
      } else {
        if (p >= s[i].beginTime && p <= s[i+1].beginTime) {
          return i;
        }
      }
    }
    return 0;
  }
}

class LyricSlice {
  late String str;
  late int beginTime;

  LyricSlice({
    this.str = '',
    this.beginTime = 0,
  });

  factory LyricSlice.parse(String raw) {
    RegExp reg = RegExp(r'\[(\d\d):(\d\d)\.(\d+)\]');
    var res = reg.firstMatch(raw);

    int m = int.parse(res?.group(1) ?? '0');
    int s = int.parse(res?.group(2) ?? '0');
    int ms = int.parse(res?.group(3) ?? '0');
    int time = m * 60 * 1000 + s * 1000 + ms;
    return LyricSlice(
      str: raw.replaceAll(reg, ''),
      beginTime:time,
    );
  }
}