Commands = {}

Commands["pcallsign"] = {
    ["function"] = function(source, args)
        if not args[1] then TriggerClientEvent('DoLongHudText', source, 'Enter a CallSign') return end
        TriggerClientEvent('ev-dispatch:AddinSignin', source, args[1], "car")
    end,
    ["suggestion"] = {
        ["help"] = "/callsign [callsign] [type] (type car-heli-motor-bicycle )",
    },
    ["condition"] = {
        ["type"] = "JOB",
        ["params"] = "police",
    },
}

Commands["ecallsign"] = {
    ["function"] = function(source, args)
        if not args[1] then TriggerClientEvent('DoLongHudText', source, 'Enter a CallSign') return end
        TriggerClientEvent('ev-dispatch:AddinSignin', source, args[1], "car")
    end,
    ["suggestion"] = {
        ["help"] = "/callsign [callsign] [type] (type car-heli-motor-bicycle )",
    },
    ["condition"] = {
        ["type"] = "JOB",
        ["params"] = "ems",
    },
}

Commands["dcallsign"] = {
    ["function"] = function(source, args)
        if not args[1] then TriggerClientEvent('DoLongHudText', source, 'Enter a CallSign') return end
        TriggerClientEvent('ev-dispatch:AddinSignin', source, args[1], "car")
    end,
    ["suggestion"] = {
        ["help"] = "/callsign [callsign] [type] (type car-heli-motor-bicycle )",
    },
    ["condition"] = {
        ["type"] = "JOB",
        ["params"] = "doctor",
    },
}

Commands["jail"] = {
    ["function"] = function(source, args)
        TriggerClientEvent('police:jailing', source, args[1], args[2])
    end,
    ["suggestion"] = {
        ["help"] = "jail [player id] [length]",
    },
    ["condition"] = {
        ["type"] = "JOB",
        ["params"] = "police",
    },
}

Commands["bill"] = {
    ["function"] = function(source, args)
        TriggerClientEvent('police:billing', source, args[1], args[2])
    end,
    ["suggestion"] = {
        ["help"] = "bill [player id] [amount]",
    },
    ["condition"] = {
        ["type"] = "JOB",
        ["params"] = "police",
    },
}

Commands["h1"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("facewear:adjust", source, 1, false, false)
    end,
    ["suggestion"] = {
        ["help"] = "Put on your Hat",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["h0"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("facewear:adjust", source, 1, true, false)
    end,
    ["suggestion"] = {
        ["help"] = "Take of your Hat",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["e1"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("facewear:adjust", source, 3, false, false)
    end,
    ["suggestion"] = {
        ["help"] = "Put on your Ear Picees",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["e0"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("facewear:adjust", source, 3, true, false)
    end,
    ["suggestion"] = {
        ["help"] = "Take of your Ear Picees",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["m1"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("facewear:adjust", source, 4, false, false)
    end,
    ["suggestion"] = {
        ["help"] = "Put on your Mask",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["m0"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("facewear:adjust", source, 4, true, false)
    end,
    ["suggestion"] = {
        ["help"] = "Take of your Mask",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["g1"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("facewear:adjust", source, 2, false, false)
    end,
    ["suggestion"] = {
        ["help"] = "Put on your Glasses",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["g0"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("facewear:adjust", source, 2, true, false)
    end,
    ["suggestion"] = {
        ["help"] = "Take of your Glasses",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["911"] = {
    ["function"] = function(source, args)
        if args[1] ~= nil then
	        TriggerClientEvent("ev-dispatch:911", source, table.concat(args, " "))
            TriggerEvent("ev-police:911", source, args)
        else
            TriggerClientEvent("DoLongHudText", source, "Use /911 [message]", 2)
        end
    end,
    ["suggestion"] = {
        ["help"] = "",
        ["params"] = {},
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

-- Commands["911o"] = {
--     ["function"] = function(source, args)
--         if args[1] ~= nil then
-- 	        TriggerClientEvent("ev-dispatch:911", source, table.concat(args, " "))
--         else
--             TriggerClientEvent("DoLongHudText", source, "Use /911 [message]", 2)
--         end
--     end,
--     ["suggestion"] = {
--         ["help"] = "",
--         ["params"] = {},
--     },
--     ["condition"] = {
--         ["type"] = "ALL",
--         ["params"] = {},
--     },
-- }

Commands["911r"] = {
    ["function"] = function(source, args)
        if args[1] ~= nil then
	        TriggerEvent("911r", source, args)
        else
            TriggerClientEvent("DoLongHudText", source, "Use /911r [message]", 2)
        end
    end,
    ["suggestion"] = {
        ["help"] = "",
        ["params"] = {},
    },
    ["condition"] = {
        ["type"] = "JOB",
        ["params"] = 'police',
    },
}

Commands["311"] = {
    ["function"] = function(source, args)
        if args[1] ~= nil then
	        TriggerClientEvent("ev-dispatch:311", source, table.concat(args, " "))
            TriggerEvent("ev-police:311", source, args)
        else
            TriggerClientEvent("DoLongHudText", source, "Use /311 [message]", 2)
        end
    end,
    ["suggestion"] = {
        ["help"] = "",
        ["params"] = {},
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["311r"] = {
    ["function"] = function(source, args)
        if args[1] ~= nil then
	        TriggerEvent("311r", source, args)
        else
            TriggerClientEvent("DoLongHudText", source, "Use /311r [message]", 2)
        end
    end,
    ["suggestion"] = {
        ["help"] = "",
        ["params"] = {},
    },
    ["condition"] = {
        ["type"] = "ems",
        ["params"] = 'police',
    },
}

Commands["menu"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("ev:admin:openMenu", source)
    end,
    ["suggestion"] = {
        ["help"] = "",
        ["params"] = {},
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["hud"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("ev-hud:openSettings", source)
    end,
    ["suggestion"] = {
        ["help"] = "HUD Settings",
        ["params"] = {
            { name="option", help="toggle | opacity | map"},
            { name="value", help="Toggle: health, armor, hunger, thirst, voice, oxygen | Opacity: 1.0-0.0, default 0.5 | Map: rect, circle"},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["hud-r"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("ev-hud:server-restart", source)
    end,
    ["suggestion"] = {
        ["help"] = "Restart Hud",
        ["params"] = {
            { name="option", help="To Restart the HUD"},
            { name="value", help="do /hud-r to restart the hud"},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["emotes"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("emotes:OpenMenu", source)
    end,
    ["suggestion"] = {
        ["help"] = "Open emotes menu.",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["e"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("animation:runtextanim2", source, string.lower(args[1]))
    end,
    ["suggestion"] = {
        ["help"] = "Play an emote.",
        ["params"] = {
            { name="emotename", help="Use /emotes to see all emotes."},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["outfits"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("hotel:outfit", source, false, 4)
    end,
    ["suggestion"] = {
        ["help"] = "Get a list of your current outfits.",
        ["params"] = {
            { name="outfits", help="Use /outfits to see the list."},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["saveoutfit"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("hotel:outfit", source, args, 1)
    end,
    ["suggestion"] = {
        ["help"] = "save your current outfit.",
        ["params"] = {
            { name="saveoutfit", help="Use /saveoutfit to save your current outfit."},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["#p"] = {
    ["function"] = function(source, args)
        local user = exports["ev-base"]:getModule("Player"):GetUser(source)
        local char = user:getVar("character")
        local srcPhone = exports["ev-phone"]:GetPhoneNumberByCid(char.id)
        TriggerClientEvent('sendMessagePhoneN', source, srcPhone)
    end,
    ["suggestion"] = {
        ["help"] = "to share your phone number.",
        ["params"] = {
            { name="#p", help="Use /#p to share your phone number."},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["cash"] = {
    ["function"] = function(source, args)
        TriggerEvent('cash:roll', source, tonumber(args[1]))
    end,
    ["suggestion"] = {
        ["help"] = "throw money at people .",
        ["params"] = {
            { name="cash", help="Use /cash [amount]."},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["givecash"] = {
    ["function"] = function(source, args)
        TriggerEvent("ev-financials:cash:give", source, args[1], tonumber(args[2]))
    end,
    ["suggestion"] = {
        ["help"] = "to give cash to a player.",
        ["params"] = {
            { name="givecash", help="Use /givecash [ID] [Amount] to give cash to a player."},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["givekeys"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("vehicle:giveKey", source)
    end,
    ["suggestion"] = {
        ["help"] = "give your vehicle key to the nearest player/s.",
        ["params"] = {
            { name="givekey", help="Use /givekey to give your vehicle key the nearest player/s."},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["emote"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("animation:runtextanim2", source, string.lower(args[1]))
    end,
    ["suggestion"] = {
        ["help"] = "Play an emote.",
        ["params"] = {
            { name="emotename", help="Use /emotes to see all emotes."},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["roll"] = {
    ["function"] = function(source, args)
        if not args[2] or not tonumber(args[2]) then return end
        if not args[3] or not tonumber(args[3]) then return end
        TriggerClientEvent("roll", source, args[2], args[3])
    end,
    ["suggestion"] = {
        ["help"] = "Roll the dice.",
        ["params"] = {
            { name="roll", help="TIMES MAXCOUNT - ex /roll 3 6 to roll 3 dice up to 6 count"},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["rob"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("police:rob", source)
    end,
    ["suggestion"] = {
        ["help"] = "Roll the dice.",
        ["params"] = {
            { name="roll", help="TIMES MAXCOUNT - ex /roll 3 6 to roll 3 dice up to 6 count"},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["oocg"] = {
    ["function"] = function(source, args)
        if not args[1] then return end
        local src = source
        local msg = ""
        for i = 1, #args do
          msg = msg .. " " .. args[i]
        end
        local user = exports["ev-base"]:getModule("Player"):GetUser(src)
        local char = user:getCurrentCharacter()
        local name = char.first_name .. " " .. char.last_name
        if not toggled then
            TriggerClientEvent('chatMessage', -1, 'OOC: '.. name .. ' ['.. src .. '] ', 2, msg, "OOC")
        elseif toggled then
            TriggerClientEvent("DoLongHudText", src, "OOC is disabled", 2)
        end
    end,
    ["suggestion"] = {
        ["help"] = "ooc (don't abuse it ).",
        ["params"] = {
            { name = "ooc", help = "/ooc to talk out of character"},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["report"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("ev-ui:report", source)
    end,
    ["suggestion"] = {
        ["help"] = "report to report an issue to the admins.",
        ["params"] = {
            { name = "report", help = "/report to report an issue to the admins"},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["s"] = {
    ["function"] = function(source, args)
        if not args[1] then return end
        local msg = ""
        for i = 1, #args do
          msg = msg .. " " .. args[i]
        end
        local user = exports["ev-base"]:getModule("Player"):GetUser(source)
        local userRank = exports["ev-lib"]:getUserRank(source)
        local defaultPower = exports["ev-admin"]:getRank("user");
        local userPower = exports["ev-admin"]:getRank(userRank);
        if (userPower > defaultPower) then
            TriggerClientEvent('ev-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
        end
    end,
    ["suggestion"] = {
        ["help"] = "Send a message to all staff members.",
        ["params"] = {
            { name = "s", help = "/Send a message to all staff members"},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["dv"] = {
    ["function"] = function(source, args)
        local user = exports["ev-base"]:getModule("Player"):GetUser(source)
        local userRank = exports["ev-lib"]:getUserRank(source)
        local defaultPower = exports["ev-admin"]:getRank("user");
        local userPower = exports["ev-admin"]:getRank(userRank);
        if (userPower > defaultPower) then
            TriggerClientEvent('Command:DeleteVehicle', source)
        end
    end,
    ["suggestion"] = {
        ["help"] = "Delete Vehicle (Admin Only).",
        ["params"] = {
            { name = "dv", help = "/Delete Vehicle (Admin Only)"},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["reportr"] = {
    ["function"] = function(source, args)
        local playerId = tonumber(args[1])
        table.remove(args, 1)
        local msg = table.concat(args, " ")
        local Target = exports["ev-base"]:getModule("Player"):GetUser(playerId)
        local users = exports["ev-base"]:getModule("Player"):GetUsers()
        local AdminPlayers = {}
        for k,v in pairs(users) do
            local userRank = exports["ev-lib"]:getUserRank(v)
            local defaultPower = exports["ev-admin"]:getRank("user");
            local userPower = exports["ev-admin"]:getRank(userRank);
            if (userPower > defaultPower) then
                AdminPlayers[#AdminPlayers+1]= v
            end
        end
        if Target ~= nil then
            TriggerClientEvent('chat:addMessage', playerId, {
                color = { 255, 0, 0},
                args = {"Admin Replay ( " .. GetPlayerName(source) .. " )  -  Msg ( " .. msg.. ' )'}
              })
            TriggerClientEvent("DoLongHudText", source, "Sent reply", 1)
            for k,v in ipairs(AdminPlayers) do
                TriggerClientEvent('chatMessage', v, GetPlayerName(source) .. " Replayed To : ( " .. playerId .. " ) Msg ", "system", msg)
            end
            
        else
            TriggerClientEvent("DoLongHudText", source, "Player is not online", 2)
        end
    end,
    ["suggestion"] = {
        ["help"] = "to respond to a report.",
        ["params"] = {
            { name = "reportr", help = "/reportr [ID] [your respond]"},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["oocl"] = {
    ["function"] = function(source, args)
        if not args[1] then return end
        local src = source
        local msg = ""
        for i = 1, #args do
          msg = msg .. " " .. args[i]
        end

        local coords = GetEntityCoords(GetPlayerPed(source))
        local players = exports["ev-infinity"]:GetNerbyPlayers(coords, 20)

        local user = exports["ev-base"]:getModule("Player"):GetUser(src)
        local char = user:getCurrentCharacter()
        local name = char.first_name .. " " .. char.last_name
        if not toggled then
            for i, v in ipairs(players) do
                TriggerClientEvent('chatMessage', v, 'OOC: '.. name .. ' ['.. src .. '] ', 2, msg, "OOC")
            end
        elseif toggled then
            TriggerClientEvent("DoLongHudText", src, "OOC is disabled", 2)
        end
    end,
    ["suggestion"] = {
        ["help"] = "ooc (don't abuse it ).",
        ["params"] = {
            { name = "ooc", help = "/ooc to talk out of character"},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["clear"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("chat:clear", source)
    end,
    ["suggestion"] = {
        ["help"] = "to clear the chat.",
        ["params"] = {
            { name="clear", help=" to clear the chat."},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["bug"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("ev-ui:bug", source)
    end,
    ["suggestion"] = {
        ["help"] = "to send a bug report.",
        ["params"] = {
            { name="bug", help=" to send a bug report."},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["pzcreate"] = {
    ["function"] = function(source, args)
        local zoneType = args[1]
        if zoneType == nil then
          TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Me", "Please add zone type to create (poly, circle, box)!"}
          })
          return
        end
        if zoneType ~= 'poly' and zoneType ~= 'circle' and zoneType ~= 'box' then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = {"Me", "Zone type must be one of: poly, circle, box"}
            })
          return
        end
        local name = GetUserInput("Enter name of zone:")
        if name == nil or name == "" then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = {"Me", "Please add a name!"} 
            })
          return
        end
        TriggerClientEvent("polyzone:pzcreate", source, zoneType, name)
    end,
    ["suggestion"] = {
        ["help"] = "to create polyzone.",
        ["params"] = {
            { name="pzcreate", help=" to create polyzone."},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["pzadd"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("polyzone:pzadd", source)
    end,
    ["suggestion"] = {
        ["help"] = "to add polyzone.",
        ["params"] = {
            { name="pzadd", help=" to add polyzone."},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["pzadd"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("polyzone:pzadd", source)
    end,
    ["suggestion"] = {
        ["help"] = "to add polyzone.",
        ["params"] = {
            { name="pzadd", help=" to add polyzone."},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["pzfinish"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("polyzone:pzfinish", source)
    end,
    ["suggestion"] = {
        ["help"] = "to save current polyzone.",
        ["params"] = {
            { name="pzfinish", help=" to save current polyzone."},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["pzlast"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("polyzone:pzlast", source)
    end,
    ["suggestion"] = {
        ["help"] = "to get last polyzone.",
        ["params"] = {
            { name="pzlast", help=" to get last polyzone."},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["pzcancel"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("polyzone:pzcancel", source)
    end,
    ["suggestion"] = {
        ["help"] = "to cancel current polyzone.",
        ["params"] = {
            { name="pzcancel", help=" to cancel current polyzone."},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["pzundo"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("polyzone:pzundo", source)
    end,
    ["suggestion"] = {
        ["help"] = "to add polyzone.",
        ["params"] = {
            { name="pzadd", help=" to add polyzone."},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["clearall"] = {
    ["function"] = function(source, args)
        local user = exports["ev-base"]:getModule("Player"):GetUser(source)
        local rank = user:getVar("rank")
    
        if rank ~= "user" then
            TriggerClientEvent("chat:clear", -1)
        end
    end,
    ["suggestion"] = {
        ["help"] = "to clear the chat for everyone.",
        ["params"] = {
            { name ="clearall", help="to clear the chat for everyone"},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["disable"] = {
    ["function"] = function(source, args)
        local user = exports["ev-base"]:getModule("Player"):GetUser(source)
        local rank = user:getVar("rank")
        local command = string.lower(args[1])
    
        if rank ~= "user" then
            if command == "ooc" then
                toggled = not toggled
                TriggerClientEvent("DoLongHudText", source, ('OOC has been %s!'):format(toggled and 'Disabled' or 'Enabled'))
            end
        end
    end,
    ["suggestion"] = {
        ["help"] = "to disable the chat.",
        ["params"] = {
            { name="disable", help="to disable the chat"},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["reporttoggle"] = {
    ["function"] = function(source, args)
        local user = exports["ev-base"]:getModule("Player"):GetUser(source)
        local command = string.lower(args[1])
        local user = exports["ev-base"]:getModule("Player"):GetUser(source)
        local userRank = exports["ev-lib"]:getUserRank(source)
        local defaultPower = exports["ev-admin"]:getRank("user");
        local userPower = exports["ev-admin"]:getRank(userRank);

        if (userPower > defaultPower) then
            toggledReport = not toggledReport
            TriggerClientEvent("DoLongHudText", source, ('Reports has been %s!'):format(toggledReport and 'Disabled' or 'Enabled'))
        end
    end,
    ["suggestion"] = {
        ["help"] = "to show/hide the reports.",
        ["params"] = {
            { name="reporttoggle", help="to show/hide the reports"},
        },
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["racing"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("rahe-racing:client:openTablet", source)
    end,
    ["suggestion"] = {
        ["help"] = "to add polyzone.",
        ["params"] = {
            { name="pzadd", help=" to add polyzone."},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["boosting"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("rahe-boosting:client:openTablet", source)
    end,
    ["suggestion"] = {
        ["help"] = "to add polyzone.",
        ["params"] = {
            { name="pzadd", help=" to add polyzone."},
        },
    },
    ["condition"] = {
        ["type"] = "ADMIN",
        ["params"] = {},
    },
}

Commands["toggletop"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("tow:toggletop", source)
    end,
    ["suggestion"] = {
        ["help"] = "Toggle TR2 Trailer Top.",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}
Commands["setcar"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("tow:setcar", source)
    end,
    ["suggestion"] = {
        ["help"] = "Set Car On TR2 Trailer.",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}
Commands["unsetcar"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("tow:unsetcar", source)
    end,
    ["suggestion"] = {
        ["help"] = "Unstrap Car From TR2 Trailer.",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["dance"] = {
    ["function"] = function(source,args)
        local sex = args [1]
        if not sex or sex == nil or sex == "" then
            TriggerEvent('ev:dances:dance', tonumber(args[1]))
        end
    end,
    ["suggestion"] = {
        ["help"] = "Chose a dance from 1 - 3889",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["me"] = {
    ["function"] = function(source, args)
        local Coords = GetEntityCoords(GetPlayerPed(source))
        local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
        for i = 1,#args do
            text = text .. ' ' .. args[i]
        end
        text = text .. ''
        TriggerEvent('3dme:shareDisplay', text, Coords)
    end,
    ["suggestion"] = {
        ["help"] = "Unstrap Car From TR2 Trailer.",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

--[[ Commands["air"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("cs:airsus:openUI", source)
    end,
    ["suggestion"] = {
        ["help"] = "Unstrap Car From TR2 Trailer.",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
} ]]

--[[ Commands["tuner"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("tuner:open", source)
    end,
    ["suggestion"] = {
        ["help"] = "Unstrap Car From TR2 Trailer.",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}
 ]]

Commands["ui-r"] = {
    ["suggestion"] = {
        ["help"] = "Restart UI",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["hud"] = {
    ["function"] = function(source, args)
        TriggerClientEvent("ev-ui:openHud", source)
    end,
    ["suggestion"] = {
        ["help"] = "Open hud settings",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

Commands["testenv"] = {
    ["function"] = function(source, args)
        print("convar", GetConvar("sv_environment", "prod"))
    end,
    ["suggestion"] = {
        ["help"] = "WWWW",
    },
    ["condition"] = {
        ["type"] = "ALL",
        ["params"] = {},
    },
}

exports("CommandsList", function()
    return Commands
end) 