import 'package:flutter/material.dart';
import 'package:hive_database/models/constant.dart' as c;
import 'package:hive_database/models/post_model.dart';
import 'package:hive_database/screens/post_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
  await Hive.openBox<Post>(c.postBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Data With Hive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PostScreen(),
    );
  }
}
