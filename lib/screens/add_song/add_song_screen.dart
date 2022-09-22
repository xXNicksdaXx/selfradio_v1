import 'package:flutter/material.dart';
import 'package:selfradio/constants.dart';
import 'package:selfradio/screens/add_song/components/upload_list.dart';

class AddSongScreen extends StatelessWidget {
  const AddSongScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lieder einfügen'),
        backgroundColor: kPrimaryColor,
      ),
      body: UploadList(),
    );
  }
}
