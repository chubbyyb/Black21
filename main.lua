values = {2,3,4,5,6,7,8,9,10,11,12,13,14} -- 11 = Jack, 12 = Queen, 13 = King, 14 = Ace
suits = {'S', 'D', 'C', 'H'}
deck = {}

dealersHand = {}
dealerScore = 0
playersHand = {}
playerScore = 0
playerHandGUI = ''
bustText = ''
gameOver = false


function hit()
    table.insert(playersHand, deck[math.random(1, 52)])
    playerHandGUI = ('Players Hand: ' .. table.concat(playersHand, ', ') ..' = ' .. calculateScore(playersHand))
    if(calculateScore(playersHand) > 21) then
        dealerHandGUI = ('Dealers Hand: ' .. table.concat(dealersHand, ', ') ..' = ' .. calculateScore(dealersHand))
        bustText = 'Player Busts!'
        gameOver = true
    end
end

function stand()
    dealerHandGUI = ('Dealers Hand: ' .. table.concat(dealersHand, ', ') ..' = ' .. calculateScore(dealersHand))
    while(calculateScore(dealersHand) < 17) do
        table.insert(dealersHand, deck[math.random(1, 52)])
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

function love.mousepressed(x, y, button, istouch)
    -- HIT
    if button == 1 then	--checks which button was pressed, refer to [url=https://love2d.org/wiki/love.mousepressed]wiki[/url]
        if(gameOver) then
            return
        end
        if x >= 300 and x <= 300+70 and y >= 70 and y <= 70+30 then
            hit()
        end

    -- STAND
        if x >= 300 and x <= 300+70 and y >= 110 and y <= 110+30 then
            stand()
        end
    end
end


function love.load()
    math.randomseed(os.time())

    for i = 1, 52 do
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
    
    
    -- Dealers handed two cards
    table.insert(dealersHand, deck[math.random(1, 52)])
    table.insert(dealersHand, deck[math.random(1, 52)])
    
    
    -- Players handed two cards
    table.insert(playersHand, deck[math.random(1, 52)])
    table.insert(playersHand, deck[math.random(1, 52)])

    playerHandGUI = ('Players Hand: ' .. playersHand[1] .. ' and ' .. playersHand[2] .. ' = ' .. calculateScore(playersHand))
    dealerHandGUI = ('Dealers Hand: ' .. dealersHand[1] .. ' and Hidden')
    
end

function love.update(dt)
    if(love.keyboard.isDown('r')) then
        love.event.quit('restart')
    end
end

function love.draw()
    love.graphics.setColor(255,0,0)
    love.graphics.rectangle("fill", 300,70, 70,30)
    love.graphics.rectangle("fill", 300,110, 70,30)
    love.graphics.setColor(255,255,255)
    love.graphics.print('Hit', 325, 75)
    love.graphics.print('Stand', 310, 115)
    love.graphics.print('Black21', 10, 10)
    love.graphics.print(dealerHandGUI, 10, 30)
    love.graphics.print(playerHandGUI, 10, 50)
    love.graphics.print(bustText, 10, 70)
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
