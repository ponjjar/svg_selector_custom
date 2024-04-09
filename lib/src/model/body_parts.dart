import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_parts.freezed.dart';
part 'body_parts.g.dart';

@freezed
class BodyParts with _$BodyParts {
  static const all = BodyParts(
    MACRO_BP_FACE: true,
    MACRO_BP_NECK: true,
    MACRO_BP_UPPER_ARM: true,
    MACRO_BP_FOREARM: true,
    MACRO_BP_CHEST: true,
    MACRO_BP_ABDOMEN: true,
    MACRO_BP_UPPER_LEG: true,
    MACRO_BP_LOWER_LEG: true,
    MACRO_BP_HIP: true,
  );

  const factory BodyParts({
    // ignore: non_constant_identifier_names
    @Default(false) bool MACRO_BP_FACE,

    // ignore: non_constant_identifier_names
    @Default(false) bool MACRO_BP_NECK,

    // ignore: non_constant_identifier_names
    @Default(false) bool MACRO_BP_UPPER_ARM,

    // ignore: non_constant_identifier_names
    @Default(false) bool MACRO_BP_FOREARM,

    // ignore: non_constant_identifier_names
    @Default(false) bool MACRO_BP_CHEST,

    // ignore: non_constant_identifier_names
    @Default(false) bool MACRO_BP_ABDOMEN,

    // ignore: non_constant_identifier_names
    @Default(false) bool MACRO_BP_UPPER_LEG,

    // ignore: non_constant_identifier_names
    @Default(false) bool MACRO_BP_LOWER_LEG,

    // ignore: non_constant_identifier_names
    @Default(false) bool MACRO_BP_HIP,
  }) = _BodyParts;

  factory BodyParts.fromJson(Map<String, dynamic> json) =>
      _$BodyPartsFromJson(json);

  const BodyParts._();

  /// Toggles the BodyPart with the given [id].
  ///
  /// If [id] doesn't represent a valid BodyPart, this returns an unchanged
  /// Object. If [mirror] is true, and the BodyPart is one that exists on both
  /// sides (e.g. Knee), the other side is toggled as well.
  BodyParts withToggledId(String id,
      {bool mirror = false, bool singleSelection = false}) {
    final map = toJson();

    if (singleSelection) {
      if (map[id] == true) {
        Set<String> allKeys = map.keys.toSet();
        for (var key in allKeys) {
          map[key] = true;
        }
        map[id] = !map[id];
      }
    } else {
      if (!map.containsKey(id)) return this;
      map[id] = !map[id];
      if (mirror) {
        if (id.contains("left")) {
          final mirroredId =
              id.replaceAll("left", "right").replaceAll("Left", "Right");
          map[mirroredId] = map[id];
        } else if (id.contains("right")) {
          final mirroredId =
              id.replaceAll("right", "left").replaceAll("Right", "Left");
          map[mirroredId] = map[id];
        }
      }
    }

    return BodyParts.fromJson(map);
  }
}
