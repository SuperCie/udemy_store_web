import 'package:flutter/material.dart';
import 'package:store_app_web/controller/subcategory_controller.dart';
import 'package:store_app_web/models/subcategory.dart';

class SubcategoryWidget extends StatefulWidget {
  const SubcategoryWidget({super.key});

  @override
  State<SubcategoryWidget> createState() => _SubcategoryWidgetState();
}

class _SubcategoryWidgetState extends State<SubcategoryWidget> {
  Future<List<Subcategory>>? futureAll;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureAll = SubcategoryController().fetchSubcategory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureAll,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Data is empty'));
        } else {
          final data = snapshot.data!;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: data.length,
            shrinkWrap: true,

            itemBuilder: (context, index) {
              final subData = data[index];
              return Column(
                children: [
                  Text('Category : ${subData.categoryName}'),
                  Image.network(subData.image, width: 100, height: 100),
                  Text('Name : ${subData.subCategoryName}'),
                ],
              );
            },
          );
        }
      },
    );
  }
}
