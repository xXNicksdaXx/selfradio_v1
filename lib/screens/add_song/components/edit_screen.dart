import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:selfradio/entities/list_item.dart';

import '../../../constants.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, required this.context, required this.song})
      : super(key: key);

  final BuildContext context;
  final MetadataItem song;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  final artistFormKey = GlobalKey<FormBuilderFieldState>();

  @override
  Widget build(BuildContext context) {
    // List<Widget> artists = [
    //   TextFormField(
    //     initialValue: widget.song.artist,
    //     onChanged: (value) => value.isNotEmpty
    //         ? newSong.artist = value
    //         : newSong.artist = widget.song.artist,
    //   ),
    // ];
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: const Text("Metadaten bearbeiten"),
          backgroundColor: kPrimaryColor,
        ),
        body: FormBuilder(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: [
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.always,
                  name: 'artist',
                  decoration: const InputDecoration(
                    labelText: 'Interpret',
                    labelStyle: TextStyle(color: kSecondaryColor),
                  ),
                  initialValue: widget.song.artist,
                  validator: FormBuilderValidators.required(
                      errorText: 'Das Interpret-Feld darf nicht leer sein!'),
                ),
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.always,
                  name: 'title',
                  decoration: const InputDecoration(
                    labelText: 'Titel',
                    labelStyle: TextStyle(color: kSecondaryColor),
                  ),
                  initialValue: widget.song.title,
                  validator: FormBuilderValidators.required(
                      errorText: 'Das Titel-Feld darf nicht leer sein!'),
                )
              ],
            ),
          ),
          onChanged: () => formKey.currentState!.save(),
        ),
        bottomSheet: Container(
          decoration: const BoxDecoration(
            color: kPrimaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    formKey.currentState?.reset();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.undo,
                    color: kTextColor,
                  )),
              IconButton(
                  onPressed: () {
                    MetadataItem? item;
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      final value = formKey.currentState?.value;
                      item = MetadataItem(
                          artist: value!['artist'],
                          title: value['title'],
                          album: "");
                      Navigator.of(context).pop(item);
                    }
                  },
                  icon: const Icon(
                    Icons.done,
                    color: kTextColor,
                  )),
            ],
          ),
        ));
  }
}
