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

class EditProfileScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        nameController.text = userModel!.name;
        phoneController.text = userModel.phone;
        emailController.text = userModel.email;
        bioController.text = userModel.bio;
        return SocialCubit.get(context).userModel == null
            ? customErrorScreens(context)
            : Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_outlined,
                        color: shopColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text('Edit Profile'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          SocialCubit.get(context).updateUesrData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            bio: bioController.text != null
                                ? bioController.text
                                : '',
                          );
                          Get.back();
                        }
                      },
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          color: shopColor,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (state is LoadingUpdateUsersState)
                            LinearProgressIndicator(),
                          // if (state is LoadingUpdateUsersState)
                          Container(
                            height: 230.0,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      Container(
                                        height: 190.0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8.0),
                                            topLeft: Radius.circular(8.0),
                                          ),
                                          image: DecorationImage(
                                            image: coverImage == null
                                                ? NetworkImage(
                                                    '${userModel.cover}',
                                                  )
                                                : FileImage(coverImage)
                                                    as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            SocialCubit.get(context)
                                                .getCoverImage();
                                          },
                                          child: CircleAvatar(
                                            radius: 16.0,
                                            backgroundColor: shopColor,
                                            child: Icon(
                                              IconBroken.Camera,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 64.0,
                                  backgroundColor: Colors.white,
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      CircleAvatar(
                                        radius: 60.0,
                                        backgroundImage: profileImage == null
                                            ? NetworkImage(
                                                '${userModel.image}',
                                              )
                                            : FileImage(profileImage)
                                                as ImageProvider,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          SocialCubit.get(context)
                                              .getProfileImage();
                                        },
                                        child: CircleAvatar(
                                          radius: 16.0,
                                          backgroundColor: shopColor,
                                          child: Icon(
                                            IconBroken.Camera,
                                            size: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          // if (SocialCubit.get(context).profileImage != null ||
                          //     SocialCubit.get(context).coverImage != null)
                          Row(
                            children: [
                              if (SocialCubit.get(context).profileImage != null)
                                Expanded(
                                  child: customButtom(
                                    buttomCollor: shopColor,
                                    text: 'Update Profile',
                                    press: () {
                                      if (SocialCubit.get(context)
                                              .profileImage !=
                                          null) {
                                        SocialCubit.get(context)
                                            .uploadProfileImage(
                                          name: nameController.text,
                                          email: emailController.text,
                                          phone: phoneController.text,
                                          bio: bioController.text != null
                                              ? bioController.text
                                              : '',
                                        );
                                        showTast(
                                          text: 'Uploaded Profile Image',
                                          state: ToastStates.SUCCESS,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              SizedBox(
                                width: 5.0,
                              ),
                              if (SocialCubit.get(context).coverImage != null)
                                Expanded(
                                  child: customButtom(
                                    buttomCollor: shopColor,
                                    text: 'Update Cover',
                                    press: () {
                                      if (SocialCubit.get(context).coverImage !=
                                          null) {
                                        SocialCubit.get(context)
                                            .uploadCoverImage(
                                          name: nameController.text,
                                          email: emailController.text,
                                          phone: phoneController.text,
                                          bio: bioController.text != null
                                              ? bioController.text
                                              : '',
                                        );
                                        showTast(
                                          text: 'Uploaded Cover Image',
                                          state: ToastStates.SUCCESS,
                                        );
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                buildEditFeild(
                                  text: 'Username',
                                  controller: nameController,
                                  inputType: TextInputType.name,
                                  pIcon: Icons.person_outline,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'User Name Required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                buildEditFeild(
                                  text: 'Bio',
                                  controller: bioController,
                                  inputType: TextInputType.multiline,
                                  pIcon: Icons.text_snippet_outlined,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                buildEditFeild(
                                  text: 'Email',
                                  controller: emailController,
                                  inputType: TextInputType.emailAddress,
                                  pIcon: Icons.email_outlined,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Email Required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                buildEditFeild(
                                  text: 'Phone',
                                  controller: phoneController,
                                  inputType: TextInputType.phone,
                                  pIcon: Icons.phone_outlined,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Phone Required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

Widget buildEditFeild({
  required String text,
  required TextEditingController controller,
  required TextInputType inputType,
  required IconData pIcon,
  String? Function(String?)? validate,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        customTextFeild(
          controller: controller,
          inputType: inputType,
          title: '',
          pIcon: pIcon,
          textColor: Colors.black,
          validate: validate,
        ),
      ],
    );
