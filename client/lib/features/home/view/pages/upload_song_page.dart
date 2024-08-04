import 'dart:io';

import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/repositries/home_repository.dart';
import 'package:client/features/home/view/widgets/audio_waveform.dart';
import 'package:client/features/home/view_model/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final TextEditingController songNameController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  var selectedColor = Pallete.cardColor;
  File? selectedAudio;
  File? selectedImage;
  final _formKey = GlobalKey<FormState>();

  void selectImage() async {
    final pickedImage = await pickImage();

    setState(() {
      print("set state called from selectImage fn");
      selectedImage = pickedImage;
    });
  }

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    print("audio picked");
    setState(() {
      print("set state called");
      selectedAudio = pickedAudio;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewmodelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Song"),
        actions: [
          IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() &&
                    selectedAudio != null &&
                    selectedImage != null) {
                  ref.read(homeViewmodelProvider.notifier).uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      songName: songNameController.text,
                      artist: artistController.text,
                      color: selectedColor);
                } else {
                  showSnackBar(context, "Missing fields");
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ))
                            : DottedBorder(
                                color: Pallete.borderColor,
                                dashPattern: const [10, 10],
                                borderType: BorderType.RRect,
                                radius: Radius.circular(10),
                                strokeCap: StrokeCap.round,
                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.folder),
                                      Text("Select a thumbnail")
                                    ],
                                  ),
                                )),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      selectedAudio != null
                          ? AudioWaveform(path: selectedAudio!.path)
                          : CustomField(
                              hintText: 'Pick Song',
                              controller: null,
                              isReadOnly: true,
                              onTap: selectAudio,
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomField(
                        hintText: 'Artist',
                        controller: artistController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomField(
                        hintText: 'Song Name',
                        controller: songNameController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ColorPicker(
                          color: selectedColor,
                          pickersEnabled: const {ColorPickerType.wheel: true},
                          onColorChanged: (Color color) {
                            setState(() {
                              selectedColor = color;
                            });
                          })
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
