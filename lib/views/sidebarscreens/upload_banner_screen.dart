import 'package:app_web/views/sidebarscreens/widgets/banners_list_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UploadBannerScreen extends StatefulWidget {
  static const String id = "\banner-screen";

  const UploadBannerScreen({super.key});

  @override
  State<UploadBannerScreen> createState() => _UploadBannerScreenState();
}

class _UploadBannerScreenState extends State<UploadBannerScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // final TextEditingController _categoryNameController = TextEditingController();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  dynamic _image;
  String? fileName;

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  } // picking image from your device

  _uploadImageToFireBaseStorage(dynamic image) async {
    Reference ref = _firebaseStorage.ref().child("banners").child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    // getting image link to be used on firestore
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } // uploading image to firestorebusket

  uploadToFireStore() async {
   if (_image != null) {
        EasyLoading.show();
        String imageUrl = await _uploadImageToFireBaseStorage(_image);
        await _firebaseFirestore.collection("banners").doc(fileName).set({
          "image": imageUrl,
        }).whenComplete(() {
          EasyLoading.dismiss();
          _image = null;
        });
      } else {
        EasyLoading.dismiss();
      }
  } //uploading to firestore firebase

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Banners",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(children: [
            Column(
              children: [
                Container(
                  height: 140,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: _image != null
                        ? Image.memory(_image)
                        : const Text(
                            "Upload Image",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * .02,
                ),
                ElevatedButton(
                    onPressed: () {
                      pickImage();
                    },
                    child: const Text(
                      "Upload Image",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
            const SizedBox(
              width: 30,
            ),
            TextButton(
                style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    side: WidgetStatePropertyAll(
                        BorderSide(color: Colors.blue.shade900))),
                onPressed: () {
                  uploadToFireStore();
                },
                child: const Text("Save"))
          ]),
      BannersListWidgets(),
        ],
      ),
    );
  }
}
