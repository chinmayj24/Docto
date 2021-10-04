import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar(
      {Key key, this.title, this.actions, this.leading, this.centerTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Color(0xFFF2F6FE),
          border: Border(
              bottom: BorderSide(
            color: Color(0xFFF2F6FE),
            width: MediaQuery.of(context).size.height * 0.001,
            style: BorderStyle.solid,
          ))),
      child: AppBar(
        backgroundColor: Color(0xFFF2F6FE),
        elevation: 0,
        leading: leading,
        actions: actions,
        title: title,
        centerTitle: centerTitle,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
