import 'package:flutter/material.dart';
import 'package:selfradio/screens/home/components/last_used_section.dart';
import 'package:selfradio/screens/home/components/search_header.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SearchHeader(size: size),
          LastUsedSection(size: size),
        ],
      ),
    );
  }
}
