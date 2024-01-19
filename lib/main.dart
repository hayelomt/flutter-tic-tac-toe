import 'package:flutter/material.dart';
import 'package:ui_challenge/game.dart';
import 'package:ui_challenge/game_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Game _game = Game.initial();
  final gameService = GameService();

  void onTap(int x, int y) {
    setState(() {
      _game = _game.setCell(x, y).copyWith(
            winner: gameService.checkWinner(_game.board),
            gameOver: gameService.checkGameOver(_game.board),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F3),
      body: SizedBox(
        width: double.maxFinite,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Tic Tac Toe',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Board(onTap: onTap, game: _game),
                ],
              )),
              const SizedBox(height: 20),
              _renderWinner(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderWinner() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _game.gameOver
                  ? TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, value, child) => Transform.scale(
                        scale: value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - value) * -80),
                          child: Opacity(
                            opacity: value / 2 + 0.5,
                            child: Text(
                                _game.winner == null
                                    ? 'Draw'
                                    : '${_game.winner == Player.x ? 'X' : 'O'} wins',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    )
                  : Text(
                      '${_game.curPlayer == Player.x ? 'X' : 'O'}\'s turn',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
              onPressed: () {
                setState(() {
                  _game = Game.initial();
                });
              },
              icon: const Icon(Icons.refresh)),
        )
      ],
    );
  }
}

class Board extends StatelessWidget {
  const Board({
    super.key,
    required this.game,
    required this.onTap,
  });

  final Game game;
  final Function(int, int) onTap;

  @override
  Widget build(BuildContext context) {
    final boardSize = game.board.length;
    final cellSize = MediaQuery.of(context).size.width / (boardSize + 1);

    return Column(
      children: List.generate(
        boardSize,
        (xIndex) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            boardSize,
            (yIndex) => Cell(
              cellSize: cellSize,
              onTap: () => onTap(xIndex, yIndex),
              disabled: game.board[xIndex][yIndex] != CellState.empty ||
                  game.winner != null,
              cellValue: game.board[xIndex][yIndex],
            ),
          ),
        ),
      ),
    );
  }
}

class Cell extends StatefulWidget {
  const Cell({
    super.key,
    required this.cellSize,
    required this.onTap,
    required this.disabled,
    required this.cellValue,
  });

  final double cellSize;
  final VoidCallback onTap;
  final bool disabled;
  final CellState cellValue;

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  double _iconSize = 0;
  bool _tapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disabled
          ? null
          : () {
              setState(() {
                _iconSize = widget.cellSize * 0.6;
              });
              widget.onTap();
            },
      onTapDown: widget.disabled
          ? null
          : (_) {
              setState(() {
                _tapDown = true;
              });
            },
      onTapUp: widget.disabled
          ? null
          : (_) {
              setState(() {
                _tapDown = false;
              });
            },
      onTapCancel: widget.disabled
          ? null
          : () {
              setState(() {
                _tapDown = false;
              });
            },
      child: Container(
        width: widget.cellSize,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(1, 4),
              blurRadius: _tapDown ? 1 : 4,
              spreadRadius: 5,
            )
          ],
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Center(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: _iconSize),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                if (widget.cellValue == CellState.x) {
                  return Icon(
                    Icons.close,
                    size: value,
                    color: Colors.red.shade500,
                  );
                }
                if (widget.cellValue == CellState.o) {
                  return Icon(
                    Icons.circle_outlined,
                    size: value,
                    color: Colors.blue.shade500,
                  );
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
