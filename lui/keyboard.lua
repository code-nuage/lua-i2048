local keyboard = {}

function keyboard.is_key_down(key)
    if lui.input == key then
        return true
    end
end

return keyboard