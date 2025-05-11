return function()
    local function restore()
        lui.graphics.clear()
        os.execute("stty sane")                                                -- Restore non-blocking
        io.write("\27[0m")                                                     -- Reset colors
        io.write("\27[?25h")                                                   -- Restore separation line
    end

    local function handler(err)
        restore()
        return debug.traceback(err)
    end

    local function run()
        if type(lui.load) == "function" then
            lui.load()
        end
        while lui.running do
            if type(lui.draw) == "function" then
                lui.graphics.clear()
                lui.draw()
            end
            if type(lui.update) == "function" then
                lui.input = io.read(1)
                lui.update()
            end
        end
    end

    xpcall(function()
        os.execute("stty raw -echo")                                           -- Non-blocking inputs
        io.write("\27[?25l")                                                   -- Hide separation line
        run()
    end, handler)

    restore()
end
