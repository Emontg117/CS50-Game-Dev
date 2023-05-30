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

	-- Setting seed for math.random to the current time of the OS that constantly changes
	-- Seeding the random number generator ensures a different output each time
	math.randomseed(os.time())

	love.graphics.setDefaultFilter('nearest', 'nearest') -- Setting Love2D's rendering filter to point or 'nearest' filter so we can retain the pixelated look of orignal pong

	-- Creating the font defined in the 'font.ttf' file to get a more pixelated font look instead of using the default Love2D font
	smallFont = love.graphics.newFont('font.ttf', 8) -- font file & font size
	scoreFont = love.graphics.newFont('font.ttf', 32) -- creating a larger font specifically for the score

	-- Initializing the window using the push library's setupScreen function to apply a virtual resolution to the regular window
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { 
	pixelperfect = false,
	fullscreen = false,
	vsync = true,
	resizable = false
	})

	-- Defining variables for the size and speed of the paddles and ball for when we draw them
	paddleWidth = 5
	paddleHeight = 21
	paddleSpeed = 150
	ballSize = 6

	-- Initializing the positions of the paddles and ball on start
	paddleOnePosX = 10
	paddleOnePosY = 20
	paddleTwoPosX = VIRTUAL_WIDTH - 10 - paddleWidth -- Subtracting ten to match paddleOne's horizontal position on the other side, then subtracting the size of the paddle to account for its size
	paddleTwoPosY = VIRTUAL_HEIGHT - 20 - paddleHeight -- Subtracting twenty to match paddleOne's vertical position on the other side, then subtracting the size of the paddle to account for its size
	ballPosX = VIRTUAL_WIDTH / 2 - ballSize
	ballPosY = VIRTUAL_HEIGHT / 2 - ballSize

	-- Initializing velocity variables for the ball
	-- Ball will move in random direction when game plays
	ballDX = math.random(2) == 1 and 100 or -100
	ballDY = math.random(-50, 50)

	-- Initializing score variables for players
	playerOneScore = 0
	playerTwoScore = 0

	-- Initializing gameState variable so we can use it later for playing, pausing, resetting, etc.
	--[[
	DEFINITIONS:
	'start' = Before the game is playing. We can use this for initializing variables before the game starts playing. Players can not interact during this state
	'play' = During game playing. This is when variables will change to update positions, scores, velocities, etc. Player can interact during this state
	]]
	gameState = 'start'

end

-- Native Love2D function for detecting keyboard input
function love.keypressed(key)
	if(key == 'escape') then -- Quit the game by pressing the 'Escape' key rather than needing to hit the X button on the window
		love.event.quit()
	end

	-- Setting up our game state. If the game state is already on start, play the game. Otherwise, go back to start
	if(key == 'return' and gameState == 'start') then
		gameState = 'play'
	elseif (key == 'return') then
	-- During this start state we reset the player scores and positions for the ball and paddles
	-- We also give the ball a new random starting velocity
		gameState = 'start'

		paddleOnePosX = 10
		paddleOnePosY = 20
		paddleTwoPosX = VIRTUAL_WIDTH - 10 - paddleWidth
		paddleTwoPosY = VIRTUAL_HEIGHT - 20 - paddleHeight

		ballPosX = VIRTUAL_WIDTH / 2 - ballSize
		ballPosY = VIRTUAL_HEIGHT / 2 - ballSize

		ballDX = math.random(2) == 1 and 100 or -100
		ballDY = math.random(-50, 50)

		playerOneScore = 0
		playerTwoScore = 0
	end
end

function love.update(dt)
	-- We contained the input detection for moving paddles within this if statement so they can only move when the game is being played
	if(gameState == 'play') then
		-- Detecting if W or S is held down. If so, subtract or add the paddle speed value to move the paddle. This is multiplied by dt (deltatime) to keep speed consistent regardless of framerate
		-- We use math.max and math.min to confine the paddles to the screen height so they don't move out of the screen
		if(love.keyboard.isDown('w')) then
		paddleOnePosY = math.max(0, paddleOnePosY - paddleSpeed * dt)
		elseif(love.keyboard.isDown('s')) then
		paddleOnePosY = math.min(VIRTUAL_HEIGHT - paddleHeight, paddleOnePosY + paddleSpeed * dt)
		end
		-- Detecting if Up or Down is held down. If so, subtract or add the paddle speed value to move the paddle. This is multiplied by dt (deltatime) to keep speed consistent regardless of framerate
		-- We use math.max and math.min to confine the paddles to the screen height so they don't move out of the screen
		if(love.keyboard.isDown('up')) then
		paddleTwoPosY = math.max(0, paddleTwoPosY - paddleSpeed * dt)
		elseif(love.keyboard.isDown('down')) then
		paddleTwoPosY = math.min(VIRTUAL_HEIGHT - paddleHeight, paddleTwoPosY + paddleSpeed * dt)
		end

		-- Adding velocity values to ball position and multiplying by delta time so the ball can move
		ballPosX = ballPosX + ballDX * dt
		ballPosY = ballPosY + ballDY * dt
	end
end

-- Callback function used to draw on the screen every frame
function love.draw()
	push:start() -- Start rendering using push and virtual resolution

	-- Clearing the screen every frame so we can update what is on screen
	love.graphics.clear()

	-- Printing 'This is (gameState) Pong!' at the top of the screen to show the difference between game states
	-- We are referencing the virtual resolution for positioning rather than window resolution so that it can be rendered correctly
	if(gameState == 'start') then
		love.graphics.printf('This is Starting Pong!', smallFont, 0, 20, VIRTUAL_WIDTH, 'center')
	elseif(gameState == 'play') then
		love.graphics.printf('This is Playing Pong!', smallFont, 0, 20, VIRTUAL_WIDTH, 'center')
	end
	-- Displaying player scores on their respective sides of the screen
	love.graphics.print(tostring(playerOneScore), scoreFont, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
	love.graphics.print(tostring(playerTwoScore), scoreFont, VIRTUAL_WIDTH / 2 + 28, VIRTUAL_HEIGHT / 3)

	-- Displaying the FPS of the game in the top left corner of the screen. love.timer.getFPS() function returns the frames per second. We then convert to string for printing
	love.graphics.print(tostring(love.timer.getFPS()), smallFont, 2, 2)

	-- Creating the paddles and ball using their currently defined position and size variables
	love.graphics.rectangle('fill', paddleOnePosX, paddleOnePosY, paddleWidth, paddleHeight) -- Player One
	love.graphics.rectangle('fill', paddleTwoPosX, paddleTwoPosY, paddleWidth, paddleHeight) -- Player Two
	love.graphics.rectangle('fill', ballPosX, ballPosY, ballSize, ballSize) -- Ball

	push:finish() -- Stop rendering using push and virtual resolution
end