import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../datasource/repositories/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';
// import '../../../datasource/models/api_response/api_response.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;

  PostBloc({required PostRepository postRepository}) 
    : _postRepository = postRepository,
      super(PostInitial()) {

    // Gestion de l'événement FetchPosts
    on<FetchPosts> ((event, emit)  async {
      emit(PostLoading());

      // Appel au repository pour récupérer les posts
      final response = await _postRepository.getPosts();

      // Gestion de la réponse via when
      response.when(
        success: (posts) {
          emit(PostLoaded(posts: posts)); // État lorsque les posts sont chargés
        },
        error: (apiError) {
          emit(PostError(error: apiError)); // Passe l'objet ApiError au lieu d'un string
        },
      );
    });

    // Gestion de l'événement CreatePost
    on<CreatePost>((event, emit) async {
      final response = await _postRepository.createPost(event.post);

      response.when(
        success: (post) {
          add(FetchPosts()); // Recharge la liste après ajout
        },
        error: (apiError) {
          emit(PostError(error: apiError)); // Passe l'objet ApiError
        },
      );
    });

    // Gestion de l'événement UpdatePost
    on<UpdatePost>((event, emit) async {
      final response = await _postRepository.updatePost(event.id, event.post);

      response.when(
        success: (post) {
          add(FetchPosts()); // Recharge la liste après mise à jour
        },
        error: (apiError) {
          emit(PostError(error: apiError)); // Passe l'objet ApiError
        },
      );
    });

    // Gestion de l'événement DeletePost
    on<DeletePost>((event, emit) async {
      final response = await _postRepository.deletePost(event.id);

      response.when(
        success: (_) {
          add(FetchPosts()); // Recharge la liste après suppression
        },
        error: (apiError) {
          emit(PostError(error: apiError)); // Passe l'objet ApiError
        },
      );
    });

    // Gestion de l'événement FetchPosts
    // on<FetchPosts>((event, emit) async {
    //   emit(PostLoading());

    //   final response = await _postRepository.getPosts();

    //   response.when(
    //     success: (posts) {
    //       emit(PostLoaded(posts: posts));
    //     },
    //     error: (apiError) {
    //       emit(PostError(error: apiError));
    //     },
    //   );
    // });
  }
}
