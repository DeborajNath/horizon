import 'dart:async';
import 'dart:math';
import 'dart:developer' as logs;
import 'package:flutter/material.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';

class ChessGameComputerProvider extends ChangeNotifier {
  late bishop.Game game;
  late SquaresState state;
  int currentPlayer = Squares.white;
  bool flipBoard = false;
  bool isAiThinking = false;

  Duration whiteTime = const Duration(minutes: 10);
  Duration blackTime = const Duration(minutes: 10);
  Timer? timer;

  ChessGameComputerProvider() {
    startNewGame();
  }

  void startNewGame() {
    resetGame(false);
    startTimer();
  }

  void resetGame([bool ss = true]) {
    logs.log("Resetting game");
    game = bishop.Game(variant: bishop.Variant.standard());
    currentPlayer = Squares.white;
    logs.log("Current player set to white (user)");
    state = game.squaresState(currentPlayer);
    whiteTime = const Duration(minutes: 10);
    blackTime = const Duration(minutes: 10);
    startTimer();

    if (ss) notifyListeners();
  }

  void startTimer([BuildContext? context]) {
    timer?.cancel();

    if (currentPlayer == Squares.white) {
      // White (Player) Timer
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (whiteTime > Duration.zero) {
          whiteTime -= const Duration(seconds: 1);
          notifyListeners();
        } else {
          timer.cancel();
          if (context != null) {
            showTimeOverDialog(
                context, "Player (White) time is over, Computer (Black) wins");
          }
        }
      });
    } else {
      // Black (Computer) Timer
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (blackTime > Duration.zero) {
          blackTime -= const Duration(seconds: 1);
          notifyListeners();
        } else {
          timer.cancel();
          if (context != null) {
            showTimeOverDialog(
                context, "Computer (Black) time is over, Player (White) wins");
          }
        }
      });
    }
  }

  void showTimeOverDialog(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("Restart"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                resetGame(false); // Reset the game after the dialog is closed
              },
            ),
          ],
        );
      },
    );
  }

  void flipBoardState() {
    flipBoard = !flipBoard;
    notifyListeners();
  }

  Future<void> makeMove(Move move, BuildContext context) async {
    bool result = game.makeSquaresMove(move);
    if (result) {
      currentPlayer = Squares.black; // Switch to computer
      state = game.squaresState(currentPlayer);
      timer?.cancel();
      startTimer(context);
      flipBoardState();
      notifyListeners();
      await _makeAiMove(context); // Computer move after player
    }
  }

  Future<void> _makeAiMove(BuildContext context) async {
    isAiThinking = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: Random().nextInt(3000) + 1000));

    game.makeRandomMove();
    currentPlayer = Squares.white;
    state = game.squaresState(currentPlayer);
    timer?.cancel();
    startTimer(context);
    flipBoardState();
    isAiThinking = false;
    notifyListeners();
  }

  void disposeTimers() {
    timer?.cancel();
  }
}
