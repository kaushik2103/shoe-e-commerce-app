import 'package:ecommerce/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class TilesWidget extends StatelessWidget {
  final String title;
  final IconData leading;
  final Function()? OnTap;

  const TilesWidget({
    Key? key,
    required this.title,
    required this.leading,
    this.OnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: OnTap,
      leading: Icon(
        leading,
        color: Colors.black,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Color(kPrimaryColor),
        size: 16,
      ),
    );
  }
}
