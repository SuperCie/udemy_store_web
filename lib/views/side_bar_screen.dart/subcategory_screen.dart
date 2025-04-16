import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:store_app_web/controller/category_controller.dart';
import 'package:store_app_web/controller/subcategory_controller.dart';
import 'package:store_app_web/models/category.dart';
import 'package:store_app_web/views/widget/subcategory_widget.dart';

class SubcategoryScreen extends StatefulWidget {
  static const String routeName = '\subcategoryscreen';

  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final SubcategoryController _subcategoryController = SubcategoryController();
  Future<List<Category>>? futureCategories;
  Category? _selectedCategory;
  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().fetchCategory();
  }

  late String nameData;
  dynamic _imageData;
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subcategories',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              ),
              Divider(color: Colors.grey),
              FutureBuilder(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.data!.isEmpty) {
                    return Center(child: Text('No Data'));
                  } else {
                    return DropdownButton<Category>(
                      value: _selectedCategory,
                      hint: Text('Select Category'),
                      items:
                          snapshot.data!.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category.name),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    );
                  }
                },
              ),
              Row(
                children: [
                  //
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
                                    : Text('Subcategory'),
                          ),
                        ),
                      ),
                      //button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () => pickImage(),
                        child: Text(
                          'Upload Subcategory',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  // image
                  SizedBox(width: 20),
                  // form field
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      onChanged: (value) {
                        nameData = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter category name';
                        } else {
                          nameData = value;
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      try {
                        if (_globalKey.currentState!.validate()) {
                          _subcategoryController.uploadSubcategory(
                            categoryId: _selectedCategory!.id,
                            categoryName: _selectedCategory!.name,
                            pickedImage: _imageData,
                            subCategoryName: nameData,
                            context: context,
                          );
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
              Divider(color: Colors.grey),
              SubcategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
