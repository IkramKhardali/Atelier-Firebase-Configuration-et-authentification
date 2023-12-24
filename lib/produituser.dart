import 'package:atelier4_i_khardali_iir5g1/Userpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:atelier4_i_khardali_iir5g1/produit.dart';
import 'package:atelier4_i_khardali_iir5g1/register.dart';

class list_produits2 extends StatefulWidget {
  const list_produits2({Key? key}) : super(key: key);

  @override
  _list_produitsState2 createState() => _list_produitsState2();
}

class _list_produitsState2 extends State<list_produits2> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Produits'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage()),
              );
            },
          ),
        ],
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
              onFavoritePressed: () {
                // Implement adding to favorites here
                addToFavorites(produits[index].id);
              },
            ),
          );
        },
      ),
    );
  }

  void addToFavorites(String productId) {
    String userId = 'user_id'; // Replace with the actual user ID

    // Reference to the user's document
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Add the productId to the 'favorites' collection in the user document
    userRef.collection('favorites').doc(productId).set({
      'productId': productId,
      // You can include additional data related to the favorite product if needed
    }).then((_) {
      print('Product added to favorites successfully');
    }).catchError((error) {
      print('Failed to add product to favorites: $error');
    });
  }
}

class ProduitItem extends StatefulWidget {
  final Produit produit;
  final VoidCallback onFavoritePressed;

  ProduitItem({
    Key? key,
    required this.produit,
    required this.onFavoritePressed,
  }) : super(key: key);

  @override
  _ProduitItemState createState() => _ProduitItemState();
}

class _ProduitItemState extends State<ProduitItem> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentSnapshot favoriteDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(widget.produit.id)
        .get();

    setState(() {
      isFavorite = favoriteDoc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current authenticated user ID inside the build method
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: SizedBox(
          width: 80,
          height: 80,
          child: widget.produit.photo != null
              ? Image.network(
                  widget.produit.photo!,
                  fit: BoxFit.cover,
                )
              : Placeholder(),
        ),
        title: Text(
          widget.produit.designation,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.produit.marque),
            SizedBox(height: 4),
            Text(
              '${widget.produit.prix} €',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: IconButton(
          icon: isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
            // Call the addToFavorites function with the current userId
            addToFavorites(userId, widget.produit.id, isFavorite);
          },
        ),
      ),
    );
  }

  void addToFavorites(String userId, String productId, bool isFavorite) {
    // Reference to the user's document
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    if (isFavorite) {
      // Add the productId to the 'favorites' collection in the user document
      userRef.collection('favorites').doc(productId).set({
        'productId': productId,
        // You can include additional data related to the favorite product if needed
      }).then((_) {
        print('Product added to favorites successfully');
      }).catchError((error) {
        print('Failed to add product to favorites: $error');
      });
    } else {
      // Remove the productId from the 'favorites' collection in the user document
      userRef.collection('favorites').doc(productId).delete().then((_) {
        print('Product removed from favorites successfully');
      }).catchError((error) {
        print('Failed to remove product from favorites: $error');
      });
    }
  }
}
