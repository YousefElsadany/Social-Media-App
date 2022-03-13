import 'dart:ui';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';
import 'package:social_app/layout/SocialApp/Cubit/cubit.dart';
import 'package:social_app/layout/SocialApp/Cubit/states.dart';
import 'package:social_app/model/CreatePostModel.dart';
import 'package:social_app/shared/componants/componants.dart';

import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var homeCubit = SocialCubit.get(context);
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.length > 0 &&
              SocialCubit.get(context).userModel != null,
          builder: (context) => SingleChildScrollView(
              child: Column(
            children: [
              Card(
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    Image(
                      image: NetworkImage(
                        'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg',
                      ),
                      fit: BoxFit.cover,
                      height: 200.0,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Communicate With Friends',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.all(8.0),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 8.0,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => buildPosts(
                    context, homeCubit.posts[index], index, commentsController),
                separatorBuilder: (context, index) => SizedBox(
                  height: 5.0,
                ),
                itemCount: SocialCubit.get(context).posts.length,
              ),
            ],
          )),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

TextEditingController commentsController = TextEditingController();
Widget buildPosts(context, CreatePostModel model, index,
        TextEditingController controller) =>
    Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 26.0,
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
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 16.0,
                                      height: 1.4,
                                    ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 18.0,
                          ),
                        ],
                      ),
                      Text(
                        '${model.dateTime}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              height: 1.4,
                            ),
                      ),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: customLine(margin: 8.0),
            ),
            HashTagText(
              text: '${model.text}',
              decoratedStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Colors.blue,
                  ),
              basicStyle: Theme.of(context).textTheme.subtitle1!,
              // onTap: (text) {
              //   print(text);
              // },
            ),
            SizedBox(
              height: 8.0,
            ),
            // if (SocialCubit.get(context).postImage != null)
            model.postImage!.isEmpty
                ? Container()
                : Container(
                    height: 160.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        4.0,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          '${model.postImage}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Icon(
                  IconBroken.Heart,
                  size: 20.0,
                  color: shopColor,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  '${SocialCubit.get(context).likes[index]}',
                  style: TextStyle(fontSize: 13.0, color: Colors.grey[700]),
                ),
                Spacer(),
                Icon(
                  IconBroken.Chat,
                  size: 20.0,
                  color: Colors.orange[300],
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  '${SocialCubit.get(context).comments[index]}',
                  style: TextStyle(fontSize: 13.0, color: Colors.grey[700]),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  'Comment',
                  style: TextStyle(fontSize: 13.0, color: Colors.grey[700]),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: customLine(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16.0,
                    backgroundImage: NetworkImage(
                      '${SocialCubit.get(context).userModel!.image}',
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    width: 150.0,
                    height: 37.0,
                    child: TextField(
                      controller: controller,
                      onSubmitted: (value) {
                        SocialCubit.get(context).addCommentPost(
                          SocialCubit.get(context).postsId[index],
                          value,
                        );
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter a comment',
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                  Spacer(),
                  likeCommShare(
                      icon: Icon(
                        IconBroken.Heart,
                        color: shopColor,
                      ),
                      text: 'Like',
                      tap: () {
                        SocialCubit.get(context).addLikePost(
                            SocialCubit.get(context).postsId[index]);
                      }),
                  Spacer(),
                  likeCommShare(
                    icon: Icon(
                      IconBroken.Paper,
                      color: Colors.green,
                    ),
                    text: 'Share',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      margin: EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4.0,
    );

Widget likeCommShare({
  required Icon icon,
  required String text,
  Function()? tap,
}) =>
    InkWell(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 8.0,
            ),
            Text(text),
          ],
        ),
      ),
    );
