--[[
	Name: Pong
	Author: Elisha Montgomery
	Description: This project is designed to replicate the classic game Pong. The main goal of doing this is to learn basic game development concepts
	such as:
	- Game loops
	- Game States
	- Object Oriented Programming
	- Drawing Shapes and Text
	- DeltaTime and Velocity
	- Collisions
	And learning more specifically about Lua and Love2D.
]]

-- Defining Variables for window size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Called once at the beginning of the game. Used for initialization
function love.load()
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { -- Initializing Window Size
		fullscreen = false,
		vsync = 1,
		resizable = false
	})
end

-- Callback function used to draw on the screen every frame
function love.draw()
	love.graphics.printf( -- Printing 'This is Pong' on the screen and centering it horizontally and vertically
		'This is Pong',
		0,
		WINDOW_HEIGHT / 2 - 6,
		WINDOW_WIDTH,
		'center')
end