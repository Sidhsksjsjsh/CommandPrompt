local CommandPrompt = {}
local CommandPromptRequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
local HttpService = game:GetService("HttpService")
local openaiURL = "https://api.openai.com/v1/engines/davinci/completions"
local apiKey = ""
local BOT_TOKEN = ""
local CHANNEL_ID = ""
local WEBHOOK_ID = ""
-- 🙂
local function createWebhook(webhookName)
    local headers = {
        ["Authorization"] = "Bot " .. BOT_TOKEN,
        ["Content-Type"] = "application/json"
    }
    local body = HttpService:JSONEncode({
        name = webhookName
    })

    CommandPromptRequest({
        Url = "https://discord.com/api/v9/channels/" .. CHANNEL_ID .. "/webhooks",
        Method = "POST",
        Headers = headers,
        Body = body
    })
end

local function deleteWebhook()
    local headers = {
        ["Authorization"] = "Bot " .. BOT_TOKEN
    }

    CommandPromptRequest({
        Url = "https://discord.com/api/v9/webhooks/" .. WEBHOOK_ID,
        Method = "DELETE",
        Headers = headers
    })
end

local function checkBotToken()
    local headers = {
        ["Authorization"] = "Bot " .. BOT_TOKEN
    }

    local success, response = pcall(function()
        return CommandPromptRequest({
            Url = "https://discord.com/api/v9/users/@me",
            Method = "GET",
            Headers = headers
        })
    end)
    
    if success and response.StatusCode == 200 then
        return true
    end
	return false
end

local function checkChannelId()
    local headers = {
        ["Authorization"] = "Bot " .. BOT_TOKEN
    }

    local success, response = pcall(function()
        return CommandPromptRequest({
            Url = "https://discord.com/api/v9/channels/" .. CHANNEL_ID,
            Method = "GET",
            Headers = headers
        })
    end)
    
    if success and response.StatusCode == 200 then
        return true
    end
	return false
end

local function checkWebhookId()
    local headers = {
        ["Authorization"] = "Bot " .. BOT_TOKEN
    }

    local success, response = pcall(function()
        return CommandPromptRequest({
            Url = "https://discord.com/api/v9/webhooks/" .. WEBHOOK_ID,
            Method = "GET",
            Headers = headers
        })
    end)
    
    if success and response.StatusCode == 200 then
        return true
    end
	return false
end

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

    local decoded = HttpService:JSONDecode(response.Body)
	print(decoded)

    --if decoded and decoded.choices and #decoded.choices > 0 then
        return decoded.choices[#decoded.choices].text
    --else
        --return "Error: Unexpected response format"
    --end
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
cmdInput.Text = "All API: Working \nAll Bypass: Working \nAll Command: Working \n> "
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
    notifLabel.Font = Enum.Font.FredokaOne
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
    lastYPos = 1
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

local function Ascii(str)
	return string.byte(str)
end

local function Letter(str)
	return string.char(str)
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

local function Descendants(target,get)
for _,str in pairs(target:GetDescendants()) do
	get(str)
end
end

local function Children(target,get)
for _,str in pairs(target:GetChildren()) do
	get(str)
end
end

local function AddList(arg1,arg2)
	cmdInput.Text = cmdInput.Text .. "\n" .. tostring(arg1) .. "\n" .. "> " .. tostring(arg2)
end

local function AddTimer(num,replace)
for i = 1,tonumber(num) do
	replace(i)
end
end

local morseTable = {
-- capitals:
    A = ".-",
    B = "-...",
    C = "-.-.",
    D = "-..",
    E = ".",
    F = "..-.",
    G = "--.",
    H = "....",
    I = "..",
    J = ".---",
    K = "-.-",
    L = ".-..",
    M = "--",
    N = "-.",
    O = "---",
    P = ".--.",
    Q = "--.-",
    R = ".-.",
    S = "...",
    T = "-",
    U = "..-",
    V = "...-",
    W = ".--",
    X = "-..-",
    Y = "-.--",
    Z = "--..",
-- lower:
    a = ".-",
    b = "-...",
    c = "-.-.",
    d = "-..",
    e = ".",
    f = "..-.",
    g = "--.",
    h = "....",
    i = "..",
    j = ".---",
    k = "-.-",
    l = ".-..",
    m = "--",
    n = "-.",
    o = "---",
    p = ".--.",
    q = "--.-",
    r = ".-.",
    s = "...",
    t = "-",
    u = "..-",
    v = "...-",
    w = ".--",
    x = "-..-",
    y = "-.--",
    z = "--..",
-- Morse Translator:
    [".-"] = "a",
    ["-..."] = "b",
    ["-.-."] = "c",
    ["-.."] = "d",
    ["."] = "e",
    ["..-."] = "f",
    ["--."] = "g",
    ["...."] = "h",
    [".."] = "i",
    [".---"] = "j",
    ["-.-"] = "k",
    [".-.."] = "l",
    ["--"] = "m",
    ["-."] = "n",
    ["---"] = "o",
    [".--."] = "p",
    ["--.-"] = "q",
    [".-."] = "r",
    ["..."] = "s",
    ["-"] = "t",
    ["..-"] = "u",
    ["...-"] = "v",
    [".--"] = "w",
    ["-..-"] = "x",
    ["-.--"] = "y",
    ["--.."] = "z"
}

local morseTranslator = {
    [".-"] = { letter = "a", morse = ".-" },
    ["-..."] = { letter = "b", morse = "-..." },
    ["-.-."] = { letter = "c", morse = "-.-." },
    ["-.."] = { letter = "d", morse = "-.." },
    ["."] = { letter = "e", morse = "." },
    ["..-."] = { letter = "f", morse = "..-." },
    ["--."] = { letter = "g", morse = "--." },
    ["...."] = { letter = "h", morse = "...." },
    [".."] = { letter = "i", morse = ".." },
    [".---"] = { letter = "j", morse = ".---" },
    ["-.-"] = { letter = "k", morse = "-.-" },
    [".-.."] = { letter = "l", morse = ".-.." },
    ["--"] = { letter = "m", morse = "--" },
    ["-."] = { letter = "n", morse = "-." },
    ["---"] = { letter = "o", morse = "---" },
    [".--."] = { letter = "p", morse = ".--." },
    ["--.-"] = { letter = "q", morse = "--.-" },
    [".-."] = { letter = "r", morse = ".-." },
    ["..."] = { letter = "s", morse = "..." },
    ["-"] = { letter = "t", morse = "-" },
    ["..-"] = { letter = "u", morse = "..-" },
    ["...-"] = { letter = "v", morse = "...-" },
    [".--"] = { letter = "w", morse = ".--" },
    ["-..-"] = { letter = "x", morse = "-..-" },
    ["-.--"] = { letter = "y", morse = "-.--" },
    ["--.."] = { letter = "z", morse = "--.." },
    [" "] = { letter = " ", morse = " " },
}

local function translateMorseToLetters(morseText)
    local words = {}
    for word in morseText:gmatch("[^ ]+") do
        local letters = {}
        for code in word:gmatch("[.-]+") do
            table.insert(letters, morseTranslator[code].letter)
        end
        table.insert(words, table.concat(letters))
    end
    return table.concat(words, " ")
end

local function translateLettersToMorse(text)
    local words = {}
    for word in text:upper():gmatch("[^ ]+") do
        local codes = {}
        for i = 1, #word do
            local letter = word:sub(i, i)
            codes[i] = morseTranslator[letter].morse
        end
        table.insert(words, table.concat(codes, " "))
    end
    return table.concat(words, "   ")
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
	elseif command == "> my-ip" then
		cmdInput.Text = cmdInput.Text .. "\n" .. "Your IP is " .. tostring(TRACK_IP()) .. "\n" .. "> "
	elseif command == "> my-region" then
		cmdInput.Text = cmdInput.Text .. "\n" .. "Your Region/Country is " .. tostring(Region()) .. "\n" .. "> "
	elseif command:sub(1,12) == "> beta-ping " then
		shadow.Visible = command:sub(13)
		frame.Visible = command:sub(13)
	elseif command:sub(1,11) == "> set-icon " then
		if command:sub(12,16) == "fps " then
			fpsIcon.Image = "rbxassetid://" .. tonumber(command:sub(17))
		elseif command:sub(12,19) == "memory " then
			memoryIcon.Image = "rbxassetid://" .. tonumber(command:sub(20))
		elseif command:sub(12,17) == "ping " then
			pingIcon.Image = "rbxassetid://" .. tonumber(command:sub(18))
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
		cmdInput.Text = cmdInput.Text .. "\n" .. "> askgpt "
	elseif command:sub(1,9) == "> askgpt " then
		CheckError(function()
			if apiKey == "" then
				cmdInput.Text = cmdInput.Text .. "\n" .. "Required Api Key" .. "\n" .. "> api_key "
			else
		                cmdInput.Text = cmdInput.Text .. "\n" .. tostring(askGPT3(command:sub(10))) .. "\n" .. "> askgpt "
			end
		end)
	elseif command:sub(1,12) == "> bot_token " then
		if checkBotToken() then
			BOT_TOKEN = command:sub(13)
			cmdInput.Text = cmdInput.Text .. "\n" .. "Valid Bot Token!" .. "\n" .. "> "
		else
			cmdInput.Text = cmdInput.Text .. "\n" .. "Invalid Bot Token!" .. "\n" .. "> bot_token "
		end
	elseif command:sub(1,13) == "> channel_id " then
		if checkChannelId() then
			CHANNEL_ID = command:sub(14)
			cmdInput.Text = cmdInput.Text .. "\n" .. "Valid Channel Id!" .. "\n" .. "> "
		else
			cmdInput.Text = cmdInput.Text .. "\n" .. "Invalid Channel ID!" .. "\n" .. "> channel_id "
		end
	elseif command:sub(1,13) == "> webhook_id " then
		if checkWebhookId() then
			WEBHOOK_ID = command:sub(14)
			cmdInput.Text = cmdInput.Text .. "\n" .. "Valid Webhook ID!" .. "\n" .. "> "
		else
			cmdInput.Text = cmdInput.Text .. "\n" .. "Invalid Webhook ID!" .. "\n" .. "> webhook_id "
		end
	elseif command:sub(1,14) == "> add_webhook " then
		if checkBotToken() and checkChannelId() then
			createWebhook(command:sub(15))
		else
			cmdInput.Text = cmdInput.Text .. "\n" .. "Invalid Bot Token and Channel ID! \nPlease enter the token and ID correctly." .. "\n" .. "> channel_id \n> bot_token "
		end
	elseif command == "> delete_webhook " then
		deleteWebhook()
	elseif command == "> clear" then
		cmdInput.Text = "All API: Working \nAll Bypass: Working \nAll Command: Working \n> "
	elseif command:sub(1,15) == "> fake-display " then
		cmdInput.Text = cmdInput.Text .. "\n" .. command:sub(16)
	elseif command:sub(1,8) == "> click " then
		Descendants(game:GetService("Workspace"),function(str)
		if str:IsA("ClickDetector") then
			AddTimer(command:sub(9),function(getTimer)
				fireclickdetector(str)
				cmdInput.Text = cmdInput.Text .. "\n" .. "Firing All Click Detectors!" .. "\n" .. "> "
			end)
		    end
		end)
	elseif command == "> no-proximity-duration" then
		Descendants(game:GetService("Workspace"),function(str)
		if str:IsA("ProximityPrompt") then
			str.HoldDuration = 0
			AddList("Removed ProximityPrompt Timer {HoldDuration:0}","")
		    end
		end)
	elseif command:sub(1,18) == "> letter-to-ascii " then
		AddList(string.format("Letter/word: %s \nAscii code: %s",command:sub(19),Ascii(command:sub(19))))
	elseif command:sub(1,18) == "> ascii-to-letter " then
		AddList(string.format("Ascii code: %s \nLetter/word: %s",command:sub(19),Letter(command:sub(19))))
	elseif command:sub(1,18) == "> letter-to-morse " then
		AddList(string.format("Letter/word: %s \nMorse code: %s",command:sub(19),translateLettersToMorse(command:sub(19))))
	elseif command:sub(1,18) == "> morse-to-letter " then
		AddList(string.format("Morse code: %s \nLetter/word: %s",command:sub(19),translateMorseToLetters(command:sub(19))))
	else
	     cmdInput.Text = cmdInput.Text .. "\n" .. "Command Error or Invalid, Please enter the command again." .. "\n" .. "> "
        end
	cmdInputContainer.CanvasSize = UDim2.new(1,0,0,layout.AbsoluteContentSize.Y + #lines)
    end
end)

return CommandPrompt
