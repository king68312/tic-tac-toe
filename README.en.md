# sanmokunarabe

English | [日本語](README.md)

A terminal tic-tac-toe game (○× game), implemented in several languages and architectures as a learning project.

```
Arrow keys to move (q to quit)
x  |   |
-----------
   |o  |
-----------
   |   |
```

The same game is written in each language, so you can compare how the design ideas differ.

## Status by language

| Language | Architecture | Status | Location |
|---|---|---|---|
| C++ | MVC | Playable (tests: in progress) | [cpp/](cpp/) |
| Rust | — | TODO | — |
| Elm | The Elm Architecture | TODO | — |
| Haskell | — | TODO | — |

## TODO

This project is still a work in progress.

- [x] C++: playable with an MVC structure
- [ ] C++: Model tests (`judge`, cursor movement, turn switching) — in progress
- [ ] Rust version
- [ ] Elm version
- [ ] Haskell version

## Rules

- The game starts with an `o` already placed in the center. `x` goes first, and the players take turns.
- Three in a row (horizontal, vertical, or diagonal) wins. If the board is full with no winner, it is a draw.
- Move the cursor with the arrow keys, and place a mark with Enter or Space. Press `q` to quit.

The detailed rules and test policy are summarized in [docs/test-spec.md](docs/test-spec.md) (in Japanese). Every implementation follows this spec.

## Design principles

- **The rules (Model) do not use the screen or the keyboard.** Input and output are kept in the outer layers (View / Controller).
- Because of this, only the rules can be built and tested on their own.
- When porting to another language, the rules are rewritten as-is, and only the input and output parts are rewritten in that language's style.

## Directory layout

```
sanmokunarabe/
├── README.md        Japanese version (default)
├── README.en.md     this file (English)
├── docs/
│   └── test-spec.md rules and test spec (shared by all languages)
└── cpp/             C++ version (build instructions in cpp/README.md)
```
