local save = require("./modules/save")

local tabletop = {}
tabletop.__index = tabletop

local function slide_line(line)
    local result = {}
    for i = 1, #line do
        if line[i] ~= 0 then
            table.insert(result, line[i])
        end
    end
    local i = 1
    while i <= #result do
        if result[i + 1] and result[i] == result[i + 1] then
            result[i] = result[i] * 2
            table.remove(result, i + 1)
        end
        i = i + 1
    end
    while #result < 4 do
        table.insert(result, 0)
    end
    return result
end

local function center_string(str, width)
    local len = #str
    if len >= width then
        return string.sub(str, 1, width)
    end
    local padding_left = math.floor((width - len) / 2)
    local padding_right = width - len - padding_left
    return string.rep(" ", padding_left) .. str .. string.rep(" ", padding_right)
end

--+ CONSTRUCTOR +--
function tabletop:new(save)
    local instance = setmetatable({}, tabletop)

    instance.direction = ""
    if not save then
        instance:generate_random_tile()
        instance:generate_random_tile()
    end
    instance.table = save or {
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0}
    }
    instance.colors = {
        [0]    = "\27[48;2;205;193;180m", -- #CDC1B4
        [2]    = "\27[48;2;238;228;218m", -- #EEE4DA
        [4]    = "\27[48;2;237;224;200m", -- #EDE0C8
        [8]    = "\27[48;2;242;177;121m", -- #F2B179
        [16]   = "\27[48;2;245;149;99m",  -- #F59563
        [32]   = "\27[48;2;246;124;95m",  -- #F67C5F
        [64]   = "\27[48;2;246;94;59m",   -- #F65E3B
        [128]  = "\27[48;2;237;207;114m", -- #EDCF72
        [256]  = "\27[48;2;237;204;97m",  -- #EDCC61
        [512]  = "\27[48;2;237;200;80m",  -- #EDC850
        [1024] = "\27[48;2;237;197;63m",  -- #EDC53F
        [2048] = "\27[48;2;255;34;255m",  -- #EDC22E
        [4096] = "\27[48;2;255;34;255m",    -- #3C3A32
        [8192] = "\27[48;2;255;34;255m",    -- idem
    }

    return instance
end

--+ LOGIC +--
function tabletop:update()
    self:inputs()
    self:move()
end

function tabletop:inputs()
    if lui.keyboard.is_key_down("h") or lui.keyboard.is_key_down("a") then
        self.direction = "left"
    end
    if lui.keyboard.is_key_down("j") or lui.keyboard.is_key_down("s") then
        self.direction = "down"
    end
    if lui.keyboard.is_key_down("k") or lui.keyboard.is_key_down("w") then
        self.direction = "up"
    end
    if lui.keyboard.is_key_down("l") or lui.keyboard.is_key_down("d") then
        self.direction = "right"
    end
end

function tabletop:move()
    local old_table = {}
    for y = 1, 4 do
        old_table[y] = {}
        for x = 1, 4 do
            old_table[y][x] = self.table[y][x]
        end
    end

    if self.direction == "left" then
        for y = 1, 4 do
            self.table[y] = slide_line(self.table[y])
        end
    elseif self.direction == "right" then
        for y = 1, 4 do
            local reversed = {}
            for i = 4, 1, -1 do
                table.insert(reversed, self.table[y][i])
            end
            local result = slide_line(reversed)
            for i = 1, 4 do
                self.table[y][i] = result[5 - i]
            end
        end
    elseif self.direction == "up" then
        for x = 1, 4 do
            local col = {}
            for y = 1, 4 do table.insert(col, self.table[y][x]) end
            local result = slide_line(col)
            for y = 1, 4 do self.table[y][x] = result[y] end
        end
    elseif self.direction == "down" then
        for x = 1, 4 do
            local col = {}
            for y = 4, 1, -1 do table.insert(col, self.table[y][x]) end
            local result = slide_line(col)
            for y = 1, 4 do self.table[5 - y][x] = result[y] end
        end
    end

    for y = 1, 4 do
        for x = 1, 4 do
            if self.table[y][x] ~= old_table[y][x] then
                self:generate_random_tile()
                save.save(self.table)
                return true
            end
        end
    end
end

function tabletop:generate_random_tile()
    local empty_tiles = {}
    for y = 1, #self.table do
        for x = 1, #self.table[y] do
            if self.table[y][x] == 0 then
                table.insert(empty_tiles, {y = y, x = x})
            end
        end
    end

    if #empty_tiles > 0 then
        local tile = empty_tiles[math.random(1, #empty_tiles)]
        self.table[tile.y][tile.x] = 2
    end
end

function tabletop:reset()
    self.table = {
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0}
    }

    self:generate_random_tile()
    self:generate_random_tile()

    save.save(self.table)
end

--+ DRAW +--
function tabletop:draw()
    for y = 1, 4 do
        for x = 1, 4 do
            self:draw_cell(x, y)
        end
    end
end

function tabletop:draw_cell(x, y)
    local w, h = lui.graphics.get_dimensions()
    local display_value = tostring(self.table[y][x])
    if display_value == "0" then
        display_value = ""
    end
    display_value = center_string(display_value, 5)
    local display_color = self.colors[self.table[y][x]] or ""
    local cell =
"\27[48;2;255;127;127" .. "███████\n" .. 
"\27[38;2;127;127;127" .. "█" .. display_color .. "     \27[38;2;127;127;127█\n" ..
"\27[38;2;127;127;127" .. "█" .. display_color .. "\27[38;2;0;0;0m" .. display_value .. "\27[38;2;127;127;127█\n" ..
"\27[38;2;127;127;127" .. "█" .. display_color .. "     \27[38;2;127;127;127█\n" ..
"\27[38;2;127;127;127" .. "███████\27[0m"
    lui.graphics.draw(cell, x * 6 + w / 2 - 20, y * 4 + h / 2 - 2 * 7)

    lui.graphics.draw("h/j/k/l: Move", 1, h - 2)
    lui.colors.set(34, 255, 34, "background")
    lui.graphics.draw("n: New Game", 1, h - 1)
    lui.colors.set(255, 34, 34, "background")
    lui.graphics.draw("q: Quit", 1, h)
    lui.colors.reset()
end

return tabletop