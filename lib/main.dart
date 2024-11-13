import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reconocimiento de tu maldita madre',
      theme: ThemeData.dark(),
      home: ReconocimientoScreen(),
    );
  }
}

class ReconocimientoScreen extends StatefulWidget {
  @override
  _ReconocimientoScreenState createState() => _ReconocimientoScreenState();
}

class _ReconocimientoScreenState extends State<ReconocimientoScreen> {
  final ImagePicker _picker = ImagePicker();
  String _resultado =
      'Sube una imagen o toma una foto para identificar la especie';

  // Cargar imagen de la galería o cámara
  Future<void> _cargarImagen(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        // Verificar si estamos en Android o iOS antes de ejecutar el modelo
        if (Platform.isAndroid || Platform.isIOS) {
          // Aquí va la lógica de predicción para Android e iOS usando tflite_flutter
          _resultado = "Predicción de la imagen seleccionada";
        } else {
          // Si estamos en Web o Escritorio, mostramos un mensaje de no compatibilidad
          _resultado =
              'El reconocimiento de maderas solo está disponible en Android/iOS';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reconocimiento de Especies de Maderas')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _resultado,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.upload_file),
                  label: Text('Cargar imagen'),
                  onPressed: () => _cargarImagen(ImageSource.gallery),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt),
                  label: Text('Tomar foto'),
                  onPressed: () => _cargarImagen(ImageSource.camera),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
