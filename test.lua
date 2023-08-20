values = {2,3,4,5,6,7,8,9,10,11,12,13,14} -- 11 = Jack, 12 = Queen, 13 = King, 14 = Ace
suits = {'S', 'D', 'C', 'H'}
deck = {}

dealersHand = {}
dealerScore = 0
playersHand = {}
playerScore = 0

for i = 0, 51 do
    local value = values[i % 13 + 1]
    local suit = suits[math.floor(i / 13) + 1]
    --if value == 11 then
    --    value = 'Jack'
    --elseif value == 12 then
    --    value = 'Queen'
    --elseif value == 13 then
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

dealerScore = calculateScore(dealersHand)
playerScore = calculateScore(playersHand)

-- Print the hands
print("Dealers hand: " .. dealersHand[1] .. ' and Hidden')
print("Players hand: " .. playersHand[1] .. ' and ' .. playersHand[2])


hitOrStand = io.read()

if(hitOrStand == 'hit') then
    table.insert(playersHand, deck[math.random(1, 52)])
    playerScore = calculateScore(playersHand)
    print("Players hand: " .. playersHand[1] .. ' and ' .. playersHand[2] .. ' and ' .. playersHand[3])
    print("Player score: " .. playerScore)
end
