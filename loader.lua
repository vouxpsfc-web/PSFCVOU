-- [[ PSFCVOU MASTER SOURCE - FULL ENGLISH ]]
-- Rules: Warp 5.2/3.2 | Blue Gate (0,0,255) | Persistent Speed

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Win = Rayfield:CreateWindow({
   Name = "PSFCVOU HUB",
   LoadingTitle = "PSFCVOU EXECUTION",
   LoadingSubtitle = "by Gemini",
   ConfigurationPersist = true,
   KeySystem = false
})

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local speedOffset, isAttacking = 0, false
local espP, espG, boostActive = false, false, false
local selectedPlayerName = ""

-- [ Core ESP Function - High Visibility ]
local function applyHighlight(obj, color, enabled)
    if not obj then return end
    local h = obj:FindFirstChild("PSFCVOU_H") or Instance.new("Highlight", obj)
    h.Name = "PSFCVOU_H"
    h.FillColor = color
    h.FillTransparency = 0.4
    h.OutlineTransparency = 0
    h.Enabled = enabled
    h.Adornee = obj
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

-- [ Tabs ]
local WarpTab = Win:CreateTab("Warp (W)")
local ESPTab = Win:CreateTab("Visuals (E)")
local SpeedTab = Win:CreateTab("Speed (S)")

-- Warp Section
local PlayerDropdown = WarpTab:CreateDropdown({
   Name = "Target Player",
   Options = {"Refresh List..."},
   CurrentOption = "",
   Callback = function(Option) selectedPlayerName = Option[1] end,
})

WarpTab:CreateButton({
   Name = "1. Refresh Player List",
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

-- Visuals Section (GPS/ESP)
ESPTab:CreateToggle({ Name = "ESP Players", CurrentValue = false, Callback = function(v) espP = v end })
ESPTab:CreateToggle({ Name = "ESP Objectives (GPS)", CurrentValue = false, Callback = function(v) espG = v end })

-- Speed Section
SpeedTab:CreateInput({ Name = "Speed Offset", PlaceholderText = "Ex: 5", Callback = function(v) speedOffset = tonumber(v) or 0 end })
SpeedTab:CreateToggle({ Name = "Enable Persistent Speed", CurrentValue = false, Callback = function(v) boostActive = v end })

-- [ Main Game Loop ]
rs.Heartbeat:Connect(function()
    -- Persistent Speed Logic
    if boostActive and lp.Character and lp.Character:FindFirstChild("Humanoid") and not isAttacking then
        lp.Character.Humanoid.WalkSpeed = 16 + speedOffset
    end

    -- Universal Scanner for Objects & Exit Gates
    for _, v in pairs(workspace:GetDescendants()) do
        local n = v.Name:lower()
        -- Exit Gate Rule: Always Blue (0,0,255)
        if n:find("exit") or n:find("gate") or n:find("escape") then
            applyHighlight(v, Color3.fromRGB(0, 0, 255), true)
        -- GPS/Objective: Yellow
        elseif n:find("gen") or n:find("objective") or n:find("machine") then
            applyHighlight(v, Color3.new(1, 1, 0), espG)
        end
    end

    -- Player ESP Logic
    if espP then
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= lp and p.Character then applyHighlight(p.Character, Color3.new(1, 0, 0), true) end
        end
    end
end)
