import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:horizon/components/gradient_button.dart';
import 'package:horizon/constants/index.dart';
import 'package:horizon/main_screens/index.dart';
import 'package:horizon/main_screens/two_players.dart';
import 'package:horizon/provider/index.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> items = [
    'Play chess v/s Computer',
    'Play chess (2 players)',
    'Play Tic-Tac-Toe',
  ];
  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [black, darkBlue],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        switch (index) {
                          case 0:
                            RoutingService.goto(
                                context, const ChessGameComputer());
                            break;
                          case 1:
                            RoutingService.goto(
                                context, const TwoPlayersScreen());
                            break;
                          case 2:
                            RoutingService.goto(
                                context, const TicTacToeHomeScreen());
                            break;
                          default:
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: white,
                            )),
                        child: ListTile(
                          title: Text(
                            items[index],
                            style: TextStyle(
                                color: white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                    Gap(45 * Dimensions.heightF(context)),
                  ],
                );
              },
            ),
            GradientButton(
              onTap: () async {
                loginProvider.signOut();
                RoutingService.gotoWithoutBack(context, const LoginPage());
              },
              text: "Logout",
              width: 150,
            ),
          ],
        ),
      ),
    );
  }
}
