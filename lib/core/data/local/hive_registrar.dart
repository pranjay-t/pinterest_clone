import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_media_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_photo_model.dart';
import 'package:pinterest_clone/features/home/data/models/pexels_video_model.dart';
import 'package:pinterest_clone/features/saved/data/models/local_board_model.dart';
import 'package:pinterest_clone/features/saved/data/models/local_media_model.dart';

class HiveRegistrar {
  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register Adapters
    _registerAdapters();

    // Open Boxes
    await _openBoxes();
  }

  static void _registerAdapters() {
    Hive.registerAdapter(MediaTypeAdapter());
    Hive.registerAdapter(LocalMediaModelAdapter());
    Hive.registerAdapter(LocalBoardModelAdapter());
    Hive.registerAdapter(PexelsPhotoAdapter());
    Hive.registerAdapter(PexelsPhotoSrcAdapter());
    Hive.registerAdapter(PexelsVideoAdapter());
    Hive.registerAdapter(PexelsVideoFileAdapter());
    Hive.registerAdapter(PexelsVideoPictureAdapter());
    
    try {
      Hive.registerAdapter(PexelsMediaAdapter());
    } catch (e) {
      // Ignore if already registered or not generated
    }
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<LocalMediaModel>('saved_media');
    await Hive.openBox<LocalBoardModel>('boards');
  }
}
