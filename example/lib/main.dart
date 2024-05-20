import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:svg_selector_custom/body_part_selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Body Part Selector',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: const MyHomePage(title: 'Body Part Selector'),
    );
  }
}

class MyHomePage extends HookWidget {
  final String title;
  //Fazer dois checkbox singulares, ao selecionar um deles, o texto e a imagem de exemplo muda, A imagem deve ser um exemplo de como captura, por exemplo: uma pessoa em TPose enquanto outra tira foto…
  const MyHomePage({super.key, required this.title});

  //load image & show points of interest

  @override
  Widget build(BuildContext context) {
    final bodyParts = useState({
      'MACRO_BP_FACE': false,
      'MACRO_BP_NECK': false,
      'MACRO_BP_UPPER_ARM': false,
      'MACRO_BP_FOREARM': false,
      'MACRO_BP_CHEST': false,
      'MACRO_BP_ABDOMEN': false,
      'MACRO_BP_UPPER_LEG': false,
      'MACRO_BP_LOWER_LEG': false,
      'MACRO_BP_HIP': false,
      'MACRO_BP_BUTTOCKS': false,
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: MacroPartsSelectorTurnable(
          bodyParts.value,
          onSelectionStateUpdate: (selection) {
            bodyParts.value = selection.map((key, value) {
              return MapEntry(key, value);
            });
          },
          labelData: const RotationStageLabelData(
            front: 'Frente',
            left: 'Esquerda',
            right: 'Direita',
            back: 'Costas',
          ),
        ),
      ),
    );
  }
}
