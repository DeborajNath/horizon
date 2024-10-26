import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';

class TwoPlayersProvider extends ChangeNotifier {
  late bishop.Game game;
  late SquaresState state;
  int currentPlayer = Squares.white;
  bool flipBoard = false;

  Duration whiteTime = const Duration(minutes: 10);
  Duration blackTime = const Duration(minutes: 10);
  Timer? timer;

  twoPlayersGame() {
    resetGame(false);
    startTimer();
  }

  TwoPlayersProvider() {
    twoPlayersGame();
  }
  void resetGame([bool ss = true]) {
    log("Resetting game");
    game = bishop.Game(variant: bishop.Variant.standard());
    currentPlayer = Squares.white;
    log("Current player reset to white");
    state = game.squaresState(currentPlayer);
    whiteTime = const Duration(minutes: 10);
    blackTime = const Duration(minutes: 10);
    startTimer();
    if (ss) notifyListeners();
  }

  void startTimer([BuildContext? context]) {
    timer?.cancel();

    if (currentPlayer == Squares.white) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (whiteTime > const Duration(seconds: 0)) {
          whiteTime -= const Duration(seconds: 1);
          notifyListeners();
        } else {
          timer.cancel();
          if (context != null) {
            showTimeOverDialog(context,
                "Player 1 (White) time is over, Player 2 (Black) wins");
          }
        }
      });
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (blackTime > const Duration(seconds: 0)) {
          blackTime -= const Duration(seconds: 1);
          notifyListeners();
        } else {
          timer.cancel();
          if (context != null) {
            showTimeOverDialog(context,
                "Player 2 (Black) time is over, Player 1 (White) wins");
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

  void makeMove(Move move, BuildContext context) {
    bool result = game.makeSquaresMove(move);
    if (result) {
      currentPlayer =
          (currentPlayer == Squares.white) ? Squares.black : Squares.white;
      state = game.squaresState(currentPlayer);
      timer?.cancel();
      startTimer(context);
      flipBoardState();
      notifyListeners();
    }
  }

  void disposeTimers() {
    timer?.cancel();
  }
}
