import 'package:body_part_selector/src/body_part_selector.dart';
import 'package:body_part_selector/src/model/body_side.dart';
import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';

export 'package:rotation_stage/rotation_stage.dart';

class BodyPartSelectorTurnable extends StatelessWidget {
  final List<String>? bodypartsID;
  // final BodyParts bodyParts;
  final Function(List<bool>)? onSelectionUpdated;
  final bool mirrored;
  final EdgeInsets padding;
  final RotationStageLabelData? labelData;
  final List<String>? bodypartsImage;
  const BodyPartSelectorTurnable(
      {super.key,
      //  required this.bodyParts,
      this.onSelectionUpdated,
      this.mirrored = false,
      this.padding = EdgeInsets.zero,
      this.labelData,
      this.bodypartsID,
      this.bodypartsImage});

  @override
  Widget build(BuildContext context) {
    return RotationStage(
      contentBuilder: (index, side, page) => Padding(
        padding: padding,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BodyPartSelector(
            bodypartsImage: bodypartsImage != null
                ? {
                    BodySide.front: bodypartsImage![0],
                    BodySide.left: bodypartsImage![1],
                    BodySide.back: bodypartsImage![2],
                    BodySide.right: bodypartsImage![3],
                  }
                : {
                    BodySide.front: 'm_front.svg',
                    BodySide.left: 'm_left.svg',
                    BodySide.back: 'm_back.svg',
                    BodySide.right: 'm_right.svg',
                  },
            bodypartsID: (bodypartsID != null && bodypartsID!.isNotEmpty)
                ? bodypartsID!
                : [
                    'MACRO_BP_FACE',
                    'MACRO_BP_NECK',
                    'MACRO_BP_UPPER_ARM',
                    'MACRO_BP_FOREARM',
                    'MACRO_BP_CHEST',
                    'MACRO_BP_ABDOMEN',
                    'MACRO_BP_UPPER_LEG',
                    'MACRO_BP_LOWER_LEG',
                    'MACRO_BP_HIP',
                  ],
            side: side.map(
              front: BodySide.front,
              left: BodySide.left,
              back: BodySide.back,
              right: BodySide.right,
            ),
            //  bodyParts: bodyParts,
            onSelectionUpdated: onSelectionUpdated,
            mirrored: mirrored,
          ),
        ),
      ),
      labels: labelData,
    );
  }
}
