-- [[ Delta Hub: V66 - REMOVED WINDOW ESP ]] --
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

pcall(function() if game.CoreGui:FindFirstChild("Delta_V66_Clean") then game.CoreGui.Delta_V66_Clean:Destroy() end end)

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "Delta_V66_Clean"
screenGui.ResetOnSpawn = false

-- [[ MENU UI ]]
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 380, 0, 320); main.Position = UDim2.new(0.5, -190, 0.4, -160)
main.BackgroundColor3 = Color3.new(0,0,0); main.BorderSizePixel = 2; main.BorderColor3 = Color3.new(1,1,1)
main.Visible = true; main.Active = true; main.Draggable = true; Instance.new("UICorner", main)

local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 90, 0, 35); openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.BackgroundColor3 = Color3.new(0,0,0); openBtn.Text = "MENU"; openBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", openBtn)
openBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

local function createTab(t, y, c)
    local b = Instance.new("TextButton", main); b.Size = UDim2.new(0, 50, 0, 50); b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = c; b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 25; Instance.new("UICorner", b); return b
end
local wBtn = createTab("W", 15, Color3.fromRGB(0,0,255)); local eBtn = createTab("E", 75, Color3.fromRGB(0,255,0)); local sBtn = createTab("S", 135, Color3.fromRGB(255,0,0))
local function createPage()
    local p = Instance.new("Frame", main); p.Size = UDim2.new(1, -80, 1, -20); p.Position = UDim2.new(0, 70, 0, 10); p.BackgroundTransparency = 1; p.Visible = false; return p
end
local wPage = createPage(); wPage.Visible = true; local ePage = createPage(); local sPage = createPage()
wBtn.MouseButton1Click:Connect(function() wPage.Visible = true; ePage.Visible = false; sPage.Visible = false end)
eBtn.MouseButton1Click:Connect(function() wPage.Visible = false; ePage.Visible = true; sPage.Visible = false end)
sBtn.MouseButton1Click:Connect(function() wPage.Visible = false; ePage.Visible = false; sPage.Visible = true end)

----------------------------------------------------------------
-- [[ ESP LOGIC ]]
----------------------------------------------------------------
local auraOn, infoOn, genOn, palletOn = false, false, false, false

local function isKiller(p)
    if not p or not p.Character then return false end
    if p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("slasher")) then return true end
    if p.TeamColor.Name:find("Red") or p.TeamColor.Name:find("Scarlet") then return true end
    return p.Character:FindFirstChild("Knife") ~= nil or p.Character:FindFirstChild("Slasher") ~= nil
end

local function applyESP(p)
    if p == localPlayer then return end
    local high = Instance.new("Highlight")
    high.OutlineColor = Color3.new(1,1,1); high.OutlineTransparency = 0; high.FillTransparency = 0.4
    
    local bName = Instance.new("BillboardGui", screenGui); bName.AlwaysOnTop = true; bName.Size = UDim2.new(0, 200, 0, 50)
    local lName = Instance.new("TextLabel", bName); lName.Size = UDim2.new(1,0,1,0); lName.BackgroundTransparency = 1; lName.Font = Enum.Font.GothamBold
    local bDist = Instance.new("BillboardGui", screenGui); bDist.AlwaysOnTop = true; bDist.Size = UDim2.new(0, 200, 0, 50)
    local lDist = Instance.new("TextLabel", bDist); lDist.Size = UDim2.new(1,0,1,0); lDist.BackgroundTransparency = 1; lDist.Font = Enum.Font.GothamBold

    runService.Heartbeat:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local dist = (workspace.CurrentCamera.CFrame.Position - hrp.Position).Magnitude
            if auraOn then
                high.Parent = p.Character; high.Enabled = true
                high.FillColor = isKiller(p) and Color3.new(1,0,0) or Color3.new(0,1,0)
                if infoOn then
                    bName.Parent = hrp; bName.Enabled = true; lName.Text = p.Name; lName.TextColor3 = high.FillColor
                    bDist.Parent = hrp; bDist.Enabled = true; lDist.Text = math.floor(dist) .. "m"; lDist.TextColor3 = high.FillColor
                    if dist >= 110 then bName.StudsOffset = Vector3.new(0, 5.5, 0); bDist.StudsOffset = Vector3.new(0, -5.5, 0)
                    else bName.StudsOffset = Vector3.new(0, 4.25, 0); bDist.StudsOffset = Vector3.new(0, -4.25, 0) end
                    local sz = (dist >= 5000) and 13 or math.clamp(11 + (dist/500), 11, 13)
                    lName.TextSize = sz; lDist.TextSize = sz - 1
                else bName.Enabled = false; bDist.Enabled = false end
            else high.Enabled = false; bName.Enabled = false; bDist.Enabled = false end
        else high.Enabled = false; bName
