import 'package:book_store_ma/gql/graphql_client.dart';
import 'package:book_store_ma/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<void> main() async {
  await initHiveForFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphqlConfig.initializeClient(),
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
