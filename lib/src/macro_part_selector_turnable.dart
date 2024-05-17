import 'package:flutter/material.dart';
import 'package:svg_selector_custom/body_part_selector.dart';

export 'package:rotation_stage/rotation_stage.dart';

class MacroPartsSelectorTurnable extends StatelessWidget {
  final Map<String, bool>? macroParts;
  // final BodyParts bodyParts;
  // final Function(
  //   dynamic bodyparts,
  // ) onSelectionUpdated;
  final bool mirrored;
  final EdgeInsets padding;
  final RotationStageLabelData? labelData;
  final Map<String, String>? macroPartsImage;
  // final BodyParts bodyParts;
  final Function(
    Map<String, bool> p,
  ) onSelectionStateUpdate;

  const MacroPartsSelectorTurnable(
    this.macroParts, {
    super.key,
    //required this.bodyParts,
    //  required this.bodyParts,
    required this.onSelectionStateUpdate,
    this.mirrored = false,
    this.padding = EdgeInsets.zero,
    this.labelData,
    this.macroPartsImage,
  });

  @override
  Widget build(BuildContext context) {
    return RotationStage(
      contentBuilder: (index, side, page) => Padding(
        padding: padding,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(children: [
            MacroPartSelector(
              macroParts ??
                  {
                    'MACRO_BP_FACE': false,
                    'MACRO_BP_NECK': false,
                    'MACRO_BP_UPPER_ARM': false,
                    'MACRO_BP_FOREARM': false,
                    'MACRO_BP_CHEST': false,
                    'MACRO_BP_ABDOMEN': false,
                    'MACRO_BP_UPPER_LEG': false,
                    'MACRO_BP_LOWER_LEG': false,
                    'MACRO_BP_HIP': false,
                  },
              macropartsImage: macroPartsImage,
              //  bodypartsID: bodypartsID!,
              side: side.map(
                front: BodySide.front,
                left: BodySide.left,
                back: BodySide.back,
                right: BodySide.right,
              ),

              //    bodyParts: bodyParts,
              onSelectionStateUpdate: onSelectionStateUpdate,
              mirrored: mirrored,
            ),
          ]),
        ),
      ),
      labels: labelData,
    );
  }
}
