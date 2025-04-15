import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '\categoryscreen';

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late String categoryName;
  dynamic _imageData;
  dynamic _bannerData;

  Future<void> pickImage() async {
    try {
      final resultImage = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (resultImage != null) {
        setState(() {
          _imageData = resultImage.files.first.bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      print('Error picking image: $e');
    }
  }

  Future<void> pickBanner() async {
    try {
      final resultBanner = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (resultBanner != null) {
        setState(() {
          _bannerData = resultBanner.files.first.bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _globalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
            ),
            Divider(color: Colors.grey),
            Row(
              children: [
                //banner
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child:
                              _bannerData != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.memory(_bannerData),
                                  )
                                  : Text('Category Banner'),
                        ),
                      ),
                    ),
                    //button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () => pickBanner(),
                      child: Text(
                        'Upload Banner',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                // image
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child:
                              _imageData != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.memory(_imageData),
                                  )
                                  : Text('Category Image'),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () => pickImage(),
                      child: Text(
                        'Upload Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                // form field
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    onChanged: (value) {
                      categoryName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter category name';
                      } else {
                        categoryName = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      label: Text('Enter Category Name'),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // cancel and save button
                ElevatedButton(onPressed: () {}, child: Text('Cancel')),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    try {
                      if (_globalKey.currentState!.validate()) {
                        print(categoryName);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error Button: $e')),
                      );
                      print('Error Button: $e');
                    }
                  },
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            // pick button
            SizedBox(height: 10),
            Divider(color: Colors.grey),
            Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
            ),
          ],
        ),
      ),
    );
  }
}
