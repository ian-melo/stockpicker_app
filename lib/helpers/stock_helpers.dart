
import 'package:flutter/material.dart';

AssetImage getLogo(String code) {
  return AssetImage("assets/images/${code.toLowerCase()}.png");
}

double formatToDouble(String str) {
  final strNew = str
      .replaceAll(RegExp(r"\s"), "")
      .replaceAll("%", "")
      .replaceAll(".", "")
      .replaceAll(",", ".");
  return double.tryParse(strNew) ?? 0;
}

String workaroundField(String str) =>
    str.replaceFirst("_", "");
