import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatefulWidget {
  CategoryListWidget({super.key});

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  final Stream<QuerySnapshot> _categoriesStream =
      FirebaseFirestore.instance.collection('category').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GridView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 6,
                mainAxisExtent: 125),
            itemBuilder: (context, index) {
              final categoryData = snapshot.data!.docs[index];
              return Column(
                children: [
                  Image.network(
                    categoryData["categoryImage"],
                    height: 100,
                    width: 100,
                  ),
                  //  SizedBox(height: 25,),
                  Text(
                    categoryData["categoryName"],
                  ),
                ],
              );
            });
      },
    );
  }
}
