import 'package:flutter/material.dart';
import 'package:hive_database/models/post_model.dart';

class PostAdd extends StatefulWidget {
  final Post? post;
  final Function(String title, String author, String content) onClickedDone;
  const PostAdd({super.key, this.post, required this.onClickedDone});

  @override
  State<PostAdd> createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  final formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController(text: 'Yona');
  final _content = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      final post = widget.post!;

      _title.text = post.title;
      _author.text = post.author;
      _content.text = post.content;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.post != null;
    final title = isEditing ? 'Edit Post' : 'Add Post';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Type your title here',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (title) {
                    if (title == null || title.isEmpty) {
                      return 'Enter a title';
                    }
                    if (title.length < 6) {
                      return 'Too short';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
                TextFormField(
                  enabled: false,
                  controller: _author,
                  decoration: const InputDecoration(
                    labelText: 'Author',
                    hintText: 'Type your title here',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _content,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    alignLabelWithHint: true,
                    labelText: 'Content',
                    hintText: 'Type your content here',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (content) {
                    if (content == null || content.isEmpty) {
                      return 'Enter a content';
                    }
                    if (content.length < 6) {
                      return 'Too short';
                    }
                    return null;
                  },
                  minLines: 6,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 20),
                postAddButton(context, isEditing: isEditing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget postAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Submit';

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(100, 40),
      ),
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final title = _title.text;
          final author = _author.text;
          final content = _content.text;

          widget.onClickedDone(title, author, content);

          Navigator.of(context).pop(Post(title, author, content));
        }
      },
    );
  }
}
