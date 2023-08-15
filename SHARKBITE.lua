local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local xxxWindow = ArrayField:CreateWindow({
    Name = "SharkBite 2 - CandyHub",
    LoadingTitle = "CandyHub",
    LoadingSubtitle = "by Flames",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = CandyHub, -- Create a custom folder for your hub/game
        FileName = "CandyHub"
    },
    Discord = {
        Enabled = true,
        Invite = "MpY7h3WqNh", -- The Discord invite code
        RememberJoins = true -- Join the discord every time they load
    },
    KeySystem = true, -- Use our key system
    KeySettings = {
        Title = "CandyHub | Key",
        Subtitle = "Key System",
        Note = "Key is in discord (discord.gg/MpY7h3WqNh)",
        FileName = "Key", -- Use something unique for key file
        SaveKey = false, -- The user's key will be saved
        GrabKeyFromSite = false, -- Get the key from the RAW site
        Actions = {
            [1] = {
                Text = 'Click here to copy the discord link <--',
                OnPress = function()
                    setclipboard("discord.gg/MpY7h3WqNh")
                end,
            }
        },
        Key = {"k4JH8n_9sP$3mV#TgZ*F2qL%6QbRc1E7zXo!Y5W"} -- Accepted keys by the system
    }
})

local Main131Tab = xxxWindow:CreateTab("Main", nil) -- Title, Image

local FrmSection = Main131Tab:CreateSection("Free Boats",false)

local BoatOptions = {"DuckyBoatBeta", "DuckyBoat", "BlueCanopyMotorboat", "BlueWoodenMotorboat", "UnicornBoat", "Jetski", "RedMarlin", "Sloop", "TugBoat", "SmallDinghyMotorboat", "JetskiDonut", "Marlin", "TubeBoat", "FishingBoat", "VikingShip", "SmallWoodenSailboat", "RedCanopyMotorboat", "Catamaran", "CombatBoat", "TourBoat", "Duckmarine", "PartyBoat", "MilitarySubmarine", "GingerbreadSteamBoat", "Sleigh2022", "Snowmobile", "CruiseShip", "Wildfire", "SharkCageBoat"}

for _, boat in ipairs(BoatOptions) do
    local Button = Main131Tab:CreateButton({
        Name = boat,
        Interact = 'Click',
        SectionParent = FrmSection,
        Callback = function()
            local ohString1 = boat
            game:GetService("ReplicatedStorage").EventsFolder.BoatSelection.UpdateHostBoat:FireServer(ohString1)
        end,
    })
end