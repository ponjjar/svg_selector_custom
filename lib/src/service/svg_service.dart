import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svg_selector_custom/body_part_selector.dart';
import 'package:svg_selector_custom/src/model/body_side.dart';

class SvgService {
  static final SvgService _instance = SvgService._();

  static Map<String, String> loadDrawables = {
    'front': "packages/body_part_selector/m_front.svg",
    'left': "packages/body_part_selector/m_left.svg",
    'back': "packages/body_part_selector/m_back.svg",
    'right': "packages/body_part_selector/m_right.svg",
  };

  static SvgService get instance => _instance;

  final ValueNotifier<DrawableRoot?> _front = ValueNotifier(null);
  final ValueNotifier<DrawableRoot?> _left = ValueNotifier(null);

  final ValueNotifier<DrawableRoot?> _back = ValueNotifier(null);
  final ValueNotifier<DrawableRoot?> _right = ValueNotifier(null);

  SvgService._() {
    _init();
  }

  ValueNotifier<DrawableRoot?> getSide(BodySide side) {
    return side.map(
      front: _front,
      left: _left,
      back: _back,
      right: _right,
    );
  }

  Future<void> _init() async {
    await Future.wait([
      for (final side in BodySide.values) _loadDrawable(side, getSide(side)),
    ]);
  }

  Future<void> _loadDrawable(
      BodySide side, ValueNotifier<Drawable?> notifier) async {
    final svgBytes = await rootBundle.load(
      side.map(
        front: loadDrawables['front']!,
        left: loadDrawables['left']!,
        back: loadDrawables['back']!,
        right: loadDrawables['right']!,
      ),
    );
    //final svgBytes = await loadDrawables;
    notifier.value =
        await svg.fromSvgBytes(svgBytes.buffer.asUint8List(), "svg");
  }
}
