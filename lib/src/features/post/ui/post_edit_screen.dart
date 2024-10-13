import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/post_bloc.dart'; // Assurez-vous que le chemin est correct
import '../logic/post_event.dart'; // Assurez-vous que le chemin est correct
import '../logic/post_state.dart'; // Assurez-vous que le chemin est correct
import '../../../datasource/repositories/post_repository.dart'; // Importez le PostRepository
import '../../../shared/locator.dart'; // Importez votre locator
import '../../../datasource/models/post_model.dart'; // Importez votre modèle de post

@RoutePage()
class EditPostScreen extends StatefulWidget implements AutoRouteWrapper {
  final Post post;

  const EditPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();

  @override
 Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(postRepository: locator<PostRepository>()),
      child: this,
    );
  }
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _bodyController = TextEditingController(text: widget.post.body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostUpdateSuccess) {
          // Affiche un message de succès
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post updated successfully!')),
          );
          Navigator.pop(context); // Retourne à l'écran précédent après la mise à jour
        } else if (state is PostUpdateFailure) {
          // Affiche un message d'erreur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update post.')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Post'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(labelText: 'Body'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter body text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedPost = Post(
                        id: widget.post.id,
                        title: _titleController.text,
                        body: _bodyController.text,
                      );

                      // Ajoute l'événement de mise à jour
                      context.read<PostBloc>().add(UpdatePost(widget.post.id, updatedPost));
                      print("**click***");
                      Navigator.pop(context); 
                    }
                  },
                  child: const Text('Update Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 