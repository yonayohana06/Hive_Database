import 'package:hive/hive.dart';
import 'package:hive_database/models/post_model.dart';
import 'package:hive_database/models/constant.dart' as c;

class Boxes {
  static Box<Post> getPosts() => Hive.box<Post>(c.postBox);
}
