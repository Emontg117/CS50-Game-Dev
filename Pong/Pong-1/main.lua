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

-- "Push is a simple resolution-handling library that allows you to focus on making your game with a fixed resolution." - as stated on the github page.
-- In this case we're using it to render the game at a lower resolution while keeping the window at our original size so we can get the pong look while making the game easily visible
push = require 'push'

-- Defining Variables for window resolution and virtual game resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Called once at the beginning of the game. Used for initialization
function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest') -- Setting Love2D's rendering filter to point or 'nearest' filter so we can retain the pixelated look of orignal pong

	-- Initializing the window using the push library's setupScreen function to apply a virtual resolution to the regular window
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { 
	pixelperfect = true,
	fullscreen = false,
	vsync = 1,
	resizable = false
	})
end

-- Native Love2D function for detecting keyboard input
function love.keypressed(key)
	if(key == 'escape') then -- Quit the game by pressing the 'Escape' key rather than needing to hit the X button on the window
		love.event.quit()
		end
end

-- Callback function used to draw on the screen every frame
function love.draw()
	push:start() -- Start rendering using push and virtual resolution
	love.graphics.printf( -- Printing 'This is Pong' on the screen and centering it horizontally and vertically
		'This is Pong',
		0,
		VIRTUAL_HEIGHT / 2 - 6, -- We have changed this to reference the virtual resolution for positioning rather than window resolution so that it can be rendered correctly
		VIRTUAL_WIDTH,
		'center')
	push:finish() -- Stop rendering using push and virtual resolution
end