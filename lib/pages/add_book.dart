import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  final String addBookMutation = """

    mutation addMutation(\$title: String!, \$authorId: ID) {
      addBook(title: \$title, authorId: \$authorId) {
        title
        author {
          name
        }
      }
    }

  """;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _authorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Book'),
      ),
      body: Mutation(
          options: MutationOptions(document: gql(addBookMutation)),
          builder: (RunMutation, reasult) {
            if (reasult?.hasException ?? false) {
              return Center(
                child: Text(reasult?.exception.toString() ?? 'Unkonwn error'),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 10,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter book title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _authorController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please enter author name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final title = _titleController.text;
                          final author = _authorController.text;

                          RunMutation({
                            "title": title,
                            "authorId": author,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Book Added Sucessfully')));
                          _titleController.clear();
                          _authorController.clear();
                        }
                        return;
                      },
                      child: Text('SUBMIT'),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
