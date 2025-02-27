import 'package:base_style_sheet/base_style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter StyleSheet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Storybook(
        stories: [
          Story(
            name: 'CustomWebView',
            builder: (context) {
              return CustomWebView(url: '');
            },
          ),
          Story(
            name: 'CustomButton',
            builder: (context) {
              return SafeArea(
                child: Column(
                  children: [
                    CustomButton.icon(icon: Icons.close_rounded),
                    Spacing.sm.vertical,
                    CustomButton.text(text: 'Text'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
