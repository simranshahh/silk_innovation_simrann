// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:silkinnovationsimransah/cardmodel.dart';

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final TextEditingController _controller = TextEditingController();
  List<CardModel> _cards = [];
  CardModel? _firstCard;
  CardModel? _secondCard;
  bool _isProcessing = false;

  void _initializeCards(String input) {
    List<String> values = input.split(',').map((s) => s.trim()).toList();
    if (values.length.isOdd) {
      values.add(values[Random().nextInt(values.length)]);
    }
    values.shuffle();
    _cards = List.generate(values.length, (index) {
      return CardModel(id: index, value: values[index]);
    });
  }

  void _flipCard(CardModel card) {
    if (_isProcessing || card.isFlipped) return;

    setState(() {
      card.isFlipped = true;
    });

    if (_firstCard == null) {
      _firstCard = card;
    } else {
      _secondCard = card;
      _isProcessing = true;
      Future.delayed(Duration(seconds: 1), _checkMatch);
    }
  }

  void _checkMatch() {
    if (_firstCard != null && _secondCard != null) {
      if (_firstCard!.value == _secondCard!.value) {
        setState(() {
          _cards.remove(_firstCard);
          _cards.remove(_secondCard);
        });
      } else {
        setState(() {
          _firstCard!.isFlipped = false;
          _secondCard!.isFlipped = false;
        });
      }

      _firstCard = null;
      _secondCard = null;
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Card Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter values separated by commas (e.g., A,B,C,D)',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _initializeCards(_controller.text);
                });
              },
              child: Text('Start Game'),
            ),
            SizedBox(height: 16),
            if (_cards.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    return Card(
                      child: InkWell(
                        onTap: () => _flipCard(card),
                        child: Center(
                          child: Text(
                            card.isFlipped ? card.value : '',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
