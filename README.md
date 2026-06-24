# L_snake

A half snake game/half experimentation environment made using Lua

### Main Ingredients:
- `grid.lua` Creates a spatial grid with O(1) cell lookup, random empty cell search and a debug view
- `snake.lua` User-input controlled snake
- `apple.lua` ***apple***. You can eat it
- `particles.lua` Wrapper for love2d's Particle System
- `tween.lua` (**PROPERTY OF [KIKITO](https://github.com/kikito/tween.lua)**) Used for animation
- `profile.lua`(**PROPERTY OF [2DENGINE](https://github.com/2dengine/profile.lua)**) Used for capturing the time taken for a function to complete + total time of all functions captured

[Made with LÖVE](https://www.love2d.org/)

### <ins>Instructions For Using Files In Your Own Games</ins>
- Open folder
- Click on file
- Select file and all its other dependencies (snake.lua will not work without tween.lua)
- Ctrl + C
- Open your own game folder
- Ctrl + V
- Open your game's main.lua and require it
