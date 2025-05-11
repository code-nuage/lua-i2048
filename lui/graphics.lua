local graphics = {}

function graphics.clear()
    os.execute("clear")
end

function graphics.draw(text, x, y)
    local lines = {}
    for line in text:gmatch("([^\n]*)\n?") do
        table.insert(lines, line)
    end

    for i, line in ipairs(lines) do
        io.write(string.format("\27[%d;%dH", math.floor(y + i - 1), math.floor(x)))
        io.write(line)
    end
end

function graphics.get_dimensions()
    local w, h = tonumber(io.popen("tput cols"):read("*a")), tonumber(io.popen("tput lines"):read("*a"))
    return w, h
end

function graphics.get_width()
    local w, _ = graphics.get_dimensions()
    return w
end

function graphics.get_height()
    local _, h = graphics.get_dimensions()
    return h
end

return graphics