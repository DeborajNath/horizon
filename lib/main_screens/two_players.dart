import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:horizon/constants/index.dart';
import 'package:horizon/provider/index.dart';
import 'package:provider/provider.dart';
import 'package:squares/squares.dart';

class TwoPlayersScreen extends StatefulWidget {
  const TwoPlayersScreen({super.key});

  @override
  State<TwoPlayersScreen> createState() => _TwoPlayersScreenState();
}

class _TwoPlayersScreenState extends State<TwoPlayersScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameProvider =
          Provider.of<TwoPlayersProvider>(context, listen: false);
      gameProvider.resetGame();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TwoPlayersProvider gameProvider =
        Provider.of<TwoPlayersProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context);
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [black, darkBlue],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      RoutingService.goBack(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              Gap(30 * Dimensions.heightF(context)),
              _buildPlayerTime(
                  "Player 2 (Black)", gameProvider.blackTime, 15, 15, 0, 0),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: BoardController(
                  state: gameProvider.flipBoard
                      ? gameProvider.state.board.flipped()
                      : gameProvider.state.board,
                  playState: gameProvider.state.state,
                  pieceSet: PieceSet.merida(),
                  theme: BoardTheme.brown,
                  moves: gameProvider.state.moves,
                  onMove: (move) {
                    gameProvider.makeMove(move, context);
                  },
                ),
              ),
              _buildPlayerTime(
                  "Player 1 (White)", gameProvider.whiteTime, 0, 0, 15, 15),
              Gap(30 * Dimensions.heightF(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: gameProvider.resetGame,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: white),
                      ),
                      child: Center(
                        child: Text(
                          "New Game",
                          style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: gameProvider.flipBoardState,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: white),
                      ),
                      child: Center(
                        child: Text(
                          "Flip Board",
                          style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerTime(
    String playerName,
    Duration time,
    double borderRadiusTopLeft,
    double borderRadiusTopRight,
    double borderRadiusBottomLeft,
    double borderRadiusBottomRight,
  ) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: white),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadiusTopLeft),
            topRight: Radius.circular(borderRadiusTopRight),
            bottomLeft: Radius.circular(borderRadiusBottomLeft),
            bottomRight: Radius.circular(borderRadiusBottomRight),
          ),
          gradient: LinearGradient(colors: [black, white, black])),
      child: ListTile(
        title: Text(
          playerName,
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 18, color: white),
        ),
        trailing: Text(
          "${time.inMinutes}:${(time.inSeconds % 60).toString().padLeft(2, '0')}",
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 18, color: white),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Do you really want to exit?"),
            content: const Text("Your ongoing game will be dismissed"),
            actions: [
              TextButton(
                onPressed: () =>
                    RoutingService.goBack(context), // Stay on the screen
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  final TwoPlayersProvider gameProvider =
                      Provider.of<TwoPlayersProvider>(context, listen: false);
                  gameProvider
                      .disposeTimers(); // Dispose timers or other resources
                  RoutingService.goBack(context); // Exit the screen
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        ) ??
        false; // Default to false if dialog is dismissed
  }
}
