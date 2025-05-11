require("./lui/init")

local tabletop = require("./modules/tabletop")
local save = require("./modules/save")
local game

local saved_game = save.load()
game = tabletop:new(saved_game)

function lui.load()

end

function lui.update()
    game:update()

    if lui.keyboard.is_key_down("q") then
        lui.running = false
    end
    if lui.keyboard.is_key_down("n") then
        game:reset()
    end
end

function lui.draw()
    game:draw()
    lui.colors.reset()
end

lui.run()