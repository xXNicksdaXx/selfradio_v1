import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String album = "";
  List<String> artistFieldList = <String>[];
  List<String> featFieldList = <String>[];

  @override
  void initState() {
    super.initState();
    title = widget.song.title;
    album = widget.song.album;
    artistFieldList.addAll(widget.song.artists);
    if (artistFieldList.isEmpty) {
      artistFieldList.add("");
    }
    if (widget.song.feat != null) {
      featFieldList.addAll(widget.song.feat!);
    }
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: artistFieldList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextFormField(
                        initialValue: artistFieldList[index],
                        decoration: InputDecoration(
                          labelText: 'Interpret #${index + 1}',
                          labelStyle: const TextStyle(color: kSecondaryColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Das Interpret-Feld darf nicht leer sein';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            artistFieldList[index] = value!;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
              buildAddAndRemoveIcon(FieldClass.artistField),
              buildDivider(),
              TextFormField(
                initialValue: title,
                autovalidateMode: AutovalidateMode.always,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  labelStyle: TextStyle(color: kSecondaryColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Das Titel-Feld darf nicht leer sein';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    title = value!;
                  });
                },
              ),
              buildDivider(),
              TextFormField(
                initialValue: album,
                decoration: const InputDecoration(
                  labelText: 'Album',
                  labelStyle: TextStyle(color: kSecondaryColor),
                ),
                onSaved: (value) {
                  setState(() {
                    album = value!;
                  });
                },
              ),
              buildDivider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: featFieldList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextFormField(
                        initialValue: featFieldList[index],
                        decoration: InputDecoration(
                          labelText: 'Feat #${index + 1}',
                          labelStyle: const TextStyle(color: kSecondaryColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Das Featuring-Feld darf nicht leer sein';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            featFieldList[index] = value!;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
              buildAddAndRemoveIcon(FieldClass.featField),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddAndRemoveIcon(FieldClass fieldClass) {
    List<Widget> widgets = [];
    if (fieldClass == FieldClass.artistField) {
      widgets.add(const Text('Interpreten bearbeiten:'));
      widgets.add(IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
            color: kPrimaryColor,
          ),
          onPressed: () {
            setState(() {
              artistFieldList.add("");
            });
          }));
      if (artistFieldList.length > 1) {
        widgets.add(
          IconButton(
            icon: const Icon(
              Icons.remove_circle_outline,
              color: kSecondaryColor,
            ),
            onPressed: () {
              setState(() {
                artistFieldList.removeLast();
              });
            },
          ),
        );
      }
    } else {
      widgets.add(const Text('Featuring bearbeiten:'));
      widgets.add(IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
            color: kPrimaryColor,
          ),
          onPressed: () {
            setState(() {
              featFieldList.add("");
            });
          }));
      if (featFieldList.isNotEmpty) {
        widgets.add(
          IconButton(
            icon: const Icon(
              Icons.remove_circle_outline,
              color: kSecondaryColor,
            ),
            onPressed: () {
              setState(() {
                featFieldList.removeLast();
              });
            },
          ),
        );
      }
    }

    return Row(
      children: widgets,
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
              Navigator.of(context).pop();
            },
          ),
          IconButton(
              icon: const Icon(
                Icons.done,
                color: kTextColor,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final item = SongDTO(
                    artists: artistFieldList,
                    title: title,
                    album: album,
                    feat: featFieldList,
                  );
                  Navigator.of(context).pop(item);
                }
              }),
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