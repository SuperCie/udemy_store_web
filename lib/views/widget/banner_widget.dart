import 'package:flutter/material.dart';
import 'package:store_app_web/controller/banner_controller.dart';
import 'package:store_app_web/models/banner.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  // A Future that will hold the list of banners once loaded from the API
  Future<List<BannerModel>>? futureBanners;

  @override
  void initState() {
    super.initState();
    futureBanners = BannerController().fetchBanner();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureBanners,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Banners Data'));
        } else {
          final banners = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            shrinkWrap: true,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final bannersData = banners[index];
              return Image.network(bannersData.image, width: 40, height: 40);
            },
          );
        }
      },
    );
  }
}
