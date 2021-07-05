import 'package:flutter/material.dart';

class CardInfos {

  final String type;
  final String title;
  final String text;
  final String urlImg;
  final List<dynamic> actions;

  CardInfos({required this.type, required this.title, required this.text, required this.urlImg, required this.actions });
}

class CardInfos2 {

  final String type;
  final String template;
  final String title;
  final String text;
  final String subElement1;
  final String subElement2;
  final List<dynamic> actions;

  CardInfos2({required this.type, required this.template, required this.title, required this.text, required this.subElement1, required this.subElement2, required this.actions });
}