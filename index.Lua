local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("ScriptLoaderUI") then
    CoreGui.ScriptLoaderUI:Destroy()
end

local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local GLITCH_URL = "http://conscious-extreme-primula.glitch.me"
local LINKVERTISE_URL = "https://link-hub.net/1054419/pfhjcPm4gZj2"

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ScriptLoaderUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 230)
frame.Position = UDim2.new(0.5, -160, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.ClipsDescendants = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

local logo = Instance.new("ImageLabel", frame)
logo.Size = UDim2.new(0, 100, 0, 100)
logo.Position = UDim2.new(0.5, -50, 0, 5)
logo.Image = "rbxassetid://893052425"
logo.BackgroundTransparency = 1

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 110)
title.Text = "🔐 Enter Key"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local input = Instance.new("TextBox", frame)
input.Position = UDim2.new(0, 10, 0, 145)
input.Size = UDim2.new(1, -20, 0, 30)
input.PlaceholderText = "Paste Key Here"
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.TextColor3 = Color3.new(1, 1, 1)
input.TextSize = 16
input.ClearTextOnFocus = false

local inputCorner = Instance.new("UICorner", input)
inputCorner.CornerRadius = UDim.new(0, 8)

local getBtn = Instance.new("TextButton", frame)
getBtn.Position = UDim2.new(0, 10, 0, 185)
getBtn.Size = UDim2.new(0.5, -15, 0, 30)
getBtn.Text = "📋 Get Key"
getBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
getBtn.TextColor3 = Color3.new(1, 1, 1)
getBtn.Font = Enum.Font.Gotham
getBtn.TextSize = 14

local getCorner = Instance.new("UICorner", getBtn)
getCorner.CornerRadius = UDim.new(0, 8)

local submitBtn = Instance.new("TextButton", frame)
submitBtn.Position = UDim2.new(0.5, 5, 0, 185)
submitBtn.Size = UDim2.new(0.5, -15, 0, 30)
submitBtn.Text = "✅ Submit"
submitBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.Font = Enum.Font.Gotham
submitBtn.TextSize = 14

local submitCorner = Instance.new("UICorner", submitBtn)
submitCorner.CornerRadius = UDim.new(0, 8)

-- Notification
local function notify(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Key System",
            Text = msg,
            Duration = 3
        })
    end)
end

getBtn.MouseButton1Click:Connect(function()
    setclipboard(LINKVERTISE_URL)
    notify("🔗 Link copied! Complete the steps to get your key.")
end)

submitBtn.MouseButton1Click:Connect(function()
    local code = input.Text
    if code == "" then
        notify("❌ Please enter a key")
        return
    end

    notify("🔍 Checking key...")

    local isValid = false
    local expiryTimestamp = nil
    local url = GLITCH_URL .. "/check_code?code=" .. code
    print("[DEBUG] Checking URL:", url)
    local httpSuccess, httpResult = pcall(function()
        return tostring(game:HttpGet(url))
    end)

    print("[DEBUG] pcall success:", httpSuccess)
    print("[DEBUG] Raw key check result:", httpResult)

    if httpResult == nil or httpResult == "" then
        notify("❌ Your executor does not support HTTP requests to external servers.")
        return
    end

    if not httpSuccess then
        notify("❌ Failed to check key: " .. tostring(httpResult))
        return
    end

    -- Parse JSON response
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(httpResult)
    end)
    if not ok or type(data) ~= "table" then
        notify("❌ Invalid server response.")
        return
    end

    if data.status == "valid" and data.expires then
        isValid = true
        expiryTimestamp = tonumber(data.expires)
    elseif data.status == "expired" then
        notify("❌ Key Expired")
        return
    else
        notify("❌ Invalid or Expired Key")
        return
    end

    if isValid and expiryTimestamp then
        notify("✅ Valid Key")
        gui:Destroy()

        -- Countdown Model
        local countdownGui = Instance.new("ScreenGui", CoreGui)
        countdownGui.Name = "KeyCountdownUI"
        local countdownFrame = Instance.new("Frame", countdownGui)
        countdownFrame.Size = UDim2.new(0, 180, 0, 60)
        countdownFrame.Position = UDim2.new(1, -200, 0, 40)
        countdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        countdownFrame.BackgroundTransparency = 0.2
        countdownFrame.AnchorPoint = Vector2.new(0, 0)
        local countdownCorner = Instance.new("UICorner", countdownFrame)
        countdownCorner.CornerRadius = UDim.new(0, 10)
        local countdownLabel = Instance.new("TextLabel", countdownFrame)
        countdownLabel.Size = UDim2.new(1, 0, 1, 0)
        countdownLabel.BackgroundTransparency = 1
        countdownLabel.TextColor3 = Color3.new(1, 1, 1)
        countdownLabel.Font = Enum.Font.GothamBold
        countdownLabel.TextSize = 18
        countdownLabel.Text = "Key Expires In: ..."

        -- Countdown update loop
        local run = true
        task.spawn(function()
            while run do
                local now = os.time()
                local remaining = expiryTimestamp - now
                if remaining < 0 then
                    remaining = 0
                end
                local h = math.floor(remaining / 3600)
                local m = math.floor((remaining % 3600) / 60)
                local s = remaining % 60
                countdownLabel.Text = string.format("Key Expires In: %02d:%02d:%02d", h, m, s)
                if remaining <= 0 then
                    countdownLabel.Text = "Key Expired!"
                    wait(1)
                    run = false
                    pcall(function()
                        game:GetService("Players").LocalPlayer:Kick("Key expired.")
                    end)
                    if typeof(Draw) == "function" and typeof(Draw.Close) == "function" then
                        Draw:Close()
                    end
                    if typeof(os.exit) == "function" then
                        os.exit()
                    end
                end
                wait(1)
            end
        end)

        -- Script Picker
        local picker = Instance.new("ScreenGui", CoreGui)
        picker.Name = "ScriptPickerUI"
        local f = Instance.new("Frame", picker)
        f.Size = UDim2.new(0, 300, 0, 160)
        f.Position = UDim2.new(0.5, -150, 0.5, -80)
        f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        local fcorner = Instance.new("UICorner", f)
        fcorner.CornerRadius = UDim.new(0, 12)

        local label = Instance.new("TextLabel", f)
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Text = "Choose Script"
        label.TextColor3 = Color3.new(1, 1, 1)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 20

        local s1 = Instance.new("TextButton", f)
        s1.Position = UDim2.new(0, 10, 0, 50)
        s1.Size = UDim2.new(0.5, -15, 0, 40)
        s1.Text = "Script 1"
        s1.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        s1.TextColor3 = Color3.new(1, 1, 1)
        local c1 = Instance.new("UICorner", s1)
        c1.CornerRadius = UDim.new(0, 8)

        local s2 = Instance.new("TextButton", f)
        s2.Position = UDim2.new(0.5, 5, 0, 50)
        s2.Size = UDim2.new(0.5, -15, 0, 40)
        s2.Text = "Script 2"
        s2.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        s2.TextColor3 = Color3.new(1, 1, 1)
        local c2 = Instance.new("UICorner", s2)
        c2.CornerRadius = UDim.new(0, 8)

        s1.MouseButton1Click:Connect(function()
            picker:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatHub.lua"))()
        end)

        s2.MouseButton1Click:Connect(function()
            picker:Destroy()
            loadstring(game:HttpGet(
                "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
        end)
    end
end)
