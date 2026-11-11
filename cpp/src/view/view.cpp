#include "view.h"

#include <iostream>
#include <string>
#include <vector>

void saveOrigin() {  // 端末のカーソル位置を保存する
  std::cout << "\0337" << std::flush;
}  // std::flashはバッファをフラッシュするためのもので、出力を即座に表示するために使用されます。

// 端末のカーソル位置を元に戻す
void backToOrigin() { std::cout << "\0338" << std::flush; }
//\0338 ESC 8 端末のカーソル位置を保存した位置に戻す

void showCursor(Position pos) {
  backToOrigin();
  std::cout << "\033[" << (5 - pos.row * 2) << "A"  // 上に移動
            << "\033[" << (pos.col * 4 + 1) << "G"  // 左に移動
            << std::flush;
}

void printBoard(const std::vector<std::string>& board) {
  for (int i = 0; i < 9; i++) {
    std::cout << board[i] << " " << " ";
    if (i % 3 != 2) {
      std::cout << "|";
    } else {
      std::cout << std::endl;
      if (i != 8) {
        std::cout << "-----------" << std::endl;
      }
    }
  }
}

void printGuide() { std::cout << "矢印キーで移動(q で終了)" << std::endl; }

void printQuit() { std::cout << "ゲームを終了します。" << std::endl; }

void printRetryPrompt() {
  std::cout << "もう一度プレイしますか？(y/n): " << std::flush;
}

// winner が "" なら引き分けとして表示する
void printResult(const std::vector<std::string>& board,
                 const std::string& winner) {
  std::cout << "                " << std::endl;
  std::cout << "------結果------" << std::endl;
  std::cout << "                " << std::endl;
  printBoard(board);
  std::cout << "                " << std::endl;
  if (winner != "") {
    std::cout << "勝者は: " << winner << std::endl;
  } else {
    std::cout << "引き分け" << std::endl;
  }
}
