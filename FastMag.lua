--[[
    Copyright (c) 2015 - Mykezero

    FastMag is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Ashita is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with FastMag.  If not, see <http://www.gnu.org/licenses/>.
]]--

_addon.author   = 'Mykezero'
_addon.name     = 'FastMag'
_addon.version  = '0.1'

require 'common'

---------------------------------------------------------------------------------------------------
-- desc: Main FastMag table.
---------------------------------------------------------------------------------------------------
local FastMag =
{
    -- addon enabled
    enabled = false,
    -- debug mode
    debug_mode = false,
    -- equip on load
    auto_start = false,
    -- ammo name
    ammo = nil,
    -- pouch name
    pouch = nil
}

---------------------------------------------------------------------------------------------------
-- func: load
-- desc: First called when our addon is loaded.
---------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- timestamp_config = settings:load(_addon.path .. 'settings/timestamp.json') or default_config;
    -- timestamp_config = table.merge(default_config, timestamp_config);
end)

ashita.register_event('command', function(cmd, nType)
    local args = cmd:GetArgs()
    local arg_info = PowerArgs(args)

    -- We've recieved a command!
    if(arg_info.has_command) then

      -- Command is not ours to handle.
      if(arg_info.command ~= "/fastmag") then return false end

      -- Display usage info on command with no parameters
      if(not arg_info.has_parameters) then
        print "[FastMag] Available Options"
        print "[FastMag] Start : Begin autoloading ammo. "
        print "[FastMag] Stop : End auto-loading ammo. "
        print "[FastMag] Auto : Toggle autoloading on load. "
        print "[FastMag] Ammo \"Ammo Name\" : Sets ammo type by name for use on ammo empty. "
        print "[FastMag] Pouch \"Pouch Name\" : Sets pouch or quiver for use on ammo empty. "
        return true
      end

      -- Get the first option: start, stop, auto, ammo or pouch.
      local option = string.lower(arg_info.parameters[1]);

      -- Handle all 1 argument commands.
      if (arg_info.parameter_count == 1) then
        if (option == "start") then
          print "start"
        elseif (option == "stop") then
          print "stop"
        elseif (option == "auto") then
          print "auto"
        else
          print "N/A"
        end
        return true;
      end

      if(arg_info.parameter_count == 2) then
        -- Read in the user's ammo or pouch type.
        local value = arg_info.parameters[2]
        -- set pouch to the user's pouch or quiver type.
        local pouch = (option == "pouch") and value or "nil"
        -- Set ammo to the user's ammo type
        local ammo = (option == "ammo") and value or "nil"

        -- Process pouches and quivers.
        if(pouch == value) then
          print(string.format("[FastMag] Now using %ss on reload. ", value))
        -- Process ammo
        elseif(ammo == value) then
          print(string.format("[FastMag] Now using %ss on reload. ", value))
        -- Quiver, Pouch or Ammo type not found.
        else
          print ("[FastMag] " .. value .. " not found.")
        end
      end
    end
    -- Default: let other addons handle the command.
    return false
end)

---------------------------------------------------------------------------------------------------
-- func: PowerArgs
-- desc: Provides relevant information about command arguements
---------------------------------------------------------------------------------------------------
function PowerArgs(eargs)

    -- store parameters
    params = { }
    for index = 2, #eargs do table.insert(params, eargs[index]) end

    -- contains argument info
    local arg_info =
    {
        parameters = params,
        -- arg  count
        count = #eargs,
        -- the command or nil
        command = (#eargs < 1) and "nil" or eargs[1],
        -- args contains a command
        has_command = #eargs >= 1,
        -- commands has paramter(s)
        has_parameters = #eargs >= 2,
        -- number of parameters
        parameter_count = #eargs - 1
    }

    return arg_info
end
