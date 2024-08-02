import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserNotifierProvider);
    print(user);
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UploadSongPage()));
                },
                child: Text("Upload song")),
          )
        ],
      ),
    );
  }
}
