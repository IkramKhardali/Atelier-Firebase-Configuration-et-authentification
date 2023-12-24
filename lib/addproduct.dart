import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _marque;
  String? _designation;
  String? _categorie;
  double? _prix;
  String? _photoUrl;
  int? _quantite;

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Widget _displayImage() {
    if (_image != null) {
      if (kIsWeb) {
        // For web, use Image.network to display the image
        return Image.network(
          _image!.path,
          height: 150,
        );
      } else {
        // For mobile, use Image.memory to display the image
        return Image.memory(
          File(_image!.path).readAsBytesSync(),
          height: 150,
        );
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Marque',
                  border: OutlineInputBorder(),
                  hintText: 'Enter product brand',
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter the product brand'
                    : null,
                onSaved: (value) => _marque = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Designation',
                  border: OutlineInputBorder(),
                  hintText: 'Enter product designation',
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter the product designation'
                    : null,
                onSaved: (value) => _designation = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  hintText: 'Enter product category',
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter the product category'
                    : null,
                onSaved: (value) => _categorie = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  hintText: 'Enter product price',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                        ? 'Please enter a valid price'
                        : null,
                onSaved: (value) => _prix = double.parse(value!),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick an Image'),
              ),
              SizedBox(height: 16),
              _displayImage(),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                  hintText: 'Enter product quantity',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                        ? 'Please enter a valid quantity'
                        : null,
                onSaved: (value) => _quantite = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      // Perform the database insertion here using _firestore
      // Include the _image!.path (path of the picked image) in your Firestore data
      _firestore.collection('produits').add({
        'marque': _marque,
        'designation': _designation,
        'categorie': _categorie,
        'prix': _prix,
        'photoUrl': _image != null ? _image!.path : null,
        'quantite': _quantite,
      }).then((value) {
        // Handle successful insertion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added successfully'),
          ),
        );
      }).catchError((error) {
        // Handle errors during insertion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add product: $error'),
          ),
        );
      });
    }
  }
}
