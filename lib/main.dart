import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/call_screen.dart';
import 'view_model/call_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final callViewModel = CallViewModel();
  await callViewModel.initializeCameras();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => callViewModel),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Call Console',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CallScreen(),
    );
  }
}
