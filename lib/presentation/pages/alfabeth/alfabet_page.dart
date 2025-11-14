import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'alfabet_game.dart';

class AlphabetGamePage extends StatefulWidget {
  const AlphabetGamePage({super.key});

  @override
  State<AlphabetGamePage> createState() => _AlphabetGamePageState();
}

class _AlphabetGamePageState extends State<AlphabetGamePage> {
  late AlphabetGame _game;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    try {
      _game = AlphabetGame();
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _hasError
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Error Loading Game',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage ?? 'Unknown error',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to Menu'),
                      ),
                    ],
                  ),
                ),
              )
            : GameWidget(
                game: _game,
                loadingBuilder: (context) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading Game...'),
                    ],
                  ),
                ),
                errorBuilder: (context, error) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Error: ${error.toString()}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Back to Menu'),
                        ),
                      ],
                    ),
                  ),
                ),
                overlayBuilderMap: {
                  'level_complete': (context, game) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Level Complete!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                final alphabetGame = game as AlphabetGame;
                                alphabetGame.overlays.remove('level_complete');
                                Navigator.pop(context);
                              },
                              child: const Text('Back to Menu'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                },
              ),
      ),
    );
  }
}
