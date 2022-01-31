import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/add_post/add_post_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = SocialCubit.get(context);
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        //if(state is AddNewPostState) naveTo(context, AddPostScreen());
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('${cubit.titles[cubit.currentIndex]}'),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none_outlined)),
            IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 7,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            items: cubit.bottomNavItems,
            currentIndex: cubit.currentIndex,
            onTap: (index) => cubit.changeBottomNaveBarIndex(index),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            naveTo(context, AddPostScreen());
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: ConditionalBuilder(
          condition: cubit.user != null,
          builder: (context) {
            //UserModel user = cubit.user!;
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  cubit.screens[cubit.currentIndex]
                  // if(!FirebaseAuth.instance.currentUser!.emailVerified)
                  //   Container(
                  //     color: Colors.amber.withOpacity(0.7),
                  //     padding: const EdgeInsets.symmetric(horizontal: 19),
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.info_outline),
                  //         SizedBox(width: 13,),
                  //         Expanded(
                  //             child: Text('Please verify your email')
                  //         ),
                  //         SizedBox(width: 19,),
                  //         TextButton(
                  //             onPressed: (){
                  //               FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value){
                  //                 showToast('Please check your mail!', ToastStates.SUCCESS);
                  //                 //check this at home or tomorrow
                  //                 // FirebaseFirestore.instance.collection('users').doc(user.uId).set(
                  //                 //     {
                  //                 //       'isEmailVerified' : true,
                  //                 //     }).then((value) {
                  //                 //   showToast('email verified successfully', ToastStates.SUCCESS);
                  //                 // }).catchError((error) {
                  //                 //   showToast(error.toString(), ToastStates.ERROR);
                  //                 // });
                  //
                  //               }).catchError((error){
                  //                 showToast(error.toString(), ToastStates.ERROR);
                  //               });
                  //             },
                  //             child: Text('SEND')
                  //         )
                  //       ],
                  //     ),
                  //   )
                ],
              ),
            );
          },
          fallback: (context) => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
