local json = require("./libs/json")

local save = {}

save.name = "save"

function save.load()
    local file = io.open("./" .. save.name .. ".json", "r")
    if file then
        local json_data = file:read("*a")
        if json_data then
            local data = json.decode(json_data)
            if data then
                file:close()
                return data
            end
        end
        file:close()
    end
end

function save.save(data)
    local file = io.open("./" .. save.name .. ".json", "w+")
    if file then
        local json_data = json.encode(data)
        if json_data then
            file:write(tostring(json_data))
            file:close()
            return true
        end
        file:close()
    end
end

return save