import 'package:flutter/material.dart';

import '../../../constants.dart';

class LastUsedSection extends StatelessWidget {
  const LastUsedSection({required this.size, Key? key}) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            children: const [
              SizedBox(
                height: 32,
                child: Text(
                  "Zuletzt gehört:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
            padding: const EdgeInsets.only(right: kDefaultPadding),
            scrollDirection: Axis.horizontal,
            child: Row(children: <Widget>[
              buildCard(size),
              buildCard(size),
              buildCard(size),
              buildCard(size)
            ]))
      ],
    );
  }
}

Widget buildCard(Size size) {
  return Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, top: kDefaultPadding, bottom: kDefaultPadding),
      width: size.width * 0.4,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(kDefaultSmallRadius))),
      child: Card(
        elevation: 4.0,
        child: Column(
          children: [
            SizedBox(
              height: size.width * 0.4,
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReDVX5uzU0PPFv_UI53kDvMo0mAXTFbpl9Rw&usqp=CAU",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: size.width * 0.1,
              padding: const EdgeInsets.all(kDefaultPadding * 0.5),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 8),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.08)),
              ]),
            ),
          ],
        ),
      ));
}
