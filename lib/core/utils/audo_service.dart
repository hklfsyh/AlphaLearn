import 'package:audioplayers/audioplayers.dart';
import 'dart:developer' as developer;

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isMuted = false;
  double _volume = 0.5; // Default volume 50%

  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  double get volume => _volume;

  // Initialize audio service
  Future<void> init() async {
    try {
      developer.log('🎵 AudioService initializing...', name: 'AudioService');

      // Set release mode untuk loop
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

      // Set volume
      await _bgmPlayer.setVolume(_volume);

      // Play langsung saat init
      await _bgmPlayer.play(AssetSource('music/bgm.mp3'));
      _isPlaying = true;

      developer.log('🎵 AudioService initialized & playing',
          name: 'AudioService');
    } catch (e) {
      developer.log('❌ AudioService init error: $e', name: 'AudioService');
    }
  }

  // Play background music
  Future<void> playBgm() async {
    try {
      if (!_isPlaying && !_isMuted) {
        await _bgmPlayer.play(AssetSource('music/bgm.mp3'));
        _isPlaying = true;
        developer.log('🎵 BGM playing', name: 'AudioService');
      }
    } catch (e) {
      developer.log('❌ Play BGM error: $e', name: 'AudioService');
    }
  }

  // Resume background music (jika sudah di-pause)
  Future<void> resumeBgm() async {
    try {
      if (!_isPlaying && !_isMuted) {
        await _bgmPlayer.resume();
        _isPlaying = true;
        developer.log('🎵 BGM resumed', name: 'AudioService');
      }
    } catch (e) {
      developer.log('❌ Resume BGM error: $e', name: 'AudioService');
    }
  }

  // Pause background music
  Future<void> pauseBgm() async {
    try {
      if (_isPlaying) {
        await _bgmPlayer.pause();
        _isPlaying = false;
        developer.log('🎵 BGM paused', name: 'AudioService');
      }
    } catch (e) {
      developer.log('❌ Pause BGM error: $e', name: 'AudioService');
    }
  }

  // Stop background music
  Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
      _isPlaying = false;
      developer.log('🎵 BGM stopped', name: 'AudioService');
    } catch (e) {
      developer.log('❌ Stop BGM error: $e', name: 'AudioService');
    }
  }

  // Toggle mute
  Future<void> toggleMute() async {
    try {
      _isMuted = !_isMuted;

      if (_isMuted) {
        await _bgmPlayer.setVolume(0);
        developer.log('🔇 BGM muted', name: 'AudioService');
      } else {
        await _bgmPlayer.setVolume(_volume);
        developer.log('🔊 BGM unmuted', name: 'AudioService');
      }
    } catch (e) {
      developer.log('❌ Toggle mute error: $e', name: 'AudioService');
    }
  }

  // Set volume (0.0 - 1.0)
  Future<void> setVolume(double vol) async {
    try {
      _volume = vol.clamp(0.0, 1.0);
      if (!_isMuted) {
        await _bgmPlayer.setVolume(_volume);
      }
      developer.log('🎵 Volume set to: $_volume', name: 'AudioService');
    } catch (e) {
      developer.log('❌ Set volume error: $e', name: 'AudioService');
    }
  }

  // Dispose
  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    developer.log('🎵 AudioService disposed', name: 'AudioService');
  }
}
