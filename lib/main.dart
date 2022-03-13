import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/SocialApp/Cubit/cubit.dart';
import 'package:social_app/layout/SocialApp/SocialLayout.dart';
import 'package:social_app/module/LoginPage/Login.dart';
import 'package:social_app/module/onBordingPage/onBording.dart';
import 'package:social_app/shared/Cubit/cubit.dart';
import 'package:social_app/shared/componants/componants.dart';
import 'package:social_app/shared/componants/constants.dart';
import 'package:social_app/shared/network/local/CachHelper.dart';
import 'package:social_app/shared/network/remote/DioHelper.dart';
import 'package:social_app/shared/style/Themes.dart';
import 'shared/Cubit/states.dart';
import 'shared/bloc_observer.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message');
  print(message.data.toString());

  // Get.snackbar('Notfication', 'on background message',
  //     backgroundColor: Colors.black, colorText: Colors.white);
  showTast(
    text: 'on background message',
    state: ToastStates.SUCCESS,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();

  print(token);

  // foreground fcm
  FirebaseMessaging.onMessage.listen((event) {
    print('on message');
    print(event.data.toString());

    Get.snackbar('Notfication', 'on message',
        backgroundColor: Colors.black, colorText: Colors.white);
    // showTast(
    //   text: 'on message',
    //   state: ToastStates.SUCCESS,
    // );
  });

  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());

    Get.snackbar('Notfication', 'on message opened app',
        backgroundColor: Colors.black, colorText: Colors.white);
    // showTast(
    //   text: 'on message opened app',
    //   state: ToastStates.SUCCESS,
    // );
  });

  // background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  late bool? isDark = CacheHelper.getData(key: 'isDark');
  Widget widget;
  late bool? isBoarding = CacheHelper.getData(key: 'onBoarding');
  uid = CacheHelper.getData(key: 'uid');
  //(token!);
  if (isBoarding != null) {
    // ignore: unnecessary_null_comparison
    if (uid != null) {
      widget = SocialLayout();
    } else {
      widget = LoginShopScreen();
    }
  } else {
    widget = OnBordingScreen();
  }
  runApp(MyApp(
    isDark: (isDark != null) ? isDark : false,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  MyApp({required this.isDark, required this.startWidget});

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()..changeMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (context) => SocialCubit()
            ..getUser()
            ..getPosts(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return GetMaterialApp(
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: AppCubit.get(context).isDarke
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: startWidget,
          );
        },
      ),
    );
  }
}

// ./gradlew signingReport
