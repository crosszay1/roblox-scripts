local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/crosszay1/roblox-scripts/main/source.lua"))()
local Window = Library.CreateLib("Combat Warriors Aimbot", "Ocean")
    -- MAIN
    local Main = Window:NewTab("Main")
    local MainSection = Main:NewSection("Main")


    MainSection:NewButton("Aimbot Crossbow", ".", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/crosszay1/roblox-scripts/main/local.lua"))()
    end)

    MainSection:NewButton("Infinite Yield", "FE Admin Commands", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/deleteduser8291/combotwarriors/main/aimbot.lua", true))()
    end)

    MainSection:NewSlider("Walkspeed", "SPEED!!", 500, 16, function(s)

    end)

    MainSection:NewSlider("Jumppower", "JUMP HIGH!!", 350, 50, function(s)

    end)

    MainSection:NewButton("Reset WS/JP", "Resets to all defaults", function()


    end)


    --Other
    local Other = Window:NewTab("Other")
    local OtherSection = Other:NewSection("Other")

    OtherSection:NewButton("Chat Spoofer", "Lets you chat for other people", function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/crosszay1/roblox-scripts/main/module1.lua"),true))()
    end)

    OtherSection:NewButton("Bypassed Fly", "bird mode", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Nicuse/RobloxScripts/main/BypassedFly.lua"))() 

        Fly(true)
    end)