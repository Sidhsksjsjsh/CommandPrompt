local CommandPrompt = {}
local CommandPromptRequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
local HttpService = game:GetService("HttpService")

local openaiURL = "https://api.openai.com/v1/engines/davinci/completions"
local apiKey = ""

local function askGPT3(prompt)
    local headers = {
        ["Authorization"] = "Bearer " .. apiKey,
        ["content-type"] = "application/json"
    }
    
    local data = {
        prompt = prompt,
        max_tokens = 50
    }

    local response = CommandPromptRequest({
        Url = openaiURL,
        Method = "POST",
        Headers = headers,
        Body = HttpService:JSONEncode(data)
    })

    if response.StatusCode == 200 then
        local decoded = HttpService:JSONDecode(response.Body)
        return decoded.choices[1].text
    else
        return "Error: " .. response.StatusCode
    end
end

local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local shadow = Instance.new("Frame")

local pingIcon = Instance.new("ImageLabel")
local pingLabel = Instance.new("TextLabel")
local memoryIcon = Instance.new("ImageLabel")
local memoryLabel = Instance.new("TextLabel")
local fpsIcon = Instance.new("ImageLabel")
local fpsLabel = Instance.new("TextLabel")
local separator1 = Instance.new("Frame")
local separator2 = Instance.new("Frame")

screenGui.Parent = player.PlayerGui

shadow.Size = UDim2.new(0, 455, 0, 65)
shadow.Position = UDim2.new(0.5, -228, 0.102, 2)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.ZIndex = 0
shadow.Parent = screenGui
shadow.Visible = false

frame.Size = UDim2.new(0, 450, 0, 60)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0.5, -225, 0.1, 0)
frame.ZIndex = 1
frame.Parent = screenGui
frame.Visible = false

pingIcon.Size = UDim2.new(0, 40, 0, 40)
pingIcon.Position = UDim2.new(0, 10, 0.5, -20)
pingIcon.Image = "rbxassetid://YOUR_PING_ICON_ID"
pingIcon.Parent = frame
pingIcon.BackgroundTransparency = 1

pingLabel.Position = UDim2.new(0, 60, 0.1, -10)
pingLabel.Size = UDim2.new(0.3, -70, 1, 0)
pingLabel.Font = Enum.Font.Roboto
pingLabel.TextSize = 18
pingLabel.TextColor3 = Color3.new(1, 1, 1)
pingLabel.Text = "Ping: -- ms"
pingLabel.Parent = frame
pingLabel.BackgroundTransparency = 1

memoryIcon.Size = UDim2.new(0, 40, 0, 40)
memoryIcon.Position = UDim2.new(0.33, 10, 0.5, -20)
memoryIcon.Image = "rbxassetid://YOUR_MEMORY_ICON_ID"
memoryIcon.Parent = frame
memoryIcon.BackgroundTransparency = 1

memoryLabel.Position = UDim2.new(0.33, 60, 0.1, -10)
memoryLabel.Size = UDim2.new(0.3, -70, 1, 0)
memoryLabel.Font = Enum.Font.Roboto
memoryLabel.TextSize = 18
memoryLabel.TextColor3 = Color3.new(1, 1, 1)
memoryLabel.Text = "Memory: -- MB"
memoryLabel.Parent = frame
memoryLabel.BackgroundTransparency = 1

fpsIcon.Size = UDim2.new(0, 40, 0, 40)
fpsIcon.Position = UDim2.new(0.66, 10, 0.5, -20)
fpsIcon.Image = "rbxassetid://YOUR_FPS_ICON_ID"
fpsIcon.Parent = frame
fpsIcon.BackgroundTransparency = 1

fpsLabel.Position = UDim2.new(0.66, 60, 0.1, -10)
fpsLabel.Size = UDim2.new(0.3, -70, 1, 0)
fpsLabel.Font = Enum.Font.Roboto
fpsLabel.TextSize = 18
fpsLabel.TextColor3 = Color3.new(1, 1, 1)
fpsLabel.Text = "FPS: --"
fpsLabel.Parent = frame
fpsLabel.BackgroundTransparency = 1

separator1.Size = UDim2.new(0, 2, 0.7, 0)
separator1.Position = UDim2.new(0.33, -1, 0.15, 0)
separator1.BackgroundColor3 = Color3.new(1, 1, 1)
separator1.ZIndex = 2
separator1.Parent = frame

separator2.Size = UDim2.new(0, 2, 0.7, 0)
separator2.Position = UDim2.new(0.66, -1, 0.15, 0)
separator2.BackgroundColor3 = Color3.new(1, 1, 1)
separator2.ZIndex = 2
separator2.Parent = frame

--[[ END
local fadeInTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local fadeInGoals = {BackgroundTransparency = 0.4}
local fadeInTween = tweenService:Create(frame, fadeInTweenInfo, fadeInGoals)
fadeInTween:Play()
]]
local Asset = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
--local screenGui = Instance.new("ScreenGui")
--screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

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
cmdInput.Text = "API: Working \nAll Bypass: Working \nAll Command: Working \n> "
cmdInput.BorderSizePixel = 0
cmdInput.TextSize = 13

local cmdInputCorner = Instance.new("UICorner")
cmdInputCorner.CornerRadius = UDim.new(0.03, 0)
cmdInputCorner.Parent = cmdInput

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

local function TRACK_IP()
local LOCAL_WEB = tostring(game:HttpGet("https://api.ipify.org",true))
     return LOCAL_WEB
end

local function Region()
  local Thing = game:GetService("HttpService"):JSONDecode(game:HttpGet("http://country.io/names.json"))
  local ParsedCountry = Thing[gethiddenproperty(game.Players.LocalPlayer,"CountryRegionCodeReplicate")]
    return ParsedCountry
end


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

function CommandPrompt:Enabled()
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

local function SendMessage(url,message)
CheckError(function()
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = message
    }
    local body = http:JSONEncode(data)
    local response = CommandPromptRequest({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
    Prompt("Sent")
end)
end

local function SendMessageEMBED(url,embed)
CheckError(function()
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["embeds"] = {
            {
                ["title"] = embed.title,
                ["description"] = embed.description,
                ["color"] = embed.color,
                ["fields"] = embed.fields,
                ["footer"] = {
                    ["text"] = embed.footer.text
                }
            }
        }
    }
    local body = http:JSONEncode(data)
    local response = CommandPromptRequest({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
    Prompt("Sent")
end)
end


--Examples 

local url = ""


local embed = {
    ["title"] = "This is an embedded message",
    ["description"] = "This message has an embed with fields and a footer",
    ["color"] = 65280,
    ["fields"] = {
        {
            ["name"] = "Field 1",
            ["value"] = "This is the first field"
        },
        {
            ["name"] = "Field 2",
            ["value"] = "This is the second field"
        }
    },
    ["footer"] = {
        ["text"] = "This is the footer text"
    }
}
-- SendMessageEMBED(url, embed)

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
	elseif command == "> my-ip" then
		cmdInput.Text = cmdInput.Text .. "\n" .. "Your IP is " .. tostring(TRACK_IP()) .. "\n" .. "> "
	elseif command == "> my-region" then
		cmdInput.Text = cmdInput.Text .. "\n" .. "Your Region/Country is " .. tostring(Region()) .. "\n" .. "> "
	elseif command:sub(1,12) == "> beta-ping " then
		shadow.Visible = command:sub(13)
		frame.Visible = command:sub(13)
	elseif command:sub(1,11) == "> set-icon " then
		if command:sub(12) == "fps" then
			fpsIcon.Image = "rbxassetid://" .. tonumber(command:sub(16))
		elseif command:sub(12) == "memory" then
			memoryIcon.Image = "rbxassetid://" .. tonumber(command:sub(19))
		elseif command:sub(12) == "ping" then
			pingIcon.Image = "rbxassetid://" .. tonumber(command:sub(17))
		else
			cmdInput.Text = cmdInput.Text .. "\n" .. "you have to fill in the second and third arguments\nexample: second argument: ping / memory / fps \nexample third argument: id of the image" .. "\n" .. "> "
		end
	elseif command:sub(1,10) == "> webhook " then
		url = command:sub(11)
	elseif command:sub(1,11) == "> send-msg " then
		if not url == "" then
		   SendMessage(url,command:sub(12))
		elseif url == "" then
		   cmdInput.Text = cmdInput.Text .. "\n" .. "cannot find webhook \nplease fill in the webhook\nby writing 'webhook [url]'" .. "\n" .. "> webhook "
		end
	elseif command:sub(1,10) == "> api_key " then
		apiKey = command:sub(11)
	elseif command:sub(1,9) == "> askgpt " then
		CheckError(function()
			if apiKey == "" then
				cmdInput.Text = cmdInput.Text .. "\n" .. "Required Api Key" .. "\n" .. "> api_key "
			else
		                cmdInput.Text = cmdInput.Text .. "\n" .. tostring(askGPT3(command:sub(10))) .. "\n" .. "> askgpt "
			end
		end)
	else
	     cmdInput.Text = cmdInput.Text .. "\n" .. "Command Error or Invalid, Please enter the command again." .. "\n" .. "> "
        end
	cmdInputContainer.CanvasSize = UDim2.new(1,0,0,layout.AbsoluteContentSize.Y + #lines)
    end
end)

return CommandPrompt
