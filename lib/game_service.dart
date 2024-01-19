import 'package:ui_challenge/game.dart';

class GameService {
  Player? _isWinner(List<CellState> row) {
    final rowSet = Set.from(row);

    return rowSet.length == 1 && rowSet.first != CellState.empty
        ? rowSet.first == CellState.x
            ? Player.x
            : Player.o
        : null;
  }

  Player? checkWinner(List<List<CellState>> board) {
    final size = board.length;

    // Check row
    for (var i = 0; i < size; i++) {
      final winner = _isWinner(board[i]);
      if (winner != null) {
        return winner;
      }
    }

    // Check column
    for (var i = 0; i < size; i++) {
      final winner = _isWinner(List.generate(size, (index) => board[index][i]));
      if (winner != null) {
        return winner;
      }
    }

    // Check right diagonal
    final winner =
        _isWinner(List.generate(size, (index) => board[index][index]));
    if (winner != null) {
      return winner;
    }

    // check left diagonal
    final leftWinner = _isWinner(
        List.generate(size, (index) => board[index][size - index - 1]));

    return leftWinner;
  }

  bool checkGameOver(List<List<CellState>> board) {
    final flattened = board.expand((i) => i).toList();

    return flattened.every((e) => e != CellState.empty) ||
        checkWinner(board) != null;
  }
}
