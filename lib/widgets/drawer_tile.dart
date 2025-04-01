import 'package:flutter/material.dart';
import 'package:testing_api/text_styles.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function()? onTap;
  const DrawerTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          title,
          style: btitleTextStyle2,
        ),
        subtitle: Text(subtitle, style: subtitleTextStyle),
        trailing: Icon(
          icon,
          color: Colors.amber,
        ),
      ),
    );
  }
}
