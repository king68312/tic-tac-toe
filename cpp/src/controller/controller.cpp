#include "controller.h"

#include <termios.h>
#include <unistd.h>

#include <iostream>
#include <limits>
#include <string>
#include <vector>

#include "view.h"
bool playGame() {
  std::vector<std::string> board(9, " ");
  // oのターン、xのターンを交互に繰り返す
  int pos;
  board[4] = "o";  // 初期状態で中央にoを置く
  for (int i = 0; i < 8; i++) {
    printGuide();
    printBoard(board);
    pos = selectCell(board);
    if (pos == -1) {
      printQuit();
      return false;
    }
    if (i % 2 == 0) {
      board[pos] = "x";
    } else {
      board[pos] = "o";
    }

    // x先行でそのあとはoと交互に入力する
    if (judge(board) != "") {
      printResult(board, judge(board));
      return true;
    }
  }

  printResult(board, "");
  return true;
}

bool retry() {
  char choice;
  printRetryPrompt();
  std::cin >> choice;
  std::cin.ignore(std::numeric_limits<std::streamsize>::max(),
                  '\n');  // 入力バッファをクリア
  if (choice == 'y' || choice == 'Y') {
    return true;
  } else {
    printQuit();
    return false;
  }
}

void enableRawMode() {  // ここでは、端末を生のモードに設定するために termios
                        // 構造体を使用しています。生のモードでは、入力が即座に取得され、エコーが無効になります。
  termios term;
  tcgetattr(STDIN_FILENO, &term);    // 現在の端末設定を取得
  term.c_lflag &= ~(ICANON | ECHO);  // ICANONを無効にして、入力を即座に取得する
  term.c_cc[VMIN] = 1;               // 最小入力文字数を1に設定
  term.c_cc[VTIME] = 0;              // タイムアウトを無効に設定
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &term);  // 端末設定を即座に反映
}

void disableRawMode() {
  termios term;
  tcgetattr(STDIN_FILENO, &term);
  term.c_lflag |=
      (ICANON | ECHO);  // ICANONを有効にして、入力をバッファリングする
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &term);
}

Key readKey() {
  char cmd;
  std::cin.get(cmd);
  if (cmd == 27) {
    std::cin.get(cmd);
    std::cin.get(cmd);
    if (cmd == 'A') return Key::kUp;
    if (cmd == 'B') return Key::kDown;
    if (cmd == 'C') return Key::kRight;
    if (cmd == 'D') return Key::kLeft;
  }
  if (cmd == '\n' || cmd == ' ') return Key::kEnter;  // Enter かスペース (追加)
  if (cmd == 'q') return Key::kQuit;
  return Key::kOther;  // どれでもないキー (追加)
}

Position movePosition(Position pos, Key key) {
  if (key == Key::kUp && pos.row > 0) pos.row--;
  if (key == Key::kDown && pos.row < 2) pos.row++;
  if (key == Key::kLeft && pos.col > 0) pos.col--;
  if (key == Key::kRight && pos.col < 2) pos.col++;
  return pos;
}

// 矢印キーでマスを選んで、そのマスの番号 (0〜8) を返す (追加)
// printBoard で盤面を表示した直後に呼ぶ。q で中断したら -1 を返す
int selectCell(const std::vector<std::string>& board) {
  saveOrigin();  // 盤面のすぐ下を覚える
  enableRawMode();

  Position cursor{1, 1};
  showCursor(cursor);
  while (true) {
    Key key = readKey();

    if (key == Key::kQuit) {  // q: 中断して -1 を返す
      backToOrigin();
      disableRawMode();
      return -1;
    }

    if (key == Key::kEnter) {  // Enter: 空いているマスなら、その番号を返す
      int cell = toIndex(cursor);
      if (board[cell] == " ") {
        backToOrigin();
        disableRawMode();
        return cell;
      }
    }

    cursor = movePosition(cursor, key);
    showCursor(cursor);
  }
}
