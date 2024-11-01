import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductScreens extends StatefulWidget {
  static const String id = "\product-screen";

  const ProductScreens({super.key});

  @override
  State<ProductScreens> createState() => _ProductScreensState();
}

final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final List<String> _categoryNames = [];
String? selectedCategory;
final TextEditingController _sizeController = TextEditingController();
final GlobalKey<FormState> _formkey = GlobalKey();
String? productName;
double? productPrice;
int? productDiscount;
String? productDescribtion;
int? productQuantity;
bool isLoading = false;

class _ProductScreensState extends State<ProductScreens> {
  List<Uint8List> images = [];
  List<String> imagesUrl = [];
  bool isEntered = false;
  final List<String> _sizeList = [];

  chooseImage() async {
    final pickedImages = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (pickedImages == null) {
      print("No image picked");
    } else {
      for (var file in pickedImages.files) {
        setState(() {
          images.add(file.bytes!);
        });
      }
    }
  }

  getCategories() {
    return _firestore
        .collection("category")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _categoryNames.add(doc["categoryName"]);
        });
      }
    });
  }
  // fetching category names from the category collection

  _uploadImageToCloudFirestorage() async {
    for (var img in images) {
      Reference ref = _firebaseStorage
          .ref()
          .child("productImages")
          .child(const Uuid().v4());
      await ref.putData(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          setState(() {
            imagesUrl.add(value);
          });
        });
      });
    }
  }

  uploadDataToCloudFirestore() async {
    await _uploadImageToCloudFirestorage();
    setState(() {
      isLoading = true;
    });
    final productId = const Uuid().v4();
    if (images.isNotEmpty) {
      await _firestore.collection("products").doc(productId).set({
        "productId": productId,
        "productName": productName,
        "productPrice": productPrice,
        "productDiscount": productDiscount,
        "productDescribtion": productDescribtion,
        "productImage": imagesUrl,
        "productSize": _sizeList,
        "selectedCategory": selectedCategory,
        "productQuantity": productQuantity,
      }).whenComplete(() {
        setState(() {
          isLoading = false;
          _formkey.currentState!.reset();
          imagesUrl.clear();
          images.clear();
        });
      });
    }
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Product Information",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                onChanged: (value) {
                  productName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter field";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    label: const Text(
                      "Product Name",
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      onChanged: (value) {
                        productPrice = double.parse(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter field";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          label: const Text(
                            "Price",
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(child: buildDropDownField()),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  productDiscount = int.parse(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter field";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    label: const Text(
                      "Discount price",
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  productDescribtion = value;
                },
                maxLines: 3,
                maxLength: 500,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter field";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    label: const Text(
                      "Enter Describtion",
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  productQuantity = int.parse(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter field";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    label: const Text(
                      "quantity",
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _sizeController,
                        onChanged: (value) {
                          setState(() {
                            isEntered = true;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text(
                              "Add size",
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  isEntered == true
                      ? Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _sizeList.add(_sizeController.text);
                              });
                              _sizeController.clear();
                              print(_sizeList);
                            },
                            child: const Text("add"),
                          ),
                        )
                      : const Text("Enter size")
                ],
              ),
              _sizeList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 60,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _sizeList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _sizeList.removeAt(index);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade800,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _sizeList[index],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  : const Text(""),
              const SizedBox(
                height: 20,
              ),
              GridView.builder(
                  itemCount: images.length + 1,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? IconButton(
                            onPressed: () {
                              chooseImage();
                            },
                            icon: const Icon(Icons.add))
                        : Image.memory(images[index - 1]);
                  }),
              InkWell(
                onTap: () {
                  if (_formkey.currentState!.validate()) {
                    // upload product information to cloud firestore
                    uploadDataToCloudFirestore();
                    print("success");
                  } else {
                    print("bad status");
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(9)),
                  child: Center(
                      child: isLoading == true
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Upload Product",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropDownField() {
    return DropdownButtonFormField(
        decoration: InputDecoration(
            label: const Text(
              "Select category",
            ),
            fillColor: Colors.grey[200],
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        items: _categoryNames.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            if (value != null) {
              selectedCategory = value;
            }
          });
        });
  }
}
