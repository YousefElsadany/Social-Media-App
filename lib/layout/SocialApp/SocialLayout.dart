import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/SocialApp/Cubit/states.dart';
import 'package:social_app/module/CreatePostPage/CreatePost.dart';

import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icon_broken.dart';

import 'Cubit/cubit.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var lauoutCubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                // Image.asset(
                //   'assets/images/logoapp.jpg',
                //   width: 50.0,
                //   height: 55.0,
                // ),
                Text(
                  'Social App',
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // ShopCubit.get(context).getNotifications();
                  // Get.to(NotificationsScreen());
                },
                icon: Icon(
                  IconBroken.Notification,
                  // color: Colors.grey[800],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () {
                    //Get.to(SeachScreen());
                  },
                  icon: Icon(
                    Icons.search,
                    // color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(CreatePostScreen());
            },
            child: Icon(IconBroken.Paper_Upload),
            backgroundColor: shopColor,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: lauoutCubit.bottomsIcons,
            activeIndex: lauoutCubit.currentIndex,
            onTap: (index) {
              lauoutCubit.changeNavBar(index);
            },
            activeColor: shopColor,
            gapLocation: GapLocation.end,
            notchSmoothness: NotchSmoothness.softEdge,
            iconSize: 27.0,
            // leftCornerRadius: 32,
            // rightCornerRadius: 32,
            backgroundColor: fullBackgroundColor,
          ),
          body: lauoutCubit.screen[lauoutCubit.currentIndex],
        );
      },
    );
  }
}
