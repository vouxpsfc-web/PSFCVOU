-- [[ Delta Hub: V66 - FIXED ]] --
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

-- ล้าง UI เก่า (สำคัญมาก ถ้าไม่ล้างรันซ้ำแล้วมันจะบัค)
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "Delta_V66_Clean" then v:Destroy() end
end

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "Delta_V66_Clean"
screenGui.ResetOnSpawn = false

-- สร้าง Frame หลัก (ถ้าตัวนี้ไม่ขึ้น คือ Error ตั้งแต่บรรทัดแรกๆ)
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 380, 0, 320)
main.Position = UDim2.new(0.5, -190, 0.4, -160)
main.BackgroundColor3 = Color3.new(0,0,0)
main.Visible = true
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

-- [[ ESP FUNCTION ]] --
local function applyESP(p)
    if p == localPlayer then return end
    p.CharacterAdded:Connect(function(char)
        local high = Instance.new("Highlight", char)
        high.OutlineThickness = 0.005 -- [ตามสั่ง]
        
        local bGui = Instance.new("BillboardGui", screenGui)
        bGui.Adornee = char:WaitForChild("HumanoidRootPart")
        bGui.Size = UDim2.new(0, 200, 0, 50)
        bGui.AlwaysOnTop = true
        bGui.StudsOffset = Vector3.new(0, 4, 0)

        local lName = Instance.new("TextLabel", bGui)
        lName.Size = UDim2.new(1, 0, 0.5, 0)
        lName.Position = UDim2.new(0, 0, 0, -25) -- [ระยะห่าง 8.5 รวมกับข้างล่าง]
        lName.Text = p.Name; lName.BackgroundTransparency = 1; lName.TextColor3 = Color3.new(1,1,1)

        local lDist = Instance.new("TextLabel", bGui)
        lDist.Size = UDim2.new(1, 0, 0.5, 0)
        lDist.Position = UDim2.new(0, 0, 0, 25)
        lDist.BackgroundTransparency = 1; lDist.TextColor3 = Color3.new(1,1,1)

        runService.RenderStepped:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                local d = (workspace.CurrentCamera.CFrame.Position - char.HumanoidRootPart.Position).Magnitude
                lDist.Text = math.floor(d) .. " studs"
            end
        end)
    end)
    if p.Character then applyESP(p) end -- รันทันทีถ้าตัวละครมีอยู่แล้ว
end

for _, p in pairs(players:GetPlayers()) do applyESP(p) end
players.PlayerAdded:Connect(applyESP)
