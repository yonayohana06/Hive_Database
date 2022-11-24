import 'package:flutter/material.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/models/post_model.dart';
import 'package:hive_database/screens/post_add.dart';

class PostDetail extends StatefulWidget {
  final Post post;
  const PostDetail({super.key, required this.post});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  late Post _post;

  @override
  void initState() {
    _post = widget.post;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_post.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostAdd(
                    post: _post,
                    onClickedDone: (title, author, content) {
                      editPost(_post, title, author, content);
                    },
                  ),
                ),
              ).then((result) {
                if (result != null && result is Post) {
                  setState(() {
                    _post = result;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(milliseconds: 500),
                      backgroundColor: Colors.green,
                      content: Text('Post Updated'),
                    ),
                  );
                }
              });
            },
            icon: const Icon(
              Icons.edit,
              size: 24.0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _post.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _post.author,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _post.content,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
    );
  }

  void editPost(
    Post post,
    String title,
    String author,
    String content,
  ) {
    final box = Boxes.getPosts();
    title;
    author;
    content;
    box.put(widget.post.id, post);
  }
}
