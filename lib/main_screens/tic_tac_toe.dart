import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:horizon/components/gradient_button.dart';
import 'package:horizon/constants/index.dart';
import 'package:horizon/main_screens/index.dart';

class TicTacToeHomeScreen extends StatefulWidget {
  const TicTacToeHomeScreen({super.key});

  @override
  State<TicTacToeHomeScreen> createState() => _TicTacToeHomeScreenState();
}

class _TicTacToeHomeScreenState extends State<TicTacToeHomeScreen> {
  TextEditingController player1Controller = TextEditingController();
  TextEditingController player2Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // double widthP = Dimensions.myWidthThis(context);
    double heightF = Dimensions.heightF(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration:
            BoxDecoration(gradient: LinearGradient(colors: [black, darkBlue])),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
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
              Gap(150 * Dimensions.heightF(context)),
              Text(
                "Welcome to Tic Tac Toe",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: white),
              ),
              SizedBox(
                height: 30 * heightF,
              ),
              TextFormField(
                controller: player1Controller,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderSide: BorderSide(color: white)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: white),
                  ),
                  errorBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: white)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: white)),
                  hintText: 'Player 1- Enter your name (X)',
                  hintStyle: TextStyle(color: white),
                ),
              ),
              SizedBox(
                height: 30 * heightF,
              ),
              TextFormField(
                controller: player2Controller,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderSide: BorderSide(color: white)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: white),
                  ),
                  errorBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: white)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: white)),
                  hintText: 'Player 2- Enter your name (O)',
                  hintStyle: TextStyle(color: white),
                ),
              ),
              SizedBox(
                height: 30 * heightF,
              ),
              Visibility(
                visible: player1Controller.text.isNotEmpty &&
                    player2Controller.text.isNotEmpty,
                child: GradientButton(
                    onTap: () {
                      RoutingService.goto(
                        context,
                        GameScreen(
                          player1Name: player1Controller.text,
                          player2Name: player2Controller.text,
                          isComputerOpponent: false,
                        ),
                      );
                    },
                    text: "Play with a Friend"),
              ),
              const SizedBox(
                height: 20,
              ),
              GradientButton(
                  onTap: () {
                    if (player1Controller.text.isNotEmpty &&
                        player2Controller.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'This feature is not available with two players'),
                        ),
                      );
                    } else if (player1Controller.text.isNotEmpty) {
                      RoutingService.goto(
                        context,
                        GameScreen(
                          player1Name: player1Controller.text,
                          player2Name: 'Computer',
                          isComputerOpponent: true,
                        ),
                      );
                    } else {
                      // Show a dialog or snackbar if player1Controller.text is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Player 1 name cannot be empty.'),
                        ),
                      );
                    }
                  },
                  text: "Play against Computer"),
            ],
          ),
        ),
      ),
    );
  }
}
