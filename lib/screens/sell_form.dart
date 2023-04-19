import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SellForm extends StatefulWidget {
  const SellForm({super.key});

  @override
  State<SellForm> createState() => _SellFormState();
}

class _SellFormState extends State<SellForm> {
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _price = TextEditingController();

  File? file;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Item Name'),
              controller: _itemName,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Quantity Selling'),
              controller: _qty,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Price'),
              controller: _price,
            ),
            const SizedBox(
              height: 20,
            ),
            file == null
                ? const Text('No image selected.')
                : SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.file(file!),
                  ),
            ElevatedButton(onPressed: () {}, child: const Text('Put on Sale'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          pickFile();
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
