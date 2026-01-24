import 'dart:async';

import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../models/word_level.dart';
import '../widgets/stat_card.dart';
import '../widgets/word_prompt_card.dart';

class NovaTapGamePage extends StatefulWidget {
  final WordLevel level;
  final ValueChanged<ScoreRecord> onRoundComplete;
  final int baselineBest;

  const NovaTapGamePage({
    super.key,
    required this.level,
    required this.onRoundComplete,
    required this.baselineBest,
  });

  @override
  State<NovaTapGamePage> createState() => _NovaTapGamePageState();
}

class _NovaTapGamePageState extends State<NovaTapGamePage> {
  static const int tickMillis = 1000;

  late final TextEditingController _controller;
  Timer? _timer;
  late WordPrompt _currentPrompt;
  late double _timeLeft;
  late int _score;
  late bool _roundFinished;
  late String _statusMessage;
  late String _feedback;
  late int _currentBest;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _timeLeft = widget.level.roundDuration.toDouble();
    _score = 0;
    _roundFinished = false;
    _statusMessage = 'Guess the word before time ends';
    _feedback = '';
    _currentBest = widget.baselineBest;
    _currentPrompt = _pickRandomPrompt();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  WordPrompt _pickRandomPrompt() {
    final list = widget.level.prompts;
    return list[DateTime.now().microsecond % list.length];
  }

  void _startRound() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _timeLeft = widget.level.roundDuration.toDouble();
      _roundFinished = false;
      _feedback = '';
      _statusMessage = 'Guess the word before time ends';
      _currentPrompt = _pickRandomPrompt();
    });

    _timer = Timer.periodic(const Duration(milliseconds: tickMillis), (timer) {
      setState(() {
      _timeLeft -= 1.0;
        if (_timeLeft <= 0) {
          _timeLeft = 0;
          _roundFinished = true;
          timer.cancel();
          _emitScore();
        }
      });
    });
  }

  void _emitScore() {
    widget.onRoundComplete(ScoreRecord(
      _score,
      DateTime.now(),
      levelId: widget.level.id,
      levelName: widget.level.title,
    ));
    setState(() => _statusMessage = 'Round over — $_score pts');
  }

  void _submitAnswer() {
    if (_roundFinished) return;
    final attempt = _controller.text.trim().toLowerCase();
    if (attempt.isEmpty) return;

    if (attempt == _currentPrompt.answer.toLowerCase()) {
      final reward = widget.level.baseScore + _timeLeft.round();
      setState(() {
        _score += reward;
        _currentBest = _score > _currentBest ? _score : _currentBest;
        _feedback = 'Correct! +$reward pts';
        _controller.clear();
        _currentPrompt = _pickRandomPrompt();
      });
    } else {
      setState(() => _feedback = 'Try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_timeLeft / widget.level.roundDuration).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: StatCard(label: 'Score', value: _score)),
                  const SizedBox(width: 10),
                  Expanded(child: StatCard(label: 'Best', value: _currentBest)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: LinearProgressIndicator(value: progress, minHeight: 8, color: widget.level.accent),
              ),
              const SizedBox(height: 12),
              Text(_statusMessage, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              WordPromptCard(prompt: _currentPrompt),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type your answer',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onSubmitted: (_) => _submitAnswer(),
              ),
              const SizedBox(height: 6),
              Text(_feedback, style: const TextStyle(color: Colors.lightGreenAccent)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startRound,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: widget.level.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(_roundFinished ? 'Restart Round' : 'Start Round',
                    style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
