import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:krishi_test/screens/loading.dart';

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
    }
  }

  Future<String> uploadFileToFirebase(File? file) async {
    if (file == null) throw Exception('File is null');

    final storageRef = FirebaseStorage.instance.ref();

    // File name is bad idea
    final imageRef = storageRef.child('files/${file.path.split('/').last}');

    await imageRef.putFile(file);

    final String downloadUrl = await imageRef.getDownloadURL();

    return downloadUrl;
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
            ElevatedButton(
              onPressed: saleButtonPressed,
              child: const Text('Put on Sale'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/market');
              },
              child: const Text('Open market'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await pickFile();
          // final String? fileUrl = await uploadFileToFirebase(file);
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  void saleButtonPressed() async {
    final String itemName = _itemName.text;
    final String qty = _qty.text;
    final String price = _price.text;

    if (file == null) {
      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Must add an image")),
      );
      return;
    }

    Navigator.of(context).push(PageRouteBuilder(
      opaque: true,
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoadingPage(),
    ));

    String downloadUrl = '';

    // Upload the image to firebase
    try {
      downloadUrl = await uploadFileToFirebase(file);
    } catch (e) {
      // Pop loading screen
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("An error occurred while uploading image")),
      );
      return;
    }

    // Now that the image is uploaded successfully, we create a document
    // First we need logged in user's uuid
    // Assuming that the user is logged in:
    final String sellerUuid = FirebaseAuth.instance.currentUser!.uid;

    final firestore = FirebaseFirestore.instance;
    await firestore.collection("market").add({
      "sellerUuid": sellerUuid,
      "name": itemName,
      "quantity": qty,
      "price": price,
      "imageLink": downloadUrl,
      // Empty buyerUuid represents that the item is not sold yet
      "buyerUuid": ""
    });

    if (!mounted) return;

    // Pop loading screen
    Navigator.of(context).pop();

    // Show success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Item added to market")),
    );
    Navigator.of(context).pushReplacementNamed('/market');
  }
}
