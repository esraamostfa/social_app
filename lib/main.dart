import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/chats/chats_cubit.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/cubit_observer.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();

  await CacheHelper.init();
  uId = CacheHelper.getData('uId');

  Widget widget;
  if (uId != null)
    widget = HomeLayout();
  else
    widget = LoginScreen();

  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  MyApp(this.startWidget);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers:
    [
      BlocProvider(create: (context) => SocialCubit()..getUserData()..getPosts()),
      BlocProvider(create: (context) => ChatsCubit()..getAllUser())
    ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: startWidget,
    ),);
  }
}
