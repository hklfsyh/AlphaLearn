import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'alfabet_game.dart'; // Correct import for AlphabetGame

class AlphabetGamePage extends StatefulWidget {
  final int wordId;
  const AlphabetGamePage({super.key, required this.wordId});

  @override
  State<AlphabetGamePage> createState() => _AlphabetGamePageState();
}

class _AlphabetGamePageState extends State<AlphabetGamePage> {
  late AlphabetGame _game;

  @override
  void initState() {
    super.initState();
    _game = AlphabetGame(wordId: widget.wordId); // Instantiate AlphabetGame
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: _game), // Use GameWidget to display the game
    );
  }
}