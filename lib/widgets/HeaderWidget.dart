import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle=false, String strTitle, disappearedBackButton=false})
{
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disappearedBackButton ? false : true,
    title: Text(
      isAppTitle ? "Dein Funnet" : strTitle,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Fira Sans Condensed" : "",
        fontSize: isAppTitle ? 32.0 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
