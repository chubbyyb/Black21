local tick = require 'tick'

values = {2,3,4,5,6,7,8,9,10,11,12,13,14} -- 11 = Jack, 12 = Queen, 13 = King, 14 = Ace
suits = {'S', 'D', 'C', 'H'}

test = nil
hitGUIx = 700
hitGUIy = 70
standGUIx = 700
standGUIy = 110
cardImages = {}


function hit()
    table.insert(playersHand, table.remove(deck, love.math.random(#deck)))
    playerHandGUI = ('Players Hand: ' .. table.concat(playersHand, ', ') ..' = ' .. calculateScore(playersHand))
    if(calculateScore(playersHand) > 21) then
        dealerHandGUI = ('Dealers Hand: ' .. table.concat(dealersHand, ', ') ..' = ' .. calculateScore(dealersHand))
        bustText = 'Player Busts!'
        gameOver = true
    end
end

function stand()
    dealerHandGUI = ('Dealers Hand: ' .. table.concat(dealersHand, ', ') ..' = ' .. calculateScore(dealersHand))
    if(calculateScore(dealersHand) < 17) then
        table.insert(dealersHand, table.remove(deck, love.math.random(#deck)))
        dealerHandGUI = ('Dealers Hand: ' .. table.concat(dealersHand, ', ') ..' = ' .. calculateScore(dealersHand))
    end

    if(calculateScore(dealersHand) > 21) then
        bustText = 'Dealer Busts!'
        gameOver = true
    elseif(calculateScore(dealersHand) > calculateScore(playersHand)) then
        bustText = 'Dealer Wins!'
        gameOver = true
    elseif(calculateScore(dealersHand) < calculateScore(playersHand)) then
        bustText = 'Player Wins!'
        gameOver = true
    else
        bustText = 'Draw!'
        gameOver = true
    end
end

function getImageScaleForNewDimensions( image, newWidth, newHeight )
    local currentWidth, currentHeight = image:getDimensions()
    return ( newWidth / currentWidth ), ( newHeight / currentHeight )
end

function love.mousepressed(x, y, button, istouch)
    -- HIT
    if button == 1 then	--checks which button was pressed, refer to [url=https://love2d.org/wiki/love.mousepressed]wiki[/url]
        if(gameOver) then
            return
        end
        if x >= hitGUIx and x <= hitGUIx+70 and y >= hitGUIy and y <= hitGUIy+30 then
            hit()
        end

    -- STAND
        if x >= standGUIx and x <= standGUIx+70 and y >= standGUIy and y <= standGUIy+30 then
            stand()
        end
    end
end

function loadCardImage(cardName)
    if not cardImages[cardName] then
        cardImages[cardName] = love.graphics.newImage('cards/' .. cardName .. '.png')
    end
    return cardImages[cardName]
end

function love.load()
    tick.framerate = 10
    tick.rate = .005
    deck = {}

    dealersHand = {}
    dealerScore = 0
    playersHand = {}
    playerScore = 0
    playerHandGUI = ''
    bustText = ''
    gameOver = false

    love.window.setTitle( 'Black21' )
    math.randomseed(os.time())

    for i = 0, 52 do
        local value = values[i % 13 + 1]
        local suit = suits[math.floor(i / 13) + 1]
        --if value == 11 then
        --    value = 'Jack'
        --elseif value == 12 then
        --    value = 'Queen'
        --elseif value == 13 thenrrr
        --    value = 'King'
        --elseif value == 14 then
        --    value = 'Ace'
        --end
        deck[i] = tostring(value) .. tostring(suit)
    end

    test = love.graphics.newImage('cards/2C.png')
    scaleX, scaleY = getImageScaleForNewDimensions( test, 111, 161)
    
    -- Dealers handed two cards
    table.insert(dealersHand, table.remove(deck, love.math.random(#deck)))
    table.insert(dealersHand, table.remove(deck, love.math.random(#deck)))
    
    
    -- Players handed two cards
    table.insert(playersHand, table.remove(deck, love.math.random(#deck)))
    table.insert(playersHand, table.remove(deck, love.math.random(#deck)))

    playerHandGUI = ('Players Hand: ' .. playersHand[1] .. ' and ' .. playersHand[2] .. ' = ' .. calculateScore(playersHand))
    dealerHandGUI = ('Dealers Hand: ' .. dealersHand[1] .. ' and Hidden')
    
end

function love.update(dt)

end

function love.keyreleased(key)
    if key == "q" then

       love.load()
    end

    if(key == 'r') then
        love.event.quit('restart')
    end
 end

function love.draw()
    local x = 100
    local xd = 100
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", hitGUIx,hitGUIy, 70,30) -- HIT
    love.graphics.rectangle("fill", standGUIx,standGUIy, 70,30) -- STAND
    love.graphics.setColor(255,255,255)
    love.graphics.print('Hit', 725, 75)
    love.graphics.print('Stand', 715, 115)
    love.graphics.print('Black21', 10, 10)
    love.graphics.print(dealerHandGUI, 10, 30)
    love.graphics.print(playerHandGUI, 10, 50)
    love.graphics.print(bustText, 10, 70)
    love.graphics.setBackgroundColor(1/255, 50/255, 32/255, 1)

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", 100,100, 500,365)



    love.graphics.setColor(1,1,1)

    -- Display dealersHand
    for i=1, #dealersHand do
        if(gameOver == false and i==2) then
            love.graphics.draw(loadCardImage('back'), xd, 100,0,scaleX,scaleY)
            xd = xd + 100 + 10
            break
        end
        love.graphics.draw(loadCardImage(dealersHand[i]), xd, 100,0,scaleX,scaleY)
        xd = xd + 100 + 10
    end


    -- Display playersHand
    for i=1, #playersHand do
        love.graphics.draw(loadCardImage(playersHand[i]), x, 300,0,scaleX,scaleY)
        x = x + 100 + 10
    end
    
end


function calculateScore(hand)
    local score = 0
    for i = 1, #hand do
        local card = hand[i]
        local value = tonumber(string.match(card, "%d+"))
        if value == 14 then -- check if ace
            if(score+11 > 21) then
                value = 1
            else
                value = 11
            end
        end

        if(value > 10) then
            value = 10
        end

        score = score + value
    end
    return score
end
