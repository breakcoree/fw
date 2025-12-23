--[[

                                                                                                TODO:
    - vote revealer
    - calculate damage will taken from the bomb
    - clantag-semi-✅
    - indicators (all rage and legit tabs, slow ind)
    - hitmarker
    - trashtalk-✅
    - fake pitch-✅
    - yaw exploit yaw: -3.40282335e+30f-✅
    - fortnite damage
    - anti afk-✅
    - e spam-✅
    - anti teamkill kick-✅
]]

-- @region_nosub
-- @yaw_exploit
local yaw_exploit = ui.new_checkbox("LUA", "B", "Yaw exploit");
ui.set_callback(yaw_exploit, function(self);
    if ui.get(self) then;
        ui.set(ui.reference("RAGE", "Aimbot", "Yaw"), -3.40282335e+30 or 3.40282335e+30); -- player.m_pPawn->m_angEyeAngles.m_flYaw
    else;
        ui.set(ui.reference("RAGE", "Aimbot", "Yaw"), 0);
    end;
end);

-- @e_spam;
local e_spam = ui.new_checkbox("LUA", "B", "E spam");
ui.set_callback(e_spam, function(self);
    if ui.get(self) then;
        client.set_event_callback("paint", function();
            client.exec("+use");
        end);
    else;
        client.unset_event_callback("paint");
    end;
end);

-- @clantag;
local clantag = ui.new_checkbox("LUA", "B", "Clantag");
local clantag_text = ui.new_textbox("LUA", "B", "Clantag text", "my_clantag");
local clantag_index = 0;
--[[pseudo
class CEngineClient
    {
        public:
        void ServerCmdKeyValues(KeyValues *key_values)
        {
            CallVfunc<void (*)(void*, KeyValues*)>(117)(this, key_values);
        }
    };
     
    void SendClanTag( const char *tag, const char *name )
    {
    	KeyValues *kv = new KeyValues( "ClanTagChanged" );
    	kv->SetString( "tag", tag );
    	kv->SetString( "name", name );
    	g_engineClient->ServerCmdKeyValues( kv );
    }
     
    // Example callback
    void Misc::OnNetworkUpdate()
    {
        // note: inf: how to make it update in tab lies on the reader
        SendClanTag("UnKnoWnCheaTs", "unknowncheats.me");
    }]]
--[[may not work cuz SendClanTag function is patched in some updates, but worth a try. Namechanger method still works tho]]
local ServerCmdKeyValues(key_values) = client.get_interface("engine.dll", "VEngineClient014"):get_virtual_function(117);
local function SendClanTag(tag, name)
    local key_values = client.create_key_values("ClanTagChanged");
    key_values.set_string("tag", tag);
    key_values.set_string("name", name);
    ServerCmdKeyValues(key_values);
end
ui.set_callback(clantag, function(self);
    if ui.get(self) then;
        client.set_event_callback("paint", function();
            local tag = ui.get(clantag_text);
            local len = string.len(tag);
            local display_tag = "ed0higerg0iger9irgei9jsfgjiosfiogj"; -- rand str
            for i = 0, len do;
                clantag_index = (clantag_index % (len + 1)) + 1;
                display_tag = string.sub(tag, clantag_index, len) .. string.sub(tag, 0, clantag_index - 1);
                SendClanTag(display_tag, "unknowncheats.me");
                break;
            end;
        end);
    else;
        client.unset_event_callback("paint");
        SendClanTag("", "");
    end;
end);

-- anti_team_kill_kick
local anti_team_kill_kick = ui.new_checkbox("LUA", "B", "Anti teamkill kick");
-- [[TODO: Clear on new match start]]
local kill_counter = 0;
ui.set_callback(anti_team_kill_kick, function(self)
    if ui.get(self) then
        client.set_event_callback("player_killed", function(event)
            local local_player_index = client.userid_to_entindex(client.get_local_player());
            local victim_index = client.userid_to_entindex(event.userid);
            local attacker_index = client.userid_to_entindex(event.attacker);
            if victim_index == local_player_index and attacker_index ~= local_player_index then;
                kill_counter = kill_counter + 1;
                if kill_counter >= 3 then;
                    client.exec("disconnect");
                end;
            end
        end
    end)
end)
-- anti_afk
local anti_afk = ui.new_checkbox("LUA", "B", "Anti afk");
ui.set_callback(anti_afk, function(self)
    if ui.get(self) then
        client.set_event_callback("paint", function()
            client.exec("+forward");
            client.exec("-forward");
        end)
    else
        client.unset_event_callback("paint");
    end
end)
-- fake_pitch
local fake_pitch = ui.new_checkbox("LUA", "B", "Fake pitch");
ui.set_callback(fake_pitch, function(self)
    if ui.get(self) then
        ui.set(ui.reference("RAGE", "Aimbot", "Pitch"), -2182423346297399750336966557899);
    else
        ui.set(ui.reference("RAGE", "Aimbot", "Pitch"), 0);
    end
end)

-- trashtalk
local trashtalk = ui.new_checkbox("LUA", "B", "Trashtalk");
local trashtalk_messages = {"asd", "ergerg", "wr9guherfguhsdf", "rg90eyrg9usd", "wer8gyuwe9urhnweifjnhioj"}
ui.set_callback(trashtalk, function(self)
    if ui.get(self) then
        client.set_event_callback("player_killed", function(event)
            local local_player_index = client.userid_to_entindex(client.get_local_player());
            local victim_index = client.userid_to_entindex(event.userid);
            local attacker_index = client.userid_to_entindex(event.attacker);
            if attacker_index == local_player_index then;
                local message = trashtalk_messages[math.random(#trashtalk_messages)];
                client.exec("say " .. message);
            end
        end)
    end
end)

-- @endregion_nosub