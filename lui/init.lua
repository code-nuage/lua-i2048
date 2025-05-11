local base = (...):gsub("init", "")

_G.lui = {}

lui.running = true

lui.run = require(base .. "run")
lui.graphics = require(base .. "graphics")
lui.colors = require(base .. "colors")
lui.keyboard = require(base .. "keyboard")

return lui