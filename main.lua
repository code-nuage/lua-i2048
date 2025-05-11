require("./lui/init")

local tabletop = require("./tabletop")

local game = tabletop:new()

function lui.load()
    game:generate_random_tile()
    game:generate_random_tile()
end

function lui.update()
    game:update()

    if lui.keyboard.is_key_down("q") then
        lui.running = false
    end
end

function lui.draw()
    game:draw()
    lui.colors.reset()
end

lui.run()