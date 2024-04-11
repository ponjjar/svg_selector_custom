import 'dart:math';

import 'package:body_part_selector/src/model/body_side.dart';
import 'package:body_part_selector/src/service/svg_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touchable/touchable.dart';

class BodyPartSelector extends HookWidget {
  final BodySide side;

  //final BodyParts bodyParts;
  final void Function(Map<String, bool>) onSelectionUpdated;
  final bool mirrored;

  final bool singleSelection;
  final Color? selectedColor;

  final Color? unselectedColor;
  final Color? selectedOutlineColor;
  final Color? unselectedOutlineColor;
  final List<String> bodypartsID;
  final Map<String, String>? bodypartsImage;
  const BodyPartSelector({
    super.key,
    this.bodypartsImage,
    required this.side,
    required this.onSelectionUpdated,
    this.mirrored = false,
    this.singleSelection = false,
    this.selectedColor,
    this.unselectedColor,
    this.selectedOutlineColor,
    this.unselectedOutlineColor,
    required this.bodypartsID,
  });

  @override
  Widget build(BuildContext context) {
    final macroBodyParts = useState(
      bodypartsID.isEmpty
          ? {
              'MACRO_BP_FACE': false,
              'MACRO_BP_NECK': false,
              'MACRO_BP_UPPER_ARM': false,
              'MACRO_BP_FOREARM': false,
              'MACRO_BP_CHEST': false,
              'MACRO_BP_ABDOMEN': false,
              'MACRO_BP_UPPER_LEG': false,
              'MACRO_BP_LOWER_LEG': false,
              'MACRO_BP_HIP': false,
            }
          : bodypartsID.fold<Map<String, bool>>(
              <String, bool>{},
              (map, id) => map..[id] = false,
            ),
    );
    final svgLoadDrawable = bodypartsImage ??
        {
          'front': "packages/body_part_selector/m_front.svg",
          'left': "packages/body_part_selector/m_left.svg",
          'back': "packages/body_part_selector/m_back.svg",
          'right': "packages/body_part_selector/m_right.svg",
        };
    final notifier = SvgService.instance.getSide(side, svgLoadDrawable);

    return ValueListenableBuilder<DrawableRoot?>(
        valueListenable: notifier,
        builder: (context, value, _) {
          if (value == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return _buildBody(context, value, macroBodyParts);
          }
        });
  }

  Map<String, bool> handleSelectionUpdated(String id,
      {bool mirror = false,
      bool singleSelection = false,
      required Map<String, bool> macrobodyParts,
      required String s,
      required bool value,
      required bool mirrored}) {
    var newMacrobodyParts = macrobodyParts;
    if (singleSelection) {
      macrobodyParts.forEach((key, value) {
        newMacrobodyParts[key] = true;
      });
    } else {
      if (macrobodyParts.containsKey(s)) {
        newMacrobodyParts[s] = !value;
        if (mirrored) {
          if (s.contains("left")) {
            final mirroredId =
                s.replaceAll("left", "right").replaceAll("Left", "Right");
            newMacrobodyParts[mirroredId] = macrobodyParts[s] ?? false;
          } else if (s.contains("right")) {
            final mirroredId =
                s.replaceAll("right", "left").replaceAll("Right", "Left");
            newMacrobodyParts[mirroredId] = macrobodyParts[s] ?? false;
          }
        }
      }
    }
    return macrobodyParts;
  }

  Widget _buildBody(BuildContext context, DrawableRoot drawable,
      ValueNotifier<Map<String, bool>> macrobodyParts) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeOutCubic,
      child: SizedBox.expand(
        key: ValueKey(
          macrobodyParts.value,
        ),
        child: CanvasTouchDetector(
          gesturesToOverride: const [GestureType.onTapDown],
          builder: (context) => CustomPaint(
            painter: _BodyPainter(
              root: drawable,
              bodyParts: macrobodyParts.value,
              // onTap: (s) =>
              // onSelectionUpdated?.call(
              //   bodyParts.withToggledId(s, mirror: mirrored),
              // ),
              onTap: (s) {
                // print('Selected ID: $bodyParts');
                var handleSelection = handleSelectionUpdated(s,
                    macrobodyParts: macrobodyParts.value,
                    s: s,
                    value: macrobodyParts.value[s] ?? false,
                    mirrored: mirrored,
                    singleSelection: singleSelection);

                onSelectionUpdated.call(handleSelection);
                macrobodyParts.value = handleSelection;
              },
              context: context,
              selectedColor: selectedColor ?? colorScheme.onSecondary,
              unselectedColor: unselectedColor ?? colorScheme.surface,
              selectedOutlineColor: selectedOutlineColor ?? colorScheme.primary,
              unselectedOutlineColor:
                  unselectedOutlineColor ?? colorScheme.inverseSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  final DrawableRoot root;

  final BuildContext context;
  final void Function(String) onTap;
  final dynamic bodyParts;
  final Color selectedColor;
  final Color unselectedColor;
  final Color unselectedOutlineColor;
  final Color selectedOutlineColor;

  _BodyPainter({
    required this.root,
    required this.bodyParts,
    required this.onTap,
    required this.context,
    required this.selectedColor,
    required this.unselectedColor,
    required this.unselectedOutlineColor,
    required this.selectedOutlineColor,
  });

  void drawBodyParts({
    required TouchyCanvas touchyCanvas,
    required Canvas plainCanvas,
    required Size size,
    required Iterable<Drawable> drawables,
    required Matrix4 fittingMatrix,
  }) {
    for (final element in drawables) {
      final id = element.id;
      if (id == null) {
        debugPrint("Found a drawable element without an ID. Skipping $element");
        continue;
      }
      touchyCanvas.drawPath(
        (element as DrawableShape).path.transform(fittingMatrix.storage),
        Paint()
          ..color = isSelected(id) ? selectedColor : unselectedColor
          ..style = PaintingStyle.fill,
        onTapDown: (_) => onTap(id),
      );
      plainCanvas.drawPath(
        element.path.transform(fittingMatrix.storage),
        Paint()
          ..color =
              isSelected(id) ? selectedOutlineColor : unselectedOutlineColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  bool isSelected(String key) {
    final selections = bodyParts;
    if (selections.containsKey(key) && selections[key]!) {
      return true;
    }
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size != root.viewport.viewBoxRect.size) {
      final double scale = min(
        size.width / root.viewport.viewBoxRect.width,
        size.height / root.viewport.viewBoxRect.height,
      );
      final Size scaledHalfViewBoxSize =
          root.viewport.viewBoxRect.size * scale / 2.0;
      final Size halfDesiredSize = size / 2.0;
      final Offset shift = Offset(
        halfDesiredSize.width - scaledHalfViewBoxSize.width,
        halfDesiredSize.height - scaledHalfViewBoxSize.height,
      );

      final bodyPartsCanvas = TouchyCanvas(context, canvas);

      final Matrix4 fittingMatrix = Matrix4.identity()
        ..translate(shift.dx, shift.dy)
        ..scale(scale);

      final drawables =
          root.children.where((element) => element.hasDrawableContent);

      drawBodyParts(
        touchyCanvas: bodyPartsCanvas,
        plainCanvas: canvas,
        size: size,
        drawables: drawables,
        fittingMatrix: fittingMatrix,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
