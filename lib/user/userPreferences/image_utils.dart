import 'dart:convert';
import 'dart:typed_data';

// Fungsi untuk mengonversi Uint8List menjadi String Base64
String convertImageToBase64(Uint8List image) {
  return base64Encode(image);
}

// Fungsi untuk mengonversi String Base64 menjadi Uint8List
Uint8List convertBase64ToImage(String base64String) {
  return base64Decode(base64String);
}
