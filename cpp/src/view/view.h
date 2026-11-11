#pragma once

#include <string>
#include <vector>

#include "model.h"

void saveOrigin();
void backToOrigin();
void showCursor(Position pos);
void printBoard(const std::vector<std::string>& board);
void printGuide();
void printQuit();
void printRetryPrompt();
void printResult(const std::vector<std::string>& board,
                 const std::string& winner);
