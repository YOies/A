repeat wait() until game:IsLoaded()
local startTime = tick()
local towerRecord = {}
local httpService = game:GetService("HttpService")
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    args = {...}
    if getnamecallmethod() == "FireServer" and tostring(self) == "SummonTower" then
        towerRecord[#towerRecord + 1] = {
            ["time"] = tick() - startTime; 
            ["moneyreq"] = tostring(game.Players.LocalPlayer.Money.Value);
            ["character"] = args[1]; 
            ["position"] = tostring(args[2]); 
            ["type"] = "CreateUnit";
        }    
    elseif getnamecallmethod() == "FireServer" and tostring(self) == "Upgrade" then
        towerRecord[#towerRecord + 1] = {
            ["time"] = tick() - startTime; 
            ["upgradestar"] = args[1].UpgradeStar.Value;
            ["character"] = args[1]; 
            ["type"] = "UpgradeUnit";
            
        }    
    elseif getnamecallmethod() == "FireServer" and tostring(self) == "Sell" then
        towerRecord[#towerRecord + 1] = {
            ["time"] = tick() - startTime; 
            ["character"] = args[1].Name; 
            ["type"] = "SellUnit";
        }    
    elseif getnamecallmethod() == "FireServer" and tostring(self) == "Target" then
        towerRecord[#towerRecord + 1] = {
            ["time"] = tick() - startTime; 
            ["character"] = args[1].Name;
            ["target"] = args[1]:GetAttribute("Priority");
            ["type"] = "ChangeTarget";
        }    
    end

    
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

local function waitForUI()
    while true do  
        local uiElement = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("GameSelection")
        if uiElement and not uiElement.Enabled then
            break
        end
        wait()
    end
end

waitForUI()

spawn(function()
    while task.wait() do 
        writefile("a.txt", httpService:JSONEncode(towerRecord))
    end
end)


