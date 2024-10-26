import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:horizon/components/gradient_button.dart';
import 'package:horizon/constants/index.dart';
import 'package:horizon/main_screens/tic_tac_toe.dart';

class GameScreen extends StatefulWidget {
  final String player1Name;
  final String? player2Name;
  final bool isComputerOpponent;

  const GameScreen(
      {super.key,
      required this.player1Name,
      this.player2Name,
      this.isComputerOpponent = false});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String currentPlayer = '';
  List<String> symbols = ['X', 'O'];
  int currentSymbolIndex = 0;
  List<String?> gridValues = List.filled(9, null);
  Random random = Random();

  @override
  void initState() {
    super.initState();
    currentPlayer = widget.player1Name;
  }

  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.widthP(context);
    double heightF = Dimensions.heightF(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [black, darkBlue],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 10 * widthP, vertical: 50 * heightF),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              Gap(120 * Dimensions.heightF(context)),
              Row(
                children: [
                  Expanded(
                      child: GradientButton(
                          onTap: () {
                            resetGame();
                          },
                          text: "Play Again")),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: GradientButton(
                          onTap: () {
                            RoutingService.gotoWithoutBack(
                                context, const TicTacToeHomeScreen());
                          },
                          text: "Quit game")),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (gridValues[index] == null) {
                          gridValues[index] = symbols[currentSymbolIndex];
                          currentSymbolIndex =
                              (currentSymbolIndex + 1) % symbols.length;
                          // Check for winner or draw
                          checkGameStatus();

                          // If playing against computer, trigger the computer's move
                          if (widget.isComputerOpponent) {
                            computerMove();
                          }
                        }
                        setState(() {});
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: white),
                        ),
                        child: Center(
                          child: gridValues[index] != null
                              ? Text(
                                  gridValues[index]!,
                                  style: TextStyle(fontSize: 40, color: white),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method for computer's move
  void computerMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      // Choose a random available spot for the computer
      List<int> availableSpots = [];
      for (int i = 0; i < 9; i++) {
        if (gridValues[i] == null) {
          availableSpots.add(i);
        }
      }
      if (availableSpots.isNotEmpty) {
        int randomSpot = availableSpots[random.nextInt(availableSpots.length)];
        gridValues[randomSpot] = symbols[currentSymbolIndex];
        currentSymbolIndex = (currentSymbolIndex + 1) % symbols.length;
        checkGameStatus();
        setState(() {});
      }
    });
  }

  resetGame() {
    gridValues = List.filled(9, null);
    currentSymbolIndex = 0;
    setState(() {});
  }

  checkGameStatus() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (gridValues[i] != null &&
          gridValues[i] == gridValues[i + 1] &&
          gridValues[i] == gridValues[i + 2]) {
        showWinnerDialog(gridValues[i]!);
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (gridValues[i] != null &&
          gridValues[i] == gridValues[i + 3] &&
          gridValues[i] == gridValues[i + 6]) {
        showWinnerDialog(gridValues[i]!);
        return;
      }
    }

    // Check diagonals
    if (gridValues[0] != null &&
        gridValues[0] == gridValues[4] &&
        gridValues[0] == gridValues[8]) {
      showWinnerDialog(gridValues[0]!);
      return;
    }
    if (gridValues[2] != null &&
        gridValues[2] == gridValues[4] &&
        gridValues[2] == gridValues[6]) {
      showWinnerDialog(gridValues[2]!);
      return;
    }

    // Check for draw
    bool isDraw = true;
    for (int i = 0; i < 9; i++) {
      if (gridValues[i] == null) {
        isDraw = false;
        break;
      }
    }
    if (isDraw) {
      showDrawDialog();
    }
  }

  showWinnerDialog(String symbol) {
    String winnerName =
        (symbol == 'X') ? widget.player1Name : widget.player2Name!;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$winnerName wins!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('Play Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicTacToeHomeScreen(),
                  ),
                );
              },
              child: const Text('Quit Game'),
            ),
          ],
        );
      },
    );
  }

  showDrawDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('It\'s a draw!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('Play Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicTacToeHomeScreen(),
                  ),
                );
              },
              child: const Text('Quit Game'),
            ),
          ],
        );
      },
    );
  }
}
