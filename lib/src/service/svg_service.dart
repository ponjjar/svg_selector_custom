import 'dart:async';

import 'package:body_part_selector/body_part_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgService {
  final ValueNotifier<DrawableRoot?> _front = ValueNotifier(null);

  final ValueNotifier<DrawableRoot?> _left = ValueNotifier(null);

  final ValueNotifier<DrawableRoot?> _back = ValueNotifier(null);
  final ValueNotifier<DrawableRoot?> _right = ValueNotifier(null);
  SvgService._(Future<ByteData> loadDrawables) {
    _init(
      loadDrawables,
    );
  }
  ValueNotifier<DrawableRoot?> getSide(BodySide side) => side.map(
        front: _front,
        left: _left,
        back: _back,
        right: _right,
      );

  Future<void> _init(Future<ByteData> loadDrawables) async {
    await Future.wait([
      for (final side in BodySide.values)
        _loadDrawable(side, getSide(side), loadDrawables),
    ]);
  }

  Future<void> _loadDrawable(BodySide side, ValueNotifier<Drawable?> notifier,
      Future<ByteData> loadDrawables) async {
    // final svgBytes = await rootBundle.load(
    //   side.map(
    //     front: "packages/body_part_selector/m_front.svg",
    //     left: "packages/body_part_selector/m_left.svg",
    //     back: "packages/body_part_selector/m_back.svg",
    //     right: "packages/body_part_selector/m_right.svg",
    //   ),
    // );
    final svgBytes = await loadDrawables;
    notifier.value =
        await svg.fromSvgBytes(svgBytes.buffer.asUint8List(), "svg");
  }

  static SvgService instance(
    Future<ByteData> loadDrawables,
  ) {
    return SvgService._(loadDrawables);
  }
}
