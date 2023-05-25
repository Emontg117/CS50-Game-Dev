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

	-- Creating and setting the font defined in the 'font.ttf' file to get a more pixelated font look instead of using the default Love2D font
	font = love.graphics.newFont('font.ttf', 8) -- font file & font size
	love.graphics.setFont(font)

	-- Initializing the window using the push library's setupScreen function to apply a virtual resolution to the regular window
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { 
	pixelperfect = false,
	fullscreen = false,
	vsync = true,
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

	-- Setting default draw color to change color of text and images. Love2D uses RGB values 0-1 instead of 0-255, so we have to divide the normal value by 255
	love.graphics.setColor(57/255, 255/255, 20/255, 1)

	-- Defining variables for the size of the ball and paddles
	paddleSizeX = 5
	paddleSizeY = 21
	ballSize = 6

	-- Clearing the screen every frame so we can update what is on screen
	love.graphics.clear()

	-- Printing 'This is Pong' near the top of the screen and centering it horizontally
	-- We are referencing the virtual resolution for positioning rather than window resolution so that it can be rendered correctly
	love.graphics.printf('This is Pong', 0, 20, VIRTUAL_WIDTH, 'center')

	-- Using the Love2D rectangle function to draw paddles and a ball
	love.graphics.rectangle('fill', 10, 30, paddleSizeX, paddleSizeY)
	love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10 - paddleSizeX, VIRTUAL_HEIGHT - 20 - paddleSizeX, paddleSizeX, paddleSizeY)
	love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - (ballSize / 2), VIRTUAL_HEIGHT / 2 - (ballSize / 2), ballSize, ballSize)

	push:finish() -- Stop rendering using push and virtual resolution
end