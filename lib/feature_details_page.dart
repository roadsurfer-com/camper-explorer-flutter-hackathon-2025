import 'package:flutter/material.dart';

class FeatureDetailPage extends StatelessWidget {
  final String feature;
  final String imageAsset;
  final String subtitle;

  const FeatureDetailPage({
    super.key,
    required this.feature,
    required this.imageAsset,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(feature),),
      body: SingleChildScrollView(
        child:
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
