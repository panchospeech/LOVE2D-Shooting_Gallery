function love.load()
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    score = 0
    timer = 0
    gameState = 1 -- variable that keep track if the game is running 1 is menu, 2 is playing

    gameFont = love.graphics.newFont(25)
    titleFont = love.graphics.newFont(60)

    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    love.mouse.setVisible(false) -- this hides the mouse pointer (to be replaced as crosshairs)

end

function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end
    
    if timer < 0 then
        timer = 0
        gameState = 1
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0) -- background
    --[[
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", target.x, target.y, target.radius)
    ]]
    if gameState == 1 then
        love.graphics.setFont(titleFont)
        love.graphics.printf("Shooting Gallery", 0, 150, love.graphics.getWidth(), "center")     -- print f is for text
        love.graphics.setFont(gameFont)
        love.graphics.printf("Click anywhere to begin!", 0, 300, love.graphics.getWidth(), "center")
    end
    
    if gameState == 2 then -- we only want to show the target everything if the game is running (== 2)
        -- this replaces the target circle commented before
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(gameFont)
        love.graphics.print("Score: " .. score, 10, 5)
        love.graphics.print("Time: " .. math.ceil(timer), 10, 45)
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end

    -- draw the crosshair as the mouse (-20 is the offset to coordinate the center of the image
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
    
end

function love.mousepressed(x, y, button, istouch, presses)
    -- run this function only when the game is running (gameState == 2)
    if gameState == 2 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            if button == 1 then
                score = score + 1
            elseif button == 2 then -- if you click the right button you win double score, but loose 1 sec of time
                score = score + 2
                timer = timer - 1
            end
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)   
        elseif score > 0 then
            score = score - 1 
        end
    -- else if the game is in the main menu, if you click anywhere, the game starts
    elseif button == 1 and gameState == 1 then 
        gameState = 2
        score = 0
        timer = 10
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end