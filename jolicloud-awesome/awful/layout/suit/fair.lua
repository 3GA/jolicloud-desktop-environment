---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2008 Julien Danjou
-- @release v3.4-799-g4711354
---------------------------------------------------------------------------

-- Grab environment we need
local ipairs = ipairs
local math = math

--- Fair layouts module for awful
-- awful.layout.suit.fair
local fair = {}

local function do_fair(p, orientation)
    local wa = p.workarea
    local cls = p.clients

    if #cls > 0 then
        local cells = math.ceil(math.sqrt(#cls))
        local strips = math.ceil(#cls / cells)

        local cell = 0
        local strip = 0
        for k, c in ipairs(cls) do
            local g = {}
            if ( orientation == "east" and #cls > 2 )
            or ( orientation == "south" and #cls <= 2 ) then
                if #cls < (strips * cells) and strip == strips - 1 then
                    g.width = wa.width / (cells - ((strips * cells) - #cls))
                else
                    g.width = wa.width / cells
                end
                g.height = wa.height / strips

                g.x = wa.x + cell * g.width
                g.y = wa.y + strip * g.height
            else
                if #cls < (strips * cells) and strip == strips - 1 then
                    g.height = wa.height / (cells - ((strips * cells) - #cls))
                else
                    g.height = wa.height / cells
                end
                g.width = wa.width / strips

                g.x = wa.x + strip * g.width
                g.y = wa.y + cell * g.height
            end

            g.width = g.width - c.border_width * 2
            g.height = g.height - c.border_width * 2
            c:geometry(g)

            cell = cell + 1
            if cell == cells then
                cell = 0
                strip = strip + 1
            end
        end
    end
end

--- Horizontal fair layout.
-- @param screen The screen to arrange.
fair.horizontal = {}
fair.horizontal.name = "fairh"
function fair.horizontal.arrange(p)
    return do_fair(p, "east")
end

-- Vertical fair layout.
-- @param screen The screen to arrange.
fair.name = "fairv"
function fair.arrange(p)
    return do_fair(p, "south")
end

return fair
