import 'package:flutter_test/flutter_test.dart';
import 'package:ui_challenge/game.dart';
import 'package:ui_challenge/game_service.dart';

void main() {
  group('GameService.getWinner', () {
    final gameService = GameService();

    test('getWinner returns null if there is no winner', () {
      final board = [
        [CellState.x, CellState.o, CellState.x],
        [CellState.o, CellState.x, CellState.o],
        [CellState.o, CellState.x, CellState.o],
      ];

      final winner = gameService.checkWinner(board);

      expect(winner, null);
    });

    test('getWinner returns the correct winner for a row', () {
      final board = [
        [CellState.x, CellState.x, CellState.x],
        [CellState.o, CellState.empty, CellState.o],
        [CellState.o, CellState.o, CellState.empty],
      ];

      final winner = gameService.checkWinner(board);

      expect(winner, Player.x);
    });

    test('getWinner returns the correct winner for a column', () {
      final board = [
        [CellState.x, CellState.o, CellState.x],
        [CellState.x, CellState.empty, CellState.o],
        [CellState.x, CellState.o, CellState.empty],
      ];

      final winner = gameService.checkWinner(board);

      expect(winner, Player.x);
    });

    test('getWinner returns the correct winner for a right diagonal', () {
      final board = [
        [CellState.x, CellState.o, CellState.x],
        [CellState.o, CellState.x, CellState.o],
        [CellState.x, CellState.o, CellState.x],
      ];

      final winner = gameService.checkWinner(board);

      expect(winner, Player.x);
    });

    test('getWinner returns the correct winner for a left diagonal', () {
      final board = [
        [CellState.x, CellState.o, CellState.x],
        [CellState.o, CellState.x, CellState.o],
        [CellState.x, CellState.o, CellState.x],
      ];

      final winner = gameService.checkWinner(board);

      expect(winner, Player.x);
    });
  });

  group('GameService.gameOver', () {
    final gameService = GameService();

    test(
        'gameOver returns true if all cells are different from empty and there is no winner',
        () {
      final board = [
        [CellState.x, CellState.o, CellState.x],
        [CellState.o, CellState.x, CellState.o],
        [CellState.o, CellState.x, CellState.o],
      ];

      final gameOver = gameService.checkGameOver(board);

      expect(gameOver, true);
    });

    test('gameOver returns false if there is an empty cell', () {
      final board = [
        [CellState.x, CellState.o, CellState.x],
        [CellState.o, CellState.empty, CellState.o],
        [CellState.o, CellState.x, CellState.o],
      ];

      final gameOver = gameService.checkGameOver(board);

      expect(gameOver, false);
    });

    test('gameOver returns true if getWinner returns a non-null value', () {
      final board = [
        [CellState.x, CellState.x, CellState.x],
        [CellState.o, CellState.empty, CellState.o],
        [CellState.o, CellState.o, CellState.empty],
      ];

      final gameOver = gameService.checkGameOver(board);

      expect(gameOver, true);
    });
  });
}
