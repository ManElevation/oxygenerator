-- oxygenerator: block that gives breath at times while in radius, mod for minetest
-- minetest 0.4.17.1
-- (c) 2018 ManElevation

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.


oxygenerator = {}
oxygenerator.radius = tonumber(minetest.settings:get("oxygenerator_radius")) or 5    
oxygenerator.node = "oxygenerator:oxygenerator_small"

    minetest.register_node(oxygenerator.node, {
    description = "Oxygenerator",
   drawtype = "nodebox",
    tiles = {"oxygenerator.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    walkable = true,
    groups = {snappy=2,cracky=3},
    legacy_wallmounted = true,
    is_watercraft = true,
on_punch = function(pos, node, puncher)
minetest.add_entity(pos, "oxygenerator:display") end,
    on_construct=function(pos)
        minetest.get_node_timer(pos):start(1)
    end,
    on_timer = function (pos, elapsed)
        for _, ob in ipairs(minetest.get_objects_inside_radius(pos, 6)) do
            if ob:is_player() then
                ob:set_breath(10)
            end
        end
    minetest.get_node_timer(pos):set(0.1, 0)
    end
})

minetest.register_entity("oxygenerator:display", {
	physical = false,
	collisionbox = {0, 0, 0, 0, 0, 0},
	visual = "wielditem",
	-- wielditem seems to be scaled to 1.5 times original node size
	visual_size = {x = 1.0 / 1.5, y = 1.0 / 1.5},
	textures = {"oxygenerator:display_node"},
	timer = 0,

	on_step = function(self, dtime)

		self.timer = self.timer + dtime

		-- remove after 5 seconds
		if self.timer > 5 then
			self.object:remove()
		end
	end,
})

local x = oxygenerator.radius
minetest.register_node("oxygenerator:display_node", {
	tiles = {"oxygenerator_display.png"},
	use_texture_alpha = true,
	walkable = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- sides
			{-(x+.55), -(x+.55), -(x+.55), -(x+.45), (x+.55), (x+.55)},
			{-(x+.55), -(x+.55), (x+.45), (x+.55), (x+.55), (x+.55)},
			{(x+.45), -(x+.55), -(x+.55), (x+.55), (x+.55), (x+.55)},
			{-(x+.55), -(x+.55), -(x+.55), (x+.55), (x+.55), -(x+.45)},
			-- top
			{-(x+.55), (x+.45), -(x+.55), (x+.55), (x+.55), (x+.55)},
			-- bottom
			{-(x+.55), -(x+.55), -(x+.55), (x+.55), -(x+.45), (x+.55)},
			-- middle (surround oxygenerator)
			{-.55,-.55,-.55, .55,.55,.55},
		},
	},
	selection_box = {
		type = "regular",
	},
	paramtype = "light",
	groups = {dig_immediate = 3, not_in_creative_inventory = 1},
	drop = "",
})

minetest.register_craft({
	output = "oxygenerator:oxygenerator_small",
	recipe = {
                {"default:steel_ingot", "default:copper_ingot", "default:steel_ingot", },
                {"default:steel_ingot", "default:coalblock",        "default:steel_ingot", },
                {"default:steel_ingot", "default:copper_ingot", "default:steel_ingot", }
	}
})
