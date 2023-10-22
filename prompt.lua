local CommandPrompt = {}
local Asset = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local cmdFrame = Instance.new("Frame")
cmdFrame.Parent = screenGui
cmdFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
cmdFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
cmdFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
cmdFrame.BorderSizePixel = 0
cmdFrame.ClipsDescendants = true
cmdFrame.Visible = false

local cmdFrameCorner = Instance.new("UICorner")
cmdFrameCorner.CornerRadius = UDim.new(0.03, 0)
cmdFrameCorner.Parent = cmdFrame

local glowEffect = Instance.new("ImageLabel")
glowEffect.Parent = cmdFrame
glowEffect.Size = UDim2.new(1.1, 0, 1.1, 0)
glowEffect.Position = UDim2.new(-0.05, 0, -0.05, 0)
glowEffect.Image = "rbxassetid://3570695787" 
glowEffect.ImageColor3 = Color3.fromRGB(0, 255, 150)
glowEffect.BackgroundTransparency = 1
glowEffect.ZIndex = 0

local titleBar = Instance.new("TextLabel")
titleBar.Parent = cmdFrame
titleBar.Size = UDim2.new(1, 0, 0.05, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleBar.TextColor3 = Color3.fromRGB(0, 255, 150)
titleBar.Text = "Vortex Command Prompt V1.7.9 - By Fahri"
titleBar.Font = Enum.Font.SourceSansSemibold
titleBar.TextSize = 13

local closeButton = Instance.new("TextButton")
closeButton.Parent = titleBar
closeButton.Size = UDim2.new(0.03, 0, 1, 0)
closeButton.Position = UDim2.new(0.97, 0, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(192, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.BorderSizePixel = 0

closeButton.MouseButton1Click:Connect(function()
    cmdFrame.Visible = false
end)

local cmdInputContainer = Instance.new("ScrollingFrame")
cmdInputContainer.Parent = cmdFrame
cmdInputContainer.Size = UDim2.new(1, -10, 0.9, -titleBar.Size.Y.Offset)
cmdInputContainer.Position = UDim2.new(0, 5, 0.05, 5)
cmdInputContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
cmdInputContainer.BorderSizePixel = 0
cmdInputContainer.CanvasSize = UDim2.new(1, 0, 0, 0)
cmdInputContainer.ScrollBarThickness = 5

local cmdInputCorner = Instance.new("UICorner")
cmdInputCorner.CornerRadius = UDim.new(0.03, 0)
cmdInputCorner.Parent = cmdInputContainer

local layout = Instance.new("UIListLayout")
layout.Parent = cmdInputContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

local cmdInput = Instance.new("TextBox")
cmdInput.Parent = cmdInputContainer
cmdInput.Size = UDim2.new(1, 0, 0, 100)
cmdInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
cmdInput.TextColor3 = Color3.fromRGB(0, 255, 150)
cmdInput.TextXAlignment = Enum.TextXAlignment.Left
cmdInput.TextYAlignment = Enum.TextYAlignment.Top
cmdInput.MultiLine = true
cmdInput.ClearTextOnFocus = false
cmdInput.Font = Enum.Font.Code
cmdInput.PlaceholderColor3 = Color3.fromRGB(60, 60, 60)
cmdInput.Text = "> "
cmdInput.BorderSizePixel = 0
cmdInput.TextSize = 13

local cmdInputCorner = Instance.new("UICorner")
cmdInputCorner.CornerRadius = UDim.new(0.03, 0)
cmdInputCorner.Parent = cmdInput

local TweenService = game:GetService("TweenService")

local lastYPos = 1

local function Prompt(message)
    local screenGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Prompt A1")
    
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Prompt A1"
        screenGui.Parent = game.Players.LocalPlayer.PlayerGui
    end

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0.5, 0, 0, 30)
    notifFrame.Position = UDim2.new(0.4, 0, lastYPos, 0)
    notifFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    notifFrame.BorderColor3 = Color3.new(0, 1, 0)
    notifFrame.Parent = screenGui

    local notifLabel = Instance.new("TextLabel")
    notifLabel.Text = message
    notifLabel.Size = UDim2.new(1, 0, 1, 0)
    notifLabel.BackgroundTransparency = 1
    notifLabel.TextColor3 = Color3.new(1, 1, 1)
    notifLabel.Font = Enum.Font.SourceSansBold
    notifLabel.TextScaled = true
    notifLabel.Parent = notifFrame
    
    local textSize = notifLabel.TextBounds.Y
    local newHeight = math.max(notifFrame.Size.Y.Offset, textSize + 10)
    notifFrame.Size = UDim2.new(0.4, 0, 0, newHeight)
    
    lastYPos = lastYPos - notifFrame.Size.Y.Scale - 0.1
    
    local endPos = UDim2.new(0.3, 0, lastYPos, 5)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tweenGoal = {}
    tweenGoal.Position = endPos
    
    local tween = TweenService:Create(notifFrame, tweenInfo, tweenGoal)
    tween:Play()

    task.wait(4)

    local fadeInfo = TweenInfo.new(1)
    local fadeGoal = {}
    fadeGoal.BackgroundTransparency = 1
    fadeGoal.TextTransparency = 1
    local fadeTween = TweenService:Create(notifLabel, fadeInfo, fadeGoal)
    fadeTween:Play()

    fadeTween.Completed:Wait()
    notifFrame:Destroy()
end

-- Prompt("Test")

function CommandPrompt:AddPrompt(str)
	Prompt(str)
end

local function CheckError(str)
local index,error = pcall(function()
	str()
end)

if not index then
	cmdInput.Text = cmdInput.Text .. "\n" .. error .. "\n" .. "> "
end
end

function CommandPrompt:Show()
  cmdFrame.Visible = true
end

function CommandPrompt:RequestLine(str)
    cmdInput.Text = cmdInput.Text .. "\n" .. str .. "\n" .. "> "
end

function CommandPrompt:AddCommand(name,func)
cmdInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local lines = cmdInput.Text:split("\n")
        local command = lines[#lines]
        if command == name then
	CheckError(function()
          func()
	end)
          end
    end
end)
end

function CommandPrompt:AddArgCommand(name,func)
cmdInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local lines = cmdInput.Text:split("\n")
        local command = lines[#lines]
        if command:sub(1,#name) == name then
          func()
          end
    end
end)
end

cmdInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local lines = cmdInput.Text:split("\n")
        local command = lines[#lines]
        if command == "> exit" then
            cmdFrame.Visible = false
	    cmdInput.Text = cmdInput.Text .. "\n" .. "> "
	elseif command:sub(1,11) == "> run-http " then
	    CheckError(function()
		loadstring(game:HttpGet(command:sub(12)))()
		cmdInput.Text = cmdInput.Text .. "\n" .. "Executed!" .. "\n" .. "> "
	   end)
	elseif command == "> get-game-id" then
		cmdInput.Text = cmdInput.Text .. "\n" .. "game ID: " .. tostring(game.PlaceId) .. "\n" .. "> "
	elseif command == "> get-game-job-id" then
		cmdInput.Text = cmdInput.Text .. "\n" .. "game/server Job ID: " .. tostring(game.JobId) .. "\n" .. "> "
	elseif command == "> get-game-name" then
		cmdInput.Text = cmdInput.Text .. "\n" .. "game name: " .. tostring(Asset.Name) .. "\n" .. "> "
	elseif command:sub(1,22) == "> change-textbox-size " then
	    CheckError(function()
		cmdInput.TextSize = tonumber(command:sub(23))
		cmdInput.Text = cmdInput.Text .. "\n" .. "Texbox Text size successfully changed!" .. "\n" .. "> "
	   end)
	elseif command:sub(1,20) == "> change-title-size " then
	    CheckError(function()
		titleBar.TextSize = tonumber(command:sub(21))
		cmdInput.Text = cmdInput.Text .. "\n" .. "Title Text size successfully changed!" .. "\n" .. "> "
	   end)
	elseif command == "> reload-plugin-in-lib" then -- fake 😫😂
		cmdInput.Text = cmdInput.Text .. "\n" .. "UI and Plugin Library is broken! (Press CTRL + F5 on your keyboard to fix it)" .. "\n" .. "> "
	elseif command == "> virus.exe" then -- fake too 😫😂
		cmdInput.Text = cmdInput.Text .. "\n" .. "Unable to send the virus to the server because the Database is \nexperiencing fatal damage." .. "\n" .. "> "
	else
	     cmdInput.Text = cmdInput.Text .. "\n" .. "Command Error or Invalid, Please enter the command again." .. "\n" .. "> "
        end

	cmdInputContainer.CanvasSize = UDim2.new(1,0,0,layout.AbsoluteContentSize.Y)
    end
end)

return CommandPrompt
