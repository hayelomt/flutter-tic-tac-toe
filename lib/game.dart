import 'package:ui_challenge/game_service.dart';

enum CellState { x, o, empty }

enum Player { x, o }

List<List<CellState>> initBoard(int size) {
  return List.generate(
      size, (_) => List.generate(size, (_) => CellState.empty));
}

class Game {
  final List<List<CellState>> board;
  final Player curPlayer;
  final Player? winner;
  final bool gameOver;

  Game({
    required this.board,
    required this.curPlayer,
    required this.winner,
    required this.gameOver,
  });

  factory Game.initial([int boardSize = 3]) {
    return Game(
      board: initBoard(boardSize),
      curPlayer: Player.o,
      winner: null,
      gameOver: false,
    );
  }

  Game copyWith({
    List<List<CellState>>? board,
    Player? curPlayer,
    Player? winner,
    bool? gameOver,
  }) {
    return Game(
      board: board ?? this.board,
      curPlayer: curPlayer ?? this.curPlayer,
      winner: winner ?? this.winner,
      gameOver: gameOver ?? this.gameOver,
    );
  }

  Game setCell(int x, int y) {
    if (board[x][y] != CellState.empty) {
      return this;
    }

    final newBoard = List<List<CellState>>.from(board);
    newBoard[x][y] = curPlayer == Player.x ? CellState.x : CellState.o;

    return copyWith(
      board: newBoard,
      curPlayer: curPlayer == Player.x ? Player.o : Player.x,
    );
  }
}
