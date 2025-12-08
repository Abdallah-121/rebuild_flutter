// ignore_for_file: unnecessary_null_comparison
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

typedef OnImagesChanged = void Function(List<String> imagesBase64);

class ImagePickerWithProgress extends StatefulWidget {
  final OnImagesChanged onChanged;

  const ImagePickerWithProgress({super.key, required this.onChanged});

  @override
  State<ImagePickerWithProgress> createState() =>
      _ImagePickerWithProgressState();
}

class _ImagePickerWithProgressState extends State<ImagePickerWithProgress> {
  final picker = ImagePicker();
  final List<File> _images = [];
  final List<String> _base64Images = [];
  bool isCompressing = false;

  Future<String> _compress(String path) async {
    final bytes = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: 1080,
      quality: 70,
    );
    return base64Encode(bytes!);
  }

  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isEmpty) return;

    setState(() => isCompressing = true);

    for (var img in picked) {
      _images.add(File(img.path));
      _base64Images.add(await _compress(img.path));
    }

    setState(() => isCompressing = false);
    widget.onChanged(_base64Images);
  }

  void removeImage(int i) {
    _images.removeAt(i);
    _base64Images.removeAt(i);
    setState(() {});
    widget.onChanged(_base64Images);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.photo_library),
          label: const Text("إضافة صور"),
          onPressed: isCompressing ? null : pickImages,
        ),

        if (isCompressing)
          const Padding(
            padding: EdgeInsets.all(8),
            child: LinearProgressIndicator(),
          ),

        if (_images.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (_, i) => Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(6),
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(
                        image: FileImage(_images[i]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => removeImage(i),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
