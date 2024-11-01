import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannersListWidgets extends StatefulWidget {
  BannersListWidgets({super.key});

  @override
  State<BannersListWidgets> createState() => _BannersListWidgetsState();
}

class _BannersListWidgetsState extends State<BannersListWidgets> {
  final Stream<QuerySnapshot> _bannersStream =
      FirebaseFirestore.instance.collection('banners').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bannersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        return GridView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 6,mainAxisExtent: 125),
            itemBuilder: (context, index) {
              final bannersData = snapshot.data!.docs[index];
              return Column(
                children: [
                  Image.network(
                    bannersData["image"],
                    height: 100,
                    width: 100,
                  ),
                //  SizedBox(height: 25,),
                  
                ],
              );
            });
      },
    );
  }
}
