import 'package:flutter/material.dart';


class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: Text(
        'Page not found.'
      ),
    );
  }
}