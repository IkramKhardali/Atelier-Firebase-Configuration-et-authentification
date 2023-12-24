import 'package:atelier4_i_khardali_iir5g1/addproduct.dart';
import 'package:atelier4_i_khardali_iir5g1/produit.dart';
import 'package:atelier4_i_khardali_iir5g1/register.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class list_produits extends StatefulWidget {
  const list_produits({Key? key}) : super(key: key);

  @override
  _list_produitsState createState() => _list_produitsState();
}

class _list_produitsState extends State<list_produits> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Produits'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('produits').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Une Erreur est survenue'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Produit> produits = snapshot.data!.docs.map((doc) {
            return Produit.fromFirestore(doc);
          }).toList();

          return ListView.builder(
              itemCount: produits.length,
              itemBuilder: (context, index) => ProduitItem(
                    produit: produits[index],
                  ));
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductForm()),
              );
            },
            child: Icon(Icons.add),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
            child: Icon(Icons.person_add),
          ),
        ],
      ),
    );
  }
}

class ProduitItem extends StatelessWidget {
  ProduitItem({Key? key, required this.produit}) : super(key: key);
  final Produit produit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: SizedBox(
          width: 80,
          height: 80,
          child: produit.photo != null
              ? Image.network(
                  produit.photo!,
                  fit: BoxFit
                      .cover, // Adjusts the image to cover the entire space
                )
              : Placeholder(), // Placeholder if photo URL is null
        ),
        title: Text(
          produit.designation,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(produit.marque),
            SizedBox(height: 4),
            Text(
              '${produit.prix} €',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: Icon(Icons.delete_outline),
        onTap: () {
          // Implement delete functionality here or use it elsewhere
          deleteProduct(
              produit.id); // Call the deleteProduct method with the product ID
        },
      ),
    );
  }
}

class ListProduits extends StatefulWidget {
  const ListProduits({Key? key}) : super(key: key);

  @override
  _ListProduitsState createState() => _ListProduitsState();
}

class _ListProduitsState extends State<ListProduits> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Produits'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('produits').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Une erreur est survenue'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<Produit> produits = snapshot.data!.docs.map((doc) {
            return Produit.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            itemCount: produits.length,
            itemBuilder: (context, index) => ProduitItem(
              produit: produits[index],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            addNewProduct, // Call addProduct when FloatingActionButton is pressed
        child: Icon(Icons.add),
      ),
    );
  }
}

 
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(
    home: list_produits(),
  ));
}
*/

