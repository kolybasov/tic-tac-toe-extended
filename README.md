# Tic Tac Toe extended

![screenshot]( https://i.imgur.com/l1ERsI7.png )

## Run

1. Install elm platform and create-elm-app `$ npm install -g elm create-elm-app`
2. Clone repository `$ git clone https://github.com/kolybasov/tic-tac-toe-extended.git`
3. Run dev server `$ cd tic-tac-toe-extended && elm-app start`

## TODO

* [x] Draw board, field, cell
* [x] Add basic styles
* [x] Add ability to take cell on click
* [ ] Switch current player
* [ ] Add ability to take only allowed cell in the allowed field
* [ ] Detect field state (Winner(X/O), Draw, Active)
* [ ] Detect board state ⇑ (same as top)
* [ ] Allow to choose player name
* [ ] Add multiplayer
  * [ ] Create API [probably link to server](https://gihub.com/kolybasov/tic-tac-toe-extended-server)
  * [ ] Allow to create room
  * [ ] Allow to join room by id or share link
* [ ] Add better styles
* [ ] Add touch support and optimize for mobile
