#pragma once
#include <string>
#include <vector>

std::string judge(std::vector<std::string> board);

struct Position {
  int row;
  int col;
};

const int LINES[8][3] = {
    {0, 1, 2}, {3, 4, 5}, {6, 7, 8},  // rows
    {0, 3, 6}, {1, 4, 7}, {2, 5, 8},  // columns
    {0, 4, 8}, {2, 4, 6}              // diagonals
};

int toIndex(Position pos);
