import 'package:flutter/material.dart';

import '../../../constants.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({required this.size, Key? key}) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.1,
      margin: const EdgeInsets.only(bottom: kDefaultPadding),
      child: Stack(
        children: [
          Container(
            height: size.height * 0.1 - 27,
            decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(kDefaultBigRadius),
                  bottomRight: Radius.circular(kDefaultBigRadius),
                )),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              height: 48,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kDefaultSmallRadius),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 8),
                        blurRadius: 50,
                        color: kPrimaryColor.withOpacity(0.24)),
                  ]),
              child: TextField(
                  onSubmitted: (input) => {},
                  style: const TextStyle(color: kAltTextColor),
                  decoration: InputDecoration(
                    hintText: "Suche nach Playlist oder Songs",
                    hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.8)),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    suffixIcon:
                        const Icon(Icons.search, color: kSecondaryColor),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
