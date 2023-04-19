import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              setState(() {
                auth.signOut();
              });
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: firestore.collection('market').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var documents = snapshot.data!.docs
              .where((product) => product['buyerUuid'] == "")
              .toList();

          if (documents.isEmpty) {
            return const Center(child: Text("No products available"));
          }
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot product = documents[index];
              return Card(
                child: ListTile(
                  leading: SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.network(product['imageLink']),
                  ),
                  title: Text(product['name']),
                  subtitle: Text("₹${product['price']}"),
                  trailing: ElevatedButton(
                    onPressed: auth.currentUser!.uid == product['sellerUuid']
                        ? null
                        : () async {
                            await buyButtonPressed(product);
                          },
                    child: const Text("Buy"),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/sellForm');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> buyButtonPressed(DocumentSnapshot document) async {
    // TODO: Add payment gateway thingy

    await firestore
        .collection('market')
        .doc(document.id)
        .set({"buyerUuid": auth.currentUser!.uid}, SetOptions(merge: true));
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      "orderHistory": FieldValue.arrayUnion([document.id])
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Purchase successful!"),
      ),
    );
  }
}
