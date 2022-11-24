import 'package:flutter/material.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/models/post_model.dart';
import 'package:hive_database/screens/post_add.dart';
import 'package:hive_database/screens/post_detail.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database - Post'),
      ),
      body: ValueListenableBuilder<Box<Post>>(
        valueListenable: Boxes.getPosts().listenable(),
        builder: (context, box, _) {
          final posts = box.values
              .map((e) {
                final newPost = Post(
                  e.title,
                  e.author,
                  e.content,
                  id: e.key,
                );
                return newPost;
              })
              .toList()
              .cast<Post>();

          if (posts.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(child: Text('No Posts')),
                Center(child: Text('Add some data!')),
              ],
            );
          }
          return postContent(posts);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostAdd(
                onClickedDone: addPost,
              ),
            ),
          ).then((result) {
            if (result != null && result is Post) {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(milliseconds: 500),
                  backgroundColor: Colors.green,
                  content: Text('Post Created'),
                ),
              );
            }
          });
        },
      ),
    );
  }

  Widget postContent(List<Post> posts) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
        bottom: 80,
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = posts[index];

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: ListTile(
            title: Text(
              post.title,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Author : ${post.author}',
              style: const TextStyle(
                height: 2,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PostDetail(post: post),
              ),
            ),
            trailing: GestureDetector(
              onTap: () async {
                await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete ${post.title}'),
                    content: Text(
                      'Are you sure want to delete ${post.title} ?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          deletePost(post);
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(
                                const Duration(seconds: 1),
                                () => Navigator.pop(context),
                              );
                              return AlertDialog(
                                title: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.green,
                                  size: 40.0,
                                ),
                                content: Text(
                                  'Succesfully deleted ${post.title}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 24.0,
              ),
            ),
          ),
        );
      },
    );
  }

  Future addPost(String title, String author, String content) async {
    final post = Post(title, author, content)
      ..title
      ..author
      ..content;

    final box = Boxes.getPosts();
    box.add(post);
  }

  void deletePost(Post post) {
    final box = Boxes.getPosts();
    // box.delete(post.key);

    box.delete(post.id);
    //setState(() => post.remove(post));
  }
}
