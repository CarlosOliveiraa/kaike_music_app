import 'package:flutter/material.dart';
import 'package:kaike_music_app/design_system/theme/theme.dart';
import 'package:kaike_music_app/main.dart';
import 'package:kaike_music_app/presentation/pages/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaike Music App',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
