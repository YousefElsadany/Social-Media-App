import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/SocialApp/Cubit/cubit.dart';
import 'package:social_app/layout/SocialApp/Cubit/states.dart';
import 'package:social_app/shared/componants/componants.dart';

import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icon_broken.dart';

class CreatePostScreen extends StatelessWidget {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var now = DateTime.now();
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_outlined, color: shopColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('Create Post'),
            actions: [
              TextButton(
                onPressed: () {
                  if (cubit.postImage != null) {
                    cubit.uploadImagePost(
                      text: textController.text,
                      dateTime: now.toString(),
                    );
                  } else {
                    cubit.createNewPost(
                      text: textController.text,
                      dateTime: now.toString(),
                    );
                  }
                  Get.back();
                  showTast(
                    text: 'Sccessful Post',
                    state: ToastStates.SUCCESS,
                  );
                },
                child: Text(
                  'POST',
                  style: TextStyle(
                    color: shopColor,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26.0,
                      backgroundImage: NetworkImage(
                        'https://image.freepik.com/free-photo/horizontal-shot-pretty-curly-haired-afro-american-woman-looks-positively-aside-has-tender-smile-wears-casual-anorak-looks-away-joyfully-being-good-mood-isolated-pink-wall_273609-42424.jpg',
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
                                'Gowin Staice',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 16.0,
                                      height: 1.4,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    maxLines: 99999,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'What do you think Gowin ? ',
                      hintStyle: TextStyle(
                        fontSize: 18.0,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 160.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            4.0,
                          ),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: shopColor,
                        child: IconButton(
                            onPressed: () {
                              cubit.removePostImage();
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          cubit.getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconBroken.Image,
                              color: shopColor,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'add photo',
                              style: TextStyle(
                                color: shopColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '# tags',
                          style: TextStyle(
                            color: shopColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
