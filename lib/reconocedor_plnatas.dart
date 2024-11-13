import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ReconocedorMaderas {
  final Interpreter interpreter;
  static const Map<int, String> CLASES = {
    0: 'Acacia',
    1: 'Balsamo',
    2: 'Camajon',
    3: 'Carreto',
    4: 'Cedro',
    5: 'Ceiba',
    6: 'Corazón fino',
    7: 'Ebano',
    8: 'Guayacan',
    9: 'Melina',
    10: 'Roble',
    11: 'Tananeo',
    12: 'Teca'
  };

  ReconocedorMaderas({required this.interpreter});

  static Future<ReconocedorMaderas> create() async {
    final interpreter = await Interpreter.fromAsset('modelo_entrenado.tflite');
    return ReconocedorMaderas(interpreter: interpreter);
  }

  String predecir(File imagen) {
    // Convertir la imagen en formato adecuado para el modelo
    TensorImage tensorImage = TensorImage.fromFile(imagen);
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(64, 64, ResizeMethod.NEAREST_NEIGHBOUR))
        .build();
    tensorImage = imageProcessor.process(tensorImage);

    // Ejecutar el modelo y obtener la predicción
    List<double> output = List.filled(13, 0); // 13 clases
    interpreter.run(tensorImage.buffer, output);

    final int predictedIndex =
        output.indexOf(output.reduce((a, b) => a > b ? a : b));
    return CLASES[predictedIndex] ?? 'Clase desconocida';
  }
}
