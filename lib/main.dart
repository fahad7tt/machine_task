import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_task/logic/posts_bloc/posts_event.dart';
import 'data/repositories/posts_repository.dart';
import 'logic/posts_bloc/posts_bloc.dart';
import 'presentation/screens/posts_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => PostsBloc(PostsRepository())
          ..add(LoadInitialPosts()),
        child: const PostsScreen(),
      ),
    );
  }
}