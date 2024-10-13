import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/user_cubit.dart'; // Assurez-vous que le chemin est correct
import '../../../datasource/repositories/user_repository.dart'; // Importez le UserRepository
import '../../../shared/locator.dart'; // Importez votre locator


@RoutePage()
class UserScreen extends StatefulWidget implements AutoRouteWrapper {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();

   @override
   Widget wrappedRoute(BuildContext context) {
     return BlocProvider(
       create: (context) => UserCubit(userRepository: locator<UserRepository>())..loadUsers(),
       child: this,
     );
   }
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Users'), // Titre de la page
      ),
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(
                child: Text('Press the button to load users.'), // État initial
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(), // Affiche un loader pendant le chargement
              ),
              success: (users) => ListView.builder(
                itemCount: users.length, // Nombre d'utilisateurs dans la liste
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    leading: Image.network(user.pictureUrl), // Affiche l'image de l'utilisateur
                    title: Text(user.name), // Nom de l'utilisateur
                    subtitle: Text(user.email), // Email de l'utilisateur
                  );
                },
              ),
              error: (error) => Center(
                child: Text('Failed to load users: $error'), // Gestion des erreurs
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserCubit>().loadUsers(); // Recharger les utilisateurs en appuyant sur le bouton
        },
        child: const Icon(Icons.refresh), // Icône de rafraîchissement
      ),
    );
  }
}
