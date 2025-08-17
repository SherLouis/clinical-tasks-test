import 'package:flutter/material.dart';
import 'package:task_test_app/utils/app_sizes.dart';

class MaterialViewer extends StatelessWidget {
  final List<String> imagePaths;
  final String title;

  const MaterialViewer({
    super.key,
    required this.imagePaths,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final lowerTitle = title.toLowerCase();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: imagePaths.isEmpty
          ? Center(
              child: Text(
                'No $lowerTitle available',
                style: TextStyle(fontSize: AppSizes.fontSize(context)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imagePaths.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '$title ${index + 1}',
                            style: TextStyle(
                              fontSize: AppSizes.fontSize(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          imagePaths[index],
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
