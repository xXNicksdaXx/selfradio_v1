import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../constants.dart';
import '../../entities/dto/song_dto.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, required this.context, required this.song})
      : super(key: key);

  final BuildContext context;
  final SongDTO song;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  List<Widget> artistFieldList = <Widget>[];
  List<Widget> featFieldList = <Widget>[];

  int artists = 0;
  int feat = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.song.artists.length; i++) {
      _createArtistForm(i);
    }
    if (widget.song.feat != null) {
      for (int i = 0; i < widget.song.feat!.length; i++) {
        _createFeatForm(i);
      }
    }
  }

  void _createArtistForm(int i) {
    artists++;
    final String initialValue;
    i >= 0 ? initialValue = widget.song.artists[i] : initialValue = '';
    final form = FormBuilderTextField(
      name: 'artist$artists',
      autovalidateMode: AutovalidateMode.always,
      controller: TextEditingController(text: initialValue),
      decoration: InputDecoration(
        labelText: 'Interpret #$artists',
        labelStyle: const TextStyle(color: kSecondaryColor),
      ),
      validator: FormBuilderValidators.required(
          errorText: 'Das Interpret-Feld darf nicht leer sein!'),
    );
    setState(() {
      artistFieldList.add(form);
    });
  }

  void _createFeatForm(int i) {
    feat++;
    final String initialValue;
    i >= 0 ? initialValue = widget.song.feat![i] : initialValue = '';
    final form = FormBuilderTextField(
      name: 'feat$feat',
      autovalidateMode: AutovalidateMode.always,
      controller: TextEditingController(text: initialValue),
      decoration: InputDecoration(
        labelText: 'Featuring #$feat',
        labelStyle: const TextStyle(color: kSecondaryColor),
      ),
      validator: FormBuilderValidators.required(
          errorText: 'Das Feat-Feld darf nicht leer sein!'),
    );
    setState(() {
      featFieldList.add(form);
    });
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
        child: FormBuilder(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: artists,
                  itemBuilder: (context, index) {
                    return artistFieldList[index];
                  }),
              buildAddAndRemoveIcon(FieldClass.artistField),
              buildDivider(),
              FormBuilderTextField(
                name: 'title',
                autovalidateMode: AutovalidateMode.always,
                controller: TextEditingController(text: widget.song.title),
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  labelStyle: TextStyle(color: kSecondaryColor),
                ),
                validator: FormBuilderValidators.required(
                    errorText: 'Das Titel-Feld darf nicht leer sein!'),
              ),
              buildDivider(),
              FormBuilderTextField(
                name: 'album',
                autovalidateMode: AutovalidateMode.always,
                controller: TextEditingController(text: widget.song.album),
                decoration: const InputDecoration(
                  labelText: 'Album',
                  labelStyle: TextStyle(color: kSecondaryColor),
                ),
              ),
              buildDivider(),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: feat,
                  itemBuilder: (context, index) {
                    return featFieldList[index];
                  }),
              buildAddAndRemoveIcon(FieldClass.featField),
            ],
          ),
          onChanged: () {
            formKey.currentState!.save();
          },
        ),
      ),
    );
  }

  Widget buildAddAndRemoveIcon(FieldClass fieldClass) {
    List<Widget> icons = [];
    if (fieldClass == FieldClass.artistField) {
      icons.add(const Text('Interpreten bearbeiten:'));
      icons.add(IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
            color: kPrimaryColor,
          ),
          onPressed: () {
            _createArtistForm(-1);
          }));
      if (artists > 1) {
        icons.add(
          IconButton(
            icon: const Icon(
              Icons.remove_circle_outline,
              color: kSecondaryColor,
            ),
            onPressed: () {
              setState(() {
                artistFieldList.removeLast();
                artists--;
              });
            },
          ),
        );
      }
    } else {
      icons.add(const Text('Featuring bearbeiten:'));
      icons.add(IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
            color: kPrimaryColor,
          ),
          onPressed: () {
            _createFeatForm(-1);
          }));
      if (feat > 1) {
        icons.add(
          IconButton(
            icon: const Icon(
              Icons.remove_circle_outline,
              color: kSecondaryColor,
            ),
            onPressed: () {
              setState(() {
                featFieldList.removeLast();
                feat--;
              });
            },
          ),
        );
      }
    }

    return Row(
      children: icons,
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
            icon: const Icon(
              Icons.undo,
              color: kTextColor,
            ),
            onPressed: () {
              formKey.currentState?.reset();
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.done,
              color: kTextColor,
            ),
            onPressed: () {
              if (formKey.currentState?.saveAndValidate() ?? false) {
                Map<String, dynamic>? values = formKey.currentState?.value;

                final title = values!['title'];
                final album = values['album'];

                List<String> artistList = [];
                for (int i = 1; i <= artists; i++) {
                  artistList.add(values['artist$i']);
                }

                List<String>? featList = [];
                for (int i = 1; i <= feat; i++) {
                  featList.add(values['feat$i']);
                }

                final item = SongDTO(
                  artists: artistList,
                  title: title,
                  album: album,
                  feat: featList,
                );
                Navigator.of(context).pop(item);
              }
            },
          ),
        ],
      ),
    );
  }
}

Widget buildDivider() {
  return const Divider(
    height: 10,
    thickness: 2,
    color: kPrimaryColor,
  );
}

enum FieldClass { artistField, featField }
