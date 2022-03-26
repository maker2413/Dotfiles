local filesystem = require('gears.filesystem')

local theme = {}

theme.font = 'Inter Regular 10'
theme.font_bold = 'Inter Bold 10'

local awesome_overrides = function(theme) end

return {
	theme = theme,
 	awesome_overrides = awesome_overrides
}
