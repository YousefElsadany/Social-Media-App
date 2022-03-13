import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/SocialApp/Cubit/cubit.dart';
import 'package:social_app/layout/SocialApp/Cubit/states.dart';
import 'package:social_app/model/UserModel.dart';
import 'package:social_app/module/ChatDetailsPage/ChatDetailse.dart';
import 'package:social_app/shared/componants/componants.dart';

import 'package:social_app/shared/style/colors.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(context, cubit.users[index]),
            separatorBuilder: (context, index) => customLine(margin: 12.0),
            itemCount: cubit.users.length,
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

Widget buildChatItem(context, UserModel model) => InkWell(
      onTap: () {
        Get.to(ChatDetailsScreen(model));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 29.0,
              backgroundImage: NetworkImage(
                '${model.image}',
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 16.0,
                          height: 1.4,
                        ),
                  ),

                  // Text(

                  //   '',

                  //   style: Theme.of(context).textTheme.caption!.copyWith(

                  //         height: 1.4,

                  //       ),

                  // ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
