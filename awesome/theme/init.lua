local gtable = require('gears.table')
local default_theme = require('theme.default-theme')
-- PICK THEME HERE
local theme = require('theme.space')

local final_theme = gtable.crush(default_theme, theme.theme)
default_theme.awesome_overrides(final_theme)
theme.awesome_overrides(final_theme)

return final_theme
