import 'package:book_store_ma/pages/add_book.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // define the graphql queary to fetch books with authors
  final String fetchBooks = """
    query {
      books {
        id
        title
        author {
          name
          bio
        }
    }
}
  """;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBook()));
        },
        child: Icon(Icons.add),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(fetchBooks),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (result.hasException) {
            return Center(
              child: Text(result.exception.toString()),
            );
          }

          List books = result.data!["books"];
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final author = book['author'];
              return ListTile(
                title: Text(book['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${book['id']}',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text('Author: ${author['name']}'),
                    Text('Bio: ${author['bio']}')
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
