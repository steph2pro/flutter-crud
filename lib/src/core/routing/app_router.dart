import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart'; 
import '../../datasource/models/post_model.dart'; 
import 'package:flutter_kit/src/features/login/ui/login_screen.dart';
import 'package:flutter_kit/src/features/user/ui/user_screen.dart';
import 'package:flutter_kit/src/features/post/ui/post_screen.dart';
import 'package:flutter_kit/src/features/post/ui/post_edit_screen.dart';
import 'package:flutter_kit/src/features/post/ui/post_add_screen.dart';

part 'app_router.gr.dart'; // Assurez-vous que cela est correct

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> routes = [
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(page: UserRoute.page),
    AutoRoute(page: PostRoute.page),
    AutoRoute(page: EditPostRoute.page),
    AutoRoute(page: AddPostRoute.page),
  ];
}
