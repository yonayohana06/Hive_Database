import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 1)
class Post extends HiveObject {
  final int id;
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final String content;

  Post(
    this.title,
    this.author,
    this.content, {
    this.id = 0,
  });
}
