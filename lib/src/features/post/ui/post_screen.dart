import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/post_bloc.dart'; // Assurez-vous que le chemin est correct
import '../logic/post_state.dart'; // Assurez-vous que le chemin est correct
import '../logic/post_event.dart'; // Assurez-vous que le chemin est correct
import '../../../datasource/repositories/post_repository.dart'; // Importez le PostRepository
import '../../../shared/locator.dart'; // Importez votre locator
import 'package:flutter_kit/src/core/routing/app_router.dart'; 

@RoutePage()
class PostScreen extends StatefulWidget implements AutoRouteWrapper {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(postRepository: locator<PostRepository>())..add(FetchPosts()),
      child: this,  // Assure-toi que le BlocProvider est bien placé ici
    );
  }
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: SafeArea(
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PostLoaded) {
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return ListTile(
                    title: Text(post.title), // Titre du post
                    subtitle: Text(post.body), // Contenu du post
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Logique pour modifier un post
                             context.router.push( EditPostRoute(post: post));
                            print("88888888888");
                            print(post.id);
                            // context.read<PostBloc>().add(UpdatePost());
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Logique pour supprimer un post
                            context.read<PostBloc>().add(DeletePost(post.id));
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is PostError) {
              return Center(
                child: Text('Failed to load posts: ${state.error}'),
              );
            } else {
              return const Center(
                child: Text('Press the button to load posts.'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logique pour ajouter un nouveau post
           context.router.push(AddPostRoute());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
