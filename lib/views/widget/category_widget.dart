import 'package:flutter/material.dart';
import 'package:store_app_web/controller/category_controller.dart';
import 'package:store_app_web/models/category.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  // A Future that will hold the list of banners once loaded from the API
  Future<List<Category>>? futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Categories Data'));
        } else {
          final categories = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final categoriesData = categories[index];
              return Column(
                children: [
                  Image.network(categoriesData.image, width: 100, height: 100),
                  Text(categoriesData.name),
                ],
              );
            },
          );
        }
      },
    );
  }
}
