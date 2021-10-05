import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'lyric.dart';

class Music {
  late int id;
  late String name;
  late String url;
  late String picUrl;
  late List<Artist> artists;
  Lyric? lyric;

  Music(
      {this.id = 0,
      this.name = '',
      this.url = '',
      this.picUrl = '',
      this.artists = const []});

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
        id: json['id'],
        name: json['name'],
        picUrl: json['picUrl'],
        artists: List<Artist>.from(json['song']['artists']
            .map((item) => Artist.fromJson(item))));
  }
}

class Artist {
  late int id;
  late String name;
  late String picUrl;
  late String briefDesc;

  Artist({
    this.id = 0,
    this.name = '',
    this.picUrl = '',
    this.briefDesc = '',
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      picUrl: json['picUrl'] ?? '',
    );
  }
}
