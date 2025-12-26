--[[

                                                                                                TODO:
    - vote revealer
    - calculate damage will taken from the bomb
    - clantag-semi
    - indicators (all rage and legit tabs, slow ind)
    - hitmarker
    - trashtalk
    - fake pitch
    - yaw exploit yaw: -3.40282335e+30f
    - fortnite damage
    - anti afk
    - e spam
    - anti teamkill kick
]]
-- @region_menu
local yaw_exploit_checkbox = gui.checkbox(gui.control_id('yaw_exploit'));
local yaw_exploit_row = gui.make_control('Yaw Exploit', yaw_exploit_checkbox);
local group = gui.ctx:find('lua>elements a');
group:add(yaw_exploit_row);
-- @endregion_menu

local function on_present_queue()
    if yaw_exploit_checkbox:get_value():get() then
        --print(gui.ctx:find('rage>anti-aim>angles>yaw>settings>amount'):get_value():get())
        current_value = (current_value == -3.40282335e+30) and 3.40282335e+30 or -3.40282335e+30
        gui.ctx:find('rage>anti-aim>angles>yaw>settings>amount'):get_value():set(current_value); -- player.m_pPawn->m_angEyeAngles.m_flYaw
    else
        gui.ctx:find('rage>anti-aim>angles>yaw>settings>amount'):get_value():set(0);
    end
end

events.present_queue:add(on_present_queue);