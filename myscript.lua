-- [[ PROJECT: NEW BEGINNING v1.4 - THAI UI & DRAGGABLE ]] --
local players = game:GetService("Players")
local coreGui = game:GetService("CoreGui")
local runService = game:GetService("RunService")
local localPlayer = players.LocalPlayer

pcall(function() 
    if coreGui:FindFirstChild("ProjectNew_UI") then 
        coreGui.ProjectNew_UI:Destroy() 
    end 
end)

local ScreenGui = Instance.new("ScreenGui", coreGui)
ScreenGui.Name = "ProjectNew_UI"
ScreenGui.ResetOnSpawn = false

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
local mainCorner = Instance.new("UICorner", MainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)
makeDraggable(MainFrame)

local MenuToggleBtn = Instance.new("TextButton", ScreenGui)
MenuToggleBtn.Size = UDim2.new(0, 80, 0, 40)
MenuToggleBtn.Position = UDim2.new(0, 10, 0, 10)
MenuToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MenuToggleBtn.Text = "ปิด"
MenuToggleBtn.TextColor3 = Color3.new(1, 1, 1)
MenuToggleBtn.Font = Enum.Font.GothamBold
MenuToggleBtn.TextSize = 16
local btnCorner = Instance.new("UICorner", MenuToggleBtn)
btnCorner.CornerRadius = UDim.new(0, 8)
makeDraggable(MenuToggleBtn)

MenuToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    MenuToggleBtn.Text = MainFrame.Visible and "ปิด" or "เปิด"
    MenuToggleBtn.BackgroundColor3 = MainFrame.Visible and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(0, 80, 200)
end)

local Header = Instance.new("TextLabel", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1
Header.Text = "PROJECT NEW v1.4"
Header.TextColor3 = Color3.new(1, 1, 1)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 16

local autoRunEnabled = false
local SpeedBtn = Instance.new("TextButton", MainFrame)
SpeedBtn.Size = UDim2.new(0, 310, 0, 50)
SpeedBtn.Position = UDim2.new(0, 20, 0, 60)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedBtn.Text = "Smart Speed 138: OFF"
SpeedBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedBtn.Font = Enum.Font.GothamBold
local SpeedCorner = Instance.new("UICorner", SpeedBtn)
local SpeedStroke = Instance.new("UIStroke", SpeedBtn)
SpeedStroke.Thickness = 2
SpeedStroke.Color = Color3.fromRGB(60, 60, 60)

SpeedBtn.MouseButton1Click:Connect(function()
    autoRunEnabled = not autoRunEnabled
    if autoRunEnabled then
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 50, 150)
        SpeedBtn.Text = "Smart Speed 138: ON"
        SpeedStroke.Color = Color3.fromRGB(0, 150, 255)
    else
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        SpeedBtn.Text = "Smart Speed 138: OFF"
        SpeedStroke.Color = Color3.fromRGB(60, 60, 60)
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

runService.Heartbeat:Connect(function()
    if autoRunEnabled and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        local hum = localPlayer.Character.Humanoid
        if hum.WalkSpeed > 0 and hum.WalkSpeed ~= 138 then
            hum.WalkSpeed = 138
        end
    end
end)

