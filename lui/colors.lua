local colors = {}

function colors.set(r, g, b, mode)
    if not mode or mode == "foreground" then
        io.write(string.format("\27[38;2;%d;%d;%dm", r, g, b))
    elseif mode == "background" then
        io.write(string.format("\27[48;2;%d;%d;%dm", r, g, b))
    end
end

function colors.reset()
    io.write("\27[0m")
end

return colors