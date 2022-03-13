import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/SocialApp/Cubit/cubit.dart';
import 'package:social_app/layout/SocialApp/Cubit/states.dart';
import 'package:social_app/model/MessagesModel.dart';
import 'package:social_app/model/UserModel.dart';
import 'package:social_app/shared/componants/componants.dart';

import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel userModel;
  ChatDetailsScreen(this.userModel);
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uid!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon:
                      Icon(Icons.arrow_back_ios_new_outlined, color: shopColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        userModel.image!,
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      userModel.name,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 16.0,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: SocialCubit.get(context).messages.length > 0,
                builder: (context) {
                  return Container(
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     image: NetworkImage(
                    //       'https://cdn.wallpapersafari.com/27/32/jt4AoG.jpg',
                    //     ),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              itemBuilder: (context, index) {
                                var message =
                                    SocialCubit.get(context).messages[index];
                                if (SocialCubit.get(context).userModel!.uid ==
                                    message.senderId) {
                                  return buildMyMessage(message);
                                }
                                return buildMessage(message);
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 15.0,
                              ),
                              itemCount:
                                  SocialCubit.get(context).messages.length,
                            ),
                          ),
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(27.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: textController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type you message her ...',
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50.0,
                                  color: shopColor,
                                  child: MaterialButton(
                                    minWidth: 1.0,
                                    onPressed: () {
                                      SocialCubit.get(context).sendMessages(
                                        receiverId: userModel.uid!,
                                        dateTime: DateTime.now().toString(),
                                        text: textController.text,
                                      );
                                      textController.clear();
                                    },
                                    child: Icon(
                                      IconBroken.Send,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }
}

Widget buildMessage(MessagesModel model) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(15.0),
              topEnd: Radius.circular(15.0),
              topStart: Radius.circular(15.0)),
        ),
        child: Text(model.text!),
      ),
    );

Widget buildMyMessage(MessagesModel model) => Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          color: shopColor.withOpacity(0.3),
          borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(15.0),
              topEnd: Radius.circular(15.0),
              topStart: Radius.circular(15.0)),
        ),
        child: Text(model.text!),
      ),
    );
