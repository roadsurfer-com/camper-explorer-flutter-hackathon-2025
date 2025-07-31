import 'package:flutter/material.dart';

class FeatureDetailPage extends StatelessWidget {
  final String feature;

  const FeatureDetailPage({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(feature)),
      body: Center(
        child: Text(
          'More info about $feature',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
