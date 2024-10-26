import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:horizon/constants/index.dart';
import 'package:horizon/provider/index.dart';
import 'package:provider/provider.dart';
import 'package:squares/squares.dart';

class ChessGameComputer extends StatefulWidget {
  const ChessGameComputer({super.key});

  @override
  State<ChessGameComputer> createState() => _ChessGameComputerState();
}

class _ChessGameComputerState extends State<ChessGameComputer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chessGameComputerProvider =
          Provider.of<ChessGameComputerProvider>(context, listen: false);
      chessGameComputerProvider.resetGame(true); // Initialize game vs AI
    });
  }

  @override
  Widget build(BuildContext context) {
    final chessGameComputerProvider =
        Provider.of<ChessGameComputerProvider>(context);
    final state = chessGameComputerProvider.state;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [black, darkBlue]),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Row(
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
            ),
            Gap(30 * Dimensions.heightF(context)),
            _buildPlayerTime(
                "StockFish", chessGameComputerProvider.blackTime, 12, 12, 0, 0),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: BoardController(
                state: chessGameComputerProvider.flipBoard
                    ? state.board.flipped()
                    : state.board,
                playState: state.state,
                pieceSet: PieceSet.merida(),
                theme: BoardTheme.brown,
                moves: state.moves,
                onMove: (move) =>
                    chessGameComputerProvider.makeMove(move, context),
                onPremove: (move) =>
                    chessGameComputerProvider.makeMove(move, context),
                markerTheme: MarkerTheme(
                  empty: MarkerTheme.dot,
                  piece: MarkerTheme.corners(),
                ),
                promotionBehaviour: PromotionBehaviour.autoPremove,
              ),
            ),
            _buildPlayerTime(
                "User", chessGameComputerProvider.whiteTime, 0, 0, 12, 12),
            Gap(30 * Dimensions.heightF(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: chessGameComputerProvider.resetGame,
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
                  onTap: chessGameComputerProvider.flipBoardState,
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
            ),
          ],
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
}
