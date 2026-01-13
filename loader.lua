-- [[ PSFCVOU MASTER SOURCE ]]
-- Features: Warp (W), Smart ESP (E), Speed Offset (S)
-- Exit Gate: Blue (0, 0, 255) | Speed Persistence: Active

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Win = Rayfield:CreateWindow({
   Name = "PSFCVOU HUB",
   LoadingTitle = "PSFCVOU Loading...",
   LoadingSubtitle = "by Gemini",
   ConfigurationPersist = true,
   KeySystem = false
})

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local speedOffset, isAttacking = 0, false
local espP, espG, espPl, boostActive = false, false, false, false
local selectedPlayerName = ""

local function applyHighlight(obj, color, enabled)
    local h = obj:FindFirstChild("PSFCVOU_H") or Instance.new("Highlight", obj)
    h.Name = "PSFCVOU_H"; h.FillColor = color; h.FillTransparency = 0.4; h.OutlineTransparency = 1; h.Enabled = enabled
end

local WarpTab = Win:CreateTab("Warp (W)")
local PlayerDropdown = WarpTab:CreateDropdown({
   Name = "Select Player",
   Options = {"Refresh First"},
   CurrentOption = "",
   Callback = function(Option) selectedPlayerName = Option[1] end,
})

WarpTab:CreateButton({
   Name = "Refresh List",
   Callback = function()
      local pList = {}
      for _, p in pairs(game:GetService("Players"):GetPlayers()) do
         if p ~= lp then table.insert(pList, p.Name) end
      end
      PlayerDropdown:Refresh(pList)
   end,
})

WarpTab:CreateButton({
   Name = "Warp Front (5.2m)",
   Callback = function()
      local target = game:GetService("Players"):FindFirstChild(selectedPlayerName)
      if lp.Character and target and target.Character then
         lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1.5, -5.2) * CFrame.Angles(0, math.pi, 0)
      end
   end,
})

WarpTab:CreateButton({
   Name = "Warp Back (3.2m)",
   Callback = function()
      local target = game:GetService("Players"):FindFirstChild(selectedPlayerName)
      if lp.Character and target and target.Character then
         lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1.5, 3.2)
      end
   end,
})

local ESPTab = Win:CreateTab("Visuals (E)")
ESPTab:CreateToggle({ Name = "ESP Players", CurrentValue = false, Callback = function(v) espP = v end })
ESPTab:CreateToggle({ Name = "ESP Generators", CurrentValue = false, Callback = function(v) espG = v end })
ESPTab:CreateToggle({ Name = "Smart Pallets", CurrentValue = false, Callback = function(v) espPl = v end })

local SpeedTab = Win:CreateTab("Speed (S)")
SpeedTab:CreateInput({ Name = "Speed Offset", PlaceholderText = "Ex: 5", Callback = function(v) speedOffset = tonumber(v) or 0 end })
SpeedTab:CreateToggle({ Name = "Enable Speed", CurrentValue = false, Callback = function(v) boostActive = v end })

rs.Heartbeat:Connect(function()
    if boostActive and lp.Character and lp.Character:FindFirstChild("Humanoid") and not isAttacking then
        lp.Character.Humanoid.WalkSpeed = 16 + speedOffset
    end
    for _, v in pairs(workspace:GetDescendants()) do
        local n = v.Name:lower()
        if n:find("generator") then applyHighlight(v, Color3.new(1, 1, 0), espG)
        elseif (n:find("pallet") or n:find("wood")) and not (n:find("tree") or n:find("trunk")) then applyHighlight(v, Color3.new(1, 0, 0), espPl)
        elseif n:find("exit") or n:find("gate") then applyHighlight(v, Color3.fromRGB(0, 0, 255), true) end
    end
end)
