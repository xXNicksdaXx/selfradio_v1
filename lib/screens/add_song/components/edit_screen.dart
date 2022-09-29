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
  final artistKey = GlobalKey<FormBuilderState>();
  final mixedKey = GlobalKey<FormBuilderState>();
  final featKey = GlobalKey<FormBuilderState>();
  List<Widget> artistFields = [];
  List<Widget> mixedFields = [];
  List<Widget> featFields = [];
  int artists = 0;
  int feat = 0;

  void _createArtistForm(int i) {
    artists++;
    final String initialValue;
    i >= 0 ? initialValue = widget.song.artist[i] : initialValue = '';
    final form = FormBuilderTextField(
      autovalidateMode: AutovalidateMode.always,
      initialValue: initialValue,
      name: 'artist$artists',
      decoration: InputDecoration(
          labelText: 'Interpret #$artists',
          labelStyle: const TextStyle(color: kSecondaryColor),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: kPrimaryColor,
            ),
            onPressed: () => _createArtistForm(-1),
          )),
      validator: FormBuilderValidators.required(
          errorText: 'Das Interpret-Feld darf nicht leer sein!'),
    );
    setState(() {
      artistFields.add(form);
    });
  }

  void _createTitleForm() {
    final form = FormBuilderTextField(
      autovalidateMode: AutovalidateMode.always,
      initialValue: widget.song.title,
      name: 'title',
      decoration: const InputDecoration(
        labelText: 'Titel',
        labelStyle: TextStyle(color: kSecondaryColor),
      ),
      validator: FormBuilderValidators.required(
          errorText: 'Das Titel-Feld darf nicht leer sein!'),
    );
    setState(() {
      mixedFields.add(form);
    });
  }

  void _createAlbumForm() {
    final form = FormBuilderTextField(
      autovalidateMode: AutovalidateMode.always,
      initialValue: widget.song.album,
      name: 'album',
      decoration: const InputDecoration(
        labelText: 'Album',
        labelStyle: TextStyle(color: kSecondaryColor),
      ),
    );
    setState(() {
      mixedFields.add(form);
    });
  }

  void _createFeatForm() {
    feat++;
    final form = FormBuilderTextField(
      autovalidateMode: AutovalidateMode.always,
      name: 'feat',
      decoration: InputDecoration(
        labelText: 'Feat #$feat',
        labelStyle: const TextStyle(color: kSecondaryColor),
      ),
      validator: FormBuilderValidators.required(
          errorText: 'Das Titel-Feld darf nicht leer sein!'),
    );
    setState(() {
      featFields.add(form);
    });
  }

  @override
  void initState() {
    super.initState();
    artists = 0;
    feat = 0;

    for (int i = 0; i < widget.song.artist.length; i++) {
      _createArtistForm(i);
    }

    _createTitleForm();
    _createAlbumForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: const Text("Metadaten bearbeiten"),
          backgroundColor: kPrimaryColor,
        ),
        body: buildFormBody(),
        bottomSheet: buildBottomBar());
  }

  Widget buildFormBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            FormBuilder(
              key: artistKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: artistFields,
              ),
              onChanged: () => artistKey.currentState!.save(),
            ),
            FormBuilder(
              key: mixedKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: mixedFields,
              ),
              onChanged: () => mixedKey.currentState!.save(),
            ),
            FormBuilder(
              key: featKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: featFields,
              ),
              onChanged: () => featKey.currentState!.save(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: kPrimaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {
                artistKey.currentState?.reset();
                mixedKey.currentState?.reset();
                featKey.currentState?.reset();
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.undo,
                color: kTextColor,
              )),
          IconButton(
              onPressed: () {
                MetadataItem? item;
                if (artistKey.currentState!.saveAndValidate() &&
                    mixedKey.currentState!.saveAndValidate() &&
                    featKey.currentState!.saveAndValidate()) {
                  Map<String, dynamic>? value = artistKey.currentState!.value;
                  List<String> artistList = [];
                  for (int i = 1; i <= artists; i++) {
                    artistList.add(value['artist$i']);
                  }
                  value = artistKey.currentState!.value;
                  final title = value['title'];
                  value = artistKey.currentState!.value;
                  final album = value['album'];
                  print(title);
                  print(album);
                  item = MetadataItem(
                      artist: artistList, title: title, album: album);
                  Navigator.of(context).pop(item);
                }
              },
              icon: const Icon(
                Icons.done,
                color: kTextColor,
              )),
        ],
      ),
    );
  }
}
