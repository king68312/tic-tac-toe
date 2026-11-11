#pragma once

#include <string>
#include <vector>

#include "model.h"

enum class Key { kUp, kDown, kLeft, kRight, kEnter, kQuit, kOther };

// main.cpp
bool playGame();
bool retry();

void enableRawMode();
void disableRawMode();

Key readKey();
Position movePosition(Position pos, Key key);
int selectCell(const std::vector<std::string>& board);
