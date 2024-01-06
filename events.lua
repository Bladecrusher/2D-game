local love = require "love"

function checkGameover(playerX,playerY,deathspots, distanceThreshold)
    for _, deathspot in ipairs(deathspots) do
        local deathSpotX = deathspot.x
        local deathSpotY = deathspot.y
        
        local distance = math.sqrt((playerX - deathSpotX)^2 + (playerY - deathSpotY)^2)


        if distance <= distanceThreshold then
            return true
        end
    end
    return false
end
function checkWin(playerX,playerY,winspots, distanceThreshold)
    for _, winspot in ipairs(winspots) do
        local winSpotX = winspot.x
        local winSpotY = winspot.y

        local distance = math.sqrt((playerX - winSpotX)^2 + (playerY - winSpotY)^2)
        if distance <= distanceThreshold then
            return true
        end
    end
    return false
end


return {
    checkGameover = checkGameover,
    checkWin = checkWin,
}