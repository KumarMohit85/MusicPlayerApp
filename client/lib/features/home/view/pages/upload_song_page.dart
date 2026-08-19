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
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void submitForm() {
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
      showSnackBar(context, "Please select an audio file, thumbnail, and fill all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewmodelProvider.select((val) => val?.isLoading == true));

    ref.listen(
      homeViewmodelProvider,
      (previous, next) {
        next?.when(
          data: (data) {
            showSnackBar(context, "Song uploaded successfully!");
            ref.invalidate(getAllSongsProvider);
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Pallete.cardColor,
              ),
              child: const Icon(Icons.chevron_left, color: Colors.white),
            ),
          ),
        ),
        title: const Text(
          "UPLOAD MUSIC",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: const Icon(Icons.check, color: Pallete.limeColor, size: 28),
          )
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Share your sound",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Upload tracks, covers, and details so they appear in your library and mixes.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Pallete.subtitleText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Audio Picker Box (Image 4 design)
                    DottedBorder(
                      color: Pallete.borderColor,
                      dashPattern: const [8, 8],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(16),
                      strokeWidth: 1.5,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Pallete.cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: selectedAudio != null
                            ? Column(
                                children: [
                                  AudioWaveform(path: selectedAudio!.path),
                                  const SizedBox(height: 12),
                                  TextButton.icon(
                                    onPressed: selectAudio,
                                    icon: const Icon(Icons.refresh, color: Pallete.limeColor, size: 18),
                                    label: const Text(
                                      "Change Audio File",
                                      style: TextStyle(color: Pallete.limeColor, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF2A2A2A),
                                    ),
                                    child: const Icon(
                                      Icons.file_upload_outlined,
                                      color: Pallete.limeColor,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    "Drop your audio file",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "MP3, WAV, FLAC · up to 50MB",
                                    style: TextStyle(
                                      color: Pallete.subtitleText,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: selectAudio,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Pallete.limeColor,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: const Text(
                                      "Browse files",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Thumbnail Selector Box
                    const Text(
                      "THUMBNAIL IMAGE",
                      style: TextStyle(
                        color: Pallete.subtitleText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: selectImage,
                      child: selectedImage != null
                          ? SizedBox(
                              height: 140,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Pallete.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Pallete.borderColor),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image_outlined, color: Pallete.limeColor, size: 24),
                                  SizedBox(width: 10),
                                  Text(
                                    "Select Thumbnail Image",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // TRACK TITLE Label & Field (Image 5 design)
                    const Text(
                      "TRACK TITLE",
                      style: TextStyle(
                        color: Pallete.subtitleText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomField(
                      hintText: 'e.g. O mere dil k chain',
                      controller: songNameController,
                    ),

                    const SizedBox(height: 18),

                    // ARTIST Label & Field
                    const Text(
                      "ARTIST",
                      style: TextStyle(
                        color: Pallete.subtitleText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomField(
                      hintText: 'e.g. Kishore Kumar',
                      controller: artistController,
                    ),

                    const SizedBox(height: 18),

                    // COLOR ACCENT
                    const Text(
                      "COLOR ACCENT",
                      style: TextStyle(
                        color: Pallete.subtitleText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ColorPicker(
                      color: selectedColor,
                      pickersEnabled: const {ColorPickerType.wheel: true},
                      onColorChanged: (Color color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Pallete.limeColor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "UPLOAD MUSIC",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}
