import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:store_app_web/controller/banner_controller.dart';
import 'package:store_app_web/views/widget/banner_widget.dart';

class UpbannerScreen extends StatefulWidget {
  static const String routeName = '\bannerscreen';

  const UpbannerScreen({super.key});

  @override
  State<UpbannerScreen> createState() => _UpbannerScreenState();
}

class _UpbannerScreenState extends State<UpbannerScreen> {
  final BannerController _bannerController = BannerController();
  dynamic _bannerData;
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Banners',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
          ),
          Divider(color: Colors.grey),
          Row(
            children: [
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  await _bannerController.uploadBanner(
                    pickedImage: _bannerData,
                    context: context,
                  );
                  print('Uploaded');
                },
                child: Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          BannerWidget(),
        ],
      ),
    );
  }
}
