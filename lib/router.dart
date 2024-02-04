import 'package:flutter/material.dart';
import 'package:growgrid/features/auth/screens/login_screen.dart' show LoginScreen;
import 'package:growgrid/features/community/screens/add_mods_screen.dart' show AddModsScreen;
import 'package:growgrid/features/community/screens/community_screen.dart' show CommunityScreen;
import 'package:growgrid/features/community/screens/create_community_screen.dart' show CreateCommunityScreen;
import 'package:growgrid/features/community/screens/edit_community_screen.dart' show EditCommunityScreen;
import 'package:growgrid/features/community/screens/mod_tools_screen.dart' show ModToolsScreen;
import 'package:growgrid/features/home/screens/home_screen.dart' show HomeScreen;
import 'package:growgrid/features/post/screens/add_post_screen.dart' show AddPostScreen;
import 'package:growgrid/features/post/screens/add_post_type_screen.dart' show AddPostTypeScreen;
import 'package:growgrid/features/post/screens/comments_screen.dart' show CommentsScreen;
import 'package:growgrid/features/user_profile/screens/edit_profile_screen.dart' show EditProfileScreen;
import 'package:growgrid/features/user_profile/screens/user_profile_screen.dart' show UserProfileScreen;
import 'package:routemaster/routemaster.dart' show RouteMap;

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/mod-tools/:name': (routeData) => MaterialPage(
          child: ModToolsScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/edit-community/:name': (routeData) => MaterialPage(
          child: EditCommunityScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/add-mods/:name': (routeData) => MaterialPage(
          child: AddModsScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/add-post/:type': (routeData) => MaterialPage(
          child: AddPostTypeScreen(
            type: routeData.pathParameters['type']!,
          ),
        ),
    '/post/:postId/comments': (route) => MaterialPage(
          child: CommentsScreen(
            postId: route.pathParameters['postId']!,
          ),
        ),
    '/add-post': (routeData) => const MaterialPage(
          child: AddPostScreen(),
        ),
  },
);
