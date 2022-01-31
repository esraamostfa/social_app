import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/colores.dart';

void naveTo(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => widget));
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
        (rout) => false,
  );
}

void showToast(String message, ToastStates state) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastState(state),
      textColor: Colors.white,
      fontSize: 16.0
  );
}

enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastState(ToastStates state) {
  Color color;

  switch(state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget buildItemsDivider() => Container(
  height: 1,
  color: Colors.grey[300],
  margin: EdgeInsets.all(21),
);

Widget defaultButton({
  double width = double.infinity,
  Color background = defaultColor,
  Color textColor = Colors.white,
  bool isUpperCase = true,
  @required text,
  @required function,
}) =>
    Container(
        width: width,
        height: 41,
        child: MaterialButton(
          color: background,
          child: Text(isUpperCase ? text.toUpperCase() : text),
          textColor: textColor,
          onPressed: function,
        ));

PreferredSizeWidget defaultAppBar(
     BuildContext context,
    {
      String? title,
      actions,
}) => AppBar(
  title: Text(title!),
  titleSpacing: 5,
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios_rounded),
    onPressed: (){
      Navigator.pop(context);
    },
  ),
  actions: actions,
);

Widget defaultTextForm({
  @required controller,
  @required textInputType,
  onSubmit,
  onChange,
  @required String? label,
  @required validator,
  @required IconData? prefixIcon,
  IconData? suffixIcon,
  onSuffixPressed,
  bool isPassword = false,
  onTape,
  bool isEnabled = true,

}) =>
    TextFormField(
      controller: controller,
      keyboardType: textInputType,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validator,
      onTap: onTape,
      enabled: isEnabled,
      obscureText: isPassword,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: onSuffixPressed ,
          ),
          border: OutlineInputBorder()),
    );

void signOut(context) {
  CacheHelper.removeData('token').then((value){
    if(value) navigateAndFinish(context, LoginScreen());

  });
}
