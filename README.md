# Tic Tac Toe extended

[![Travis](https://img.shields.io/travis/kolybasov/tic-tac-toe-extended.svg?maxAge=3600)](https://travis-ci.org/kolybasov/tic-tac-toe-extended)

![screenshot]( https://i.imgur.com/TqxRUeT.png )
![screenshot]( https://i.imgur.com/ZsbymPz.png )

## Run

1. Install elm platform and create-elm-app `$ npm install -g elm create-elm-app`
2. Clone repository `$ git clone https://github.com/kolybasov/tic-tac-toe-extended.git`
3. Run dev server `$ cd tic-tac-toe-extended && elm-app start`

## TODO

* [x] Draw board, field, cell
* [x] Add basic styles
* [x] Add ability to take cell on click
* [x] Switch current player
* [x] Add ability to take only allowed cell in the allowed field
* [X] Detect field state (Winner(X/O), Draw, Active)
* [x] Detect board state ⇑ (same as top)
* [x] Add new game button
* [ ] Allow to choose player name
* [x] Show current player
* [ ] Add multiplayer
  * [ ] Create API [probably link to server](https://gihub.com/kolybasov/tic-tac-toe-extended-server)
  * [ ] Integrate with app
  * [ ] Allow to create room
  * [ ] Allow to join room by id or share link
* [ ] Add better styles
* [ ] Add touch support and optimize for mobile
