import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/home/view/pages/library_page.dart';
import 'package:client/features/home/view/pages/songs_page.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  int selectedIndex = 0;
  final pages = const [SongsPage(), UploadSongPage(), LibraryPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          pages[selectedIndex],
          const Positioned(
            bottom: 0,
            left: 8,
            right: 8,
            child: MusicSlab(),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: Pallete.limeColor,
          unselectedItemColor: Pallete.inactiveBottomBarItemColor,
          backgroundColor: Pallete.backgroundColor,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 0 ? Icons.home_filled : Icons.home_outlined,
                  size: 26,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 1
                      ? Icons.file_upload
                      : Icons.file_upload_outlined,
                  size: 26,
                ),
                label: 'Upload'),
            BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 2
                      ? Icons.library_music
                      : Icons.library_music_outlined,
                  size: 26,
                ),
                label: 'Library'),
          ]),
    );
  }
}
