CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -Wmissing-declarations
CPPFLAGS = -Isrc/model -Isrc/view -Isrc/controller
LDLIBS = -lgtest -lgtest_main -pthread

SRCS = src/main.cpp src/model/model.cpp src/view/view.cpp src/controller/controller.cpp
HEADERS = src/model/model.h src/view/view.h src/controller/controller.h

.PHONY: all test clean

all: game

game: $(SRCS) $(HEADERS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(SRCS) -o $@

# テストはルール (model) だけとリンクする
board_test: tests/board_test.cpp src/model/model.cpp src/model/model.h
	$(CXX) $(CXXFLAGS) -Isrc/model tests/board_test.cpp src/model/model.cpp $(LDLIBS) -o $@

test: board_test
	./board_test

clean:
	rm -f game board_test
