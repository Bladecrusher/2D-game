local love = require "love"

local coordinates = {}

local spawnpoint = {
    {x = 100 , y = 150},
    {x = 2012.00, y = 1150.00}
}
local levelData = {
    {
        deathSpots = {
            { x = 103.33, y = 854.67},
            { x = 903.50, y = 115.0},
            { x = 1872.00, y = 105.50},
            { x = 738.00, y = 1056,67},
            { x = 1956.67, y = 1875.33},
            { x = 167.00, y = 1888.33},
            { x = 1133.33, y = 1500.00},
            { x = 566.00, y = 1324.00},
            { x = 1703.33, y = 1485.33},
            { x = 66.00, y = 1222.00}
        },
        winSpots = {
            { x = 66.00, y = 1222.00}
        }
    },
    {
    deathSpots = {
        { x = 162.67, y = 152.67},
        { x = 183.33, y = 722.0},
        { x = 130.00, y = 1177.50},
        { x = 672.00, y = 1620.00},
        { x = 570 , y = 1945.33 },
        { x = 1244.75, y = 1942.75},
        { x = 1904, y = 1943.00},
        { x = 1561.50, y = 1363.50 },
        { x = 1502.25, y = 1174.25},
        { x = 1852.50, y = 720.75},
        { x = 1854.50, y = 83.25},
        { x = 1594.50, y = 144.00},
        { x = 1363, y = 601},
    },
    winSpots = {
        { x = 130.00, y = 1177.50}
    }
    }
}
coordinates.spawnpoint = spawnpoint
coordinates.levelData = levelData
return coordinates