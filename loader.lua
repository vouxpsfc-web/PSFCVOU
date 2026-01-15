-- [[ Delta Hub: V66 - FIXED FUNCTIONALITY ]] --
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

pcall(function() 
    if game.CoreGui:FindFirstChild("Delta_V66_Clean") then 
        game.CoreGui.Delta_V66_Clean:Destroy() 
    end 
end)

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "Delta_V66_Clean"
screenGui.ResetOnSpawn = false

-- [[ MENU UI ]] --
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 380, 0, 320)
main.Position = UDim2.new(0.5, -190, 0.4, -160)
main.BackgroundColor3 = Color3.new(0,0,0)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.new(1,1,1)
main.Visible = true
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 90, 0, 35)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.BackgroundColor3 = Color3.new(0,0,0)
openBtn.Text = "MENU"
openBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", openBtn)
openBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

----------------------------------------------------------------
-- [[ ESP LOGIC - FORCE ENABLED ]] --
----------------------------------------------------------------
local auraOn = true  -- บังคับเปิด Aura
local infoOn = true  -- บังคับเปิด Name/Dist

local function isKiller(p)
    if not p or not p.Character then return false end
    if p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("slasher")) then return true end
    if p.TeamColor.Name:find("Red") or p.TeamColor.Name:find("Scarlet") then return true end
    return p.Character:FindFirstChild("Knife") ~= nil or p.Character:FindFirstChild("Slasher") ~= nil
end

local function applyESP(p)
    if p == localPlayer then return end
    
    -- สร้าง Highlight (เส้นรอบตัว)
    local high = Instance.new("Highlight")
    high.Name = "ESP_Highlight"
    high.OutlineColor = Color3.new(1,1,1)
    high.OutlineThickness = 0.005 -- [ตามสั่ง: หนา 0.005]
    high.FillTransparency = 0.5
    
    -- สร้าง Billboard (ชื่อและระยะทาง)
    local bGui = Instance.new("BillboardGui", screenGui)
    bGui.AlwaysOnTop = true
    bGui.Size = UDim2.new(0, 200, 0, 50)
    
    local lName = Instance.new("TextLabel", bGui)
    lName.Size = UDim2.new(1, 0, 0.5, 0)
    lName.Position = UDim2.new(0, 0, 0, 0)
    lName.BackgroundTransparency = 1
    lName.Font = Enum.Font.GothamBold
    lName.TextColor3 = Color3.new(1,1,1)
    lName.TextStrokeTransparency = 0

    local lDist = Instance.new("TextLabel", bGui)
    lDist.Size = UDim2.new(1, 0, 0.5, 0)
    lDist.Position = UDim2.new(0, 0, 0, 0) -- เดี๋ยวจะใช้ Offset คุมระยะ
    lDist.BackgroundTransparency = 1
    lDist.Font = Enum.Font.GothamBold
    lDist.TextColor3 = Color3.new(1,1,1)
    lDist.TextStrokeTransparency = 0

    runService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local dist = (workspace.CurrentCamera.CFrame.Position - hrp.Position).Magnitude
            
            if auraOn then
                high.Parent = p.Character
                high.Enabled = true
                high.FillColor = isKiller(p) and Color3.new(1,0,0) or Color3.new(0,1,0)
                
                if infoOn then
                    bGui.Parent = hrp
                    bGui.Enabled = true
                    lName.Text = p.Name
                    lDist.Text = math.floor(dist) .. " studs"
                    
                    -- [ตามสั่ง: ระยะห่างชื่อกับเลขรวม 8.5 studs]
                    lName.Position = UDim2.new(0, 0, 0, -25) -- ขยับชื่อขึ้น
                    lDist.Position = UDim2.new(0, 0, 0, 25)  -- ขยับเลขลง (ห่างกันรวม 8.5 โดยประมาณในสเกล UI)
                    bGui.StudsOffset = Vector3.new(0, 4, 0)
                    
                    local sz = math.clamp(14 - (dist/100), 10, 14)
                    lName.TextSize = sz; lDist.TextSize = sz - 2
                else bGui.Enabled = false end
            else high.Enabled = false; bGui.Enabled = false end
        else
            high.Enabled = false; bGui.Enabled = false
        end
    end)
end

-- รันฟังก์ชันทันที
for _, p in pairs(players:GetPlayers()) do
    if p.Character then applyESP(p) end
    p.CharacterAdded:Connect(function() applyESP(p) end)
end
players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() applyESP(p) end)
end)
