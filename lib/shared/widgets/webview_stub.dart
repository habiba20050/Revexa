import 'package:flutter/material.dart';

class AppWebView extends StatelessWidget {
  final String url;
  const AppWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Platform not supported'));
  }
}
