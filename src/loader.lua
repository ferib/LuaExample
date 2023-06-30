local nn = ...
local Draw = Utils.Draw:New()

local foo = require("foo.lua");
print("Magic nuber: ", foo)

Draw:Sync(function(draw)
    local px, py, pz = ObjectPosition("player")
    local tx, ty, tz = ObjectPosition("target")

    if IsShiftKeyDown() then
        -- TODO
    end

    -- store for later
    local oldf = nn.GetFocus()

    local os = nn.ObjectManager(6)
    for i=1, #os  do
        local o = os[i]
        local name = ObjectName(o)
        local x, y, z = ObjectPosition(o)
        if x == nil then
            print(o)
        end

        -- distance filter to avoid FPS drop
        local dist = ((px-x)*(px-x))+((py-y)*(py-y))+((pz-z)*(pz-z))
        -- TODO: this distance is wrong?
        if (#os > 30 and dist < 1200) 
        or dist < 4000
        then
            nn.SetFocus(o);
            if UnitIsEnemy("player", "focus") then
                draw:SetColor(draw.colors.red)
            else
                draw:SetColor(draw.colors.green)
            end
            draw:Line(px, py, pz, x, y, z)
            draw:Text("[" .. floor(dist) .. "] - " .. name, "GameTooltipTextSmall", x, y, z+4);
            draw:Circle(x, y, z, 1.5)
        end
    end
    nn.SetFocus(oldf)
end)

Draw:Enable()
print("OK")
