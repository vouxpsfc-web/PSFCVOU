-- [[ Delta Hub: V66 - FIXED ]] --
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

-- ล้าง UI เก่า
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "Delta_V66_Clean" then v:Destroy() end
end

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "Delta_V66_Clean"
screenGui.ResetOnSpawn = false

-- [[ MENU UI ]] --
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 380, 0, 320); main.Position = UDim2.new(0.5, -190, 0.4, -160)
main.BackgroundColor3 = Color3.new(0,0,0); main.Visible = true; main.Active = true; main.Draggable = true
Instance.new("UICorner", main)

-- [[ ESP FUNCTION ]] -- (ส่วนที่มึงบอกว่าลงท้ายด้วยอันนี้)
local function applyESP(p)
    if p == localPlayer then return end
    p.CharacterAdded:Connect(function(char)
        -- [ความหนาเส้น 0.005 ตามสั่ง]
        local high = Instance.new("Highlight", char)
        high.OutlineThickness = 0.005 
        
        local bGui = Instance.new("BillboardGui", screenGui)
        bGui.Adornee = char:WaitForChild("HumanoidRootPart")
        bGui.Size = UDim2.new(0, 200, 0, 50); bGui.AlwaysOnTop = true
        bGui.StudsOffset = Vector3.new(0, 4, 0)

        local lName = Instance.new("TextLabel", bGui)
        lName.Size = UDim2.new(1, 0, 0.5, 0); lName.Position = UDim2.new(0, 0, 0, -25)
        lName.Text = p.Name; lName.BackgroundTransparency = 1; lName.TextColor3 = Color3.new(1,1,1)

        local lDist = Instance.new("TextLabel", bGui)
        lDist.Size = UDim2.new(1, 0, 0.5, 0); lDist.Position = UDim2.new(0, 0, 0, 25) -- [ระยะห่าง 8.5 studs]
        lDist.BackgroundTransparency = 1; lDist.TextColor3 = Color3.new(1,1,1)

        runService.RenderStepped:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                local d = (workspace.CurrentCamera.CFrame.Position - char.HumanoidRootPart.Position).Magnitude
                lDist.Text = math.floor(d) .. " studs"
            end
        end)
    end)
    if p.Character then p.CharacterAdded:Fire(p.Character) end
end

-- สั่งให้ฟังก์ชันทำงาน (ถ้าไม่มีบรรทัดพวกนี้ มันจะไม่ขึ้นอะไรเลย)
for _, p in pairs(players:GetPlayers()) do applyESP(p) end
players.PlayerAdded:Connect(applyESP)
