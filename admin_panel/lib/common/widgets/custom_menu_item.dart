import 'package:flutter/material.dart';

class CustomMenuItem extends StatelessWidget {
  final String title;
  final String route;
  final Widget icon;

  const CustomMenuItem({super.key,required this.title, required this.icon, required this.route,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: (){

      },
    );
  }
}
