// add_post_screen.dart

 import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kit/gen/assets.gen.dart';
import 'package:flutter_kit/src/core/i18n/l10n.dart';
import 'package:flutter_kit/src/core/theme/dimens.dart';
import 'package:flutter_kit/src/datasource/repositories/post_repository.dart';
import 'package:flutter_kit/src/features/post/logic/post_bloc.dart'; // PostCubit for managing post logic
import 'package:flutter_kit/src/features/post/logic/post_state.dart';
import 'package:flutter_kit/src/features/post/logic/post_event.dart';

import 'package:flutter_kit/src/shared/components/buttons/button.dart';
import 'package:flutter_kit/src/shared/components/dialogs/dialog_builder.dart';
import 'package:flutter_kit/src/shared/components/forms/input.dart';
import 'package:flutter_kit/src/shared/components/gap.dart';
import 'package:flutter_kit/src/shared/extensions/context_extensions.dart';
import '../../../datasource/models/post_model.dart'; // Importez votre modèle de post
import 'package:flutter_kit/src/shared/locator.dart';

import 'package:flutter_kit/src/core/routing/app_router.dart';


@RoutePage()
class AddPostScreen extends StatefulWidget implements AutoRouteWrapper {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(postRepository: locator<PostRepository>()),
      child: this,
    );
  }
}

class _AddPostScreenState extends State<AddPostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostLoading) {
          LoadingDialog.show(context: context);
        } else if (state is PostLoaded) {
          LoadingDialog.hide(context: context);
          context.router.pop(); // Naviguer en arrière après un post réussi
        } else if (state is PostError) {
          LoadingDialog.hide(context: context);
          // Afficher une boîte de dialogue d'erreur
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(I18n.of(context).error),
              content: Text(state.error.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(I18n.of(context).ok),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(Dimens.spacing),
            children: [
              const Gap.vertical(height: Dimens.tripleSpacing),
              Text(
                I18n.of(context).add_post_title,
                style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap.vertical(height: Dimens.minSpacing),
              Text(I18n.of(context).add_post_subtitle, style: context.textTheme.bodyMedium),
              const Gap.vertical(height: Dimens.doubleSpacing),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Input(
                      controller: _titleController,
                      labelText: I18n.of(context).post_title_label,
                      hintText: I18n.of(context).post_title_hint,
                      textInputAction: TextInputAction.next,
                    ),
                    const Gap.vertical(height: Dimens.spacing),
                    Input(
                      controller: _contentController,
                      labelText: I18n.of(context).post_content_label,
                      hintText: I18n.of(context).post_content_hint,
                      maxLines: 5,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _onSubmitPost(),
                    ),
                  ],
                ),
              ),
              const Gap.vertical(height: Dimens.spacing),
              Button.primary(
                title: I18n.of(context).post_submit_btn_label,
                onPressed: _onSubmitPost,
              ),
              const Gap.vertical(height: Dimens.doubleSpacing),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmitPost() {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        id: hashCode,
        title: _titleController.text,
        body: _contentController.text,
      );
      context.read<PostBloc>().add(CreatePost(post));
    }
  }
}
