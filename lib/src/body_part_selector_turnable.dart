import 'package:body_part_selector/body_part_selector.dart';
import 'package:flutter/material.dart';

export 'package:rotation_stage/rotation_stage.dart';

class BodyPartSelectorTurnable extends StatelessWidget {
  final List<String>? bodypartsID;
  // final BodyParts bodyParts;
  // final Function(
  //   dynamic bodyparts,
  // ) onSelectionUpdated;
  final bool mirrored;
  final EdgeInsets padding;
  final RotationStageLabelData? labelData;
  final Map<String, String>? bodypartsImage;
  final BodyParts bodyParts;
  final Function(
    Map<String, bool> p,
    BodyParts bodyParts,
  ) onSelectionStateUpdate;
  const BodyPartSelectorTurnable(
    this.bodyParts, {
    super.key,
    //  required this.bodyParts,
    required this.onSelectionStateUpdate,
    this.mirrored = false,
    this.padding = EdgeInsets.zero,
    this.labelData,
    this.bodypartsID,
    this.bodypartsImage,
  });

  @override
  Widget build(BuildContext context) {
    return RotationStage(
      contentBuilder: (index, side, page) => Padding(
        padding: padding,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BodyPartSelector(
            bodypartsImage: bodypartsImage,
            bodyParts: bodyParts,
            bodypartsID: bodypartsID!,
            side: side.map(
              front: BodySide.front,
              left: BodySide.left,
              back: BodySide.back,
              right: BodySide.right,
            ),

            //  bodyParts: bodyParts,
            onSelectionStateUpdate: onSelectionStateUpdate,
            mirrored: mirrored,
          ),
        ),
      ),
      labels: labelData,
    );
  }
}
