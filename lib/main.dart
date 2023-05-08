import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'NotesApp.dart';
import 'Provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
  await Hive.openBox("Notes");
 
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotesApp(),
      child: MaterialApp(theme: ThemeData(primarySwatch: Colors.teal),
        title: 'Notes App',
        home: NotesScreen(),
      ),
    );
  }
}

