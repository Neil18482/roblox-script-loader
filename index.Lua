local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("ScriptLoaderUI") then
    CoreGui.ScriptLoaderUI:Destroy()
end

local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local GLITCH_URL = "https://conscious-extreme-primula.glitch.me"
local LINKVERTISE_URL = "https://link-hub.net/1054419/pfhjcPm4gZj2"
local LOOTLABS_URL = "https://lootdest.org/s?XYP0BKme"

-- Utility: Make a frame draggable by its top bar (label or frame)
local function makeDraggable(dragFrame, mainFrame)
    local dragging, dragInput, dragStart, startPos

    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if conn then
                        conn:Disconnect()
                    end
                end
            end)
        end
    end)

    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
end

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ScriptLoaderUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 200)
frame.Position = UDim2.new(0.5, -170, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.08
frame.ClipsDescendants = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 14)

-- Title Bar
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 38)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🔐 Enter Key"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22

-- Creator credit (smaller, under title)
local creator = Instance.new("TextLabel", frame)
creator.Size = UDim2.new(1, 0, 0, 18)
creator.Position = UDim2.new(0, 0, 0, 32)
creator.Text = "Creator: Laire Shot"
creator.TextColor3 = Color3.fromRGB(180, 180, 180)
creator.BackgroundTransparency = 1
creator.Font = Enum.Font.Gotham
creator.TextSize = 13

-- Input box
local input = Instance.new("TextBox", frame)
input.Position = UDim2.new(0, 16, 0, 62)
input.Size = UDim2.new(1, -32, 0, 36)
input.PlaceholderText = "Paste Key Here"
input.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
input.TextColor3 = Color3.new(1, 1, 1)
input.TextSize = 17
input.Font = Enum.Font.Gotham
input.ClearTextOnFocus = false
input.BorderSizePixel = 0

local inputCorner = Instance.new("UICorner", input)
inputCorner.CornerRadius = UDim.new(0, 10)

-- Button Row
local getBtn = Instance.new("TextButton", frame)
getBtn.Position = UDim2.new(0, 16, 0, 116)
getBtn.Size = UDim2.new(0.5, -20, 0, 38)
getBtn.Text = "📋 Get Key"
getBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
getBtn.TextColor3 = Color3.new(1, 1, 1)
getBtn.Font = Enum.Font.Gotham
getBtn.TextSize = 16
getBtn.BorderSizePixel = 0

local getCorner = Instance.new("UICorner", getBtn)
getCorner.CornerRadius = UDim.new(0, 10)

local submitBtn = Instance.new("TextButton", frame)
submitBtn.Position = UDim2.new(0.5, 4, 0, 116)
submitBtn.Size = UDim2.new(0.5, -20, 0, 38)
submitBtn.Text = "✅ Submit"
submitBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.Font = Enum.Font.Gotham
submitBtn.TextSize = 16
submitBtn.BorderSizePixel = 0

local submitCorner = Instance.new("UICorner", submitBtn)
submitCorner.CornerRadius = UDim.new(0, 10)

-- Optional: Add a subtle shadow
local shadow = Instance.new("ImageLabel", frame)
shadow.Image = "rbxassetid://1316045217"
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Position = UDim2.new(0, -12, 0, -12)
shadow.ZIndex = 1

frame.ZIndex = 2
title.ZIndex = 3
creator.ZIndex = 3
input.ZIndex = 3
getBtn.ZIndex = 4
submitBtn.ZIndex = 4

-- Make the main GUI movable by dragging the title bar or the frame itself
makeDraggable(title, frame)
makeDraggable(frame, frame)

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

-- TextBox: Clear text and placeholder on first focus
local cleared = false
input.Focused:Connect(function()
    if not cleared then
        input.Text = ""
        input.PlaceholderText = ""
        cleared = true
    end
end)

getBtn.MouseButton1Click:Connect(function()
    -- Popup Model for Link Selection
    local popupGui = Instance.new("ScreenGui", CoreGui)
    popupGui.Name = "KeyLinkPopupUI"
    local popupFrame = Instance.new("Frame", popupGui)
    popupFrame.Size = UDim2.new(0, 320, 0, 170)
    popupFrame.Position = UDim2.new(0.5, -160, 0.5, -85)
    popupFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    popupFrame.BackgroundTransparency = 0.05
    popupFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    local popupCorner = Instance.new("UICorner", popupFrame)
    popupCorner.CornerRadius = UDim.new(0, 12)

    local popupTitle = Instance.new("TextLabel", popupFrame)
    popupTitle.Size = UDim2.new(1, 0, 0, 36)
    popupTitle.Position = UDim2.new(0, 0, 0, 8)
    popupTitle.Text = "Choose Key Provider"
    popupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    popupTitle.BackgroundTransparency = 1
    popupTitle.Font = Enum.Font.GothamBold
    popupTitle.TextSize = 20

    -- Make popup draggable by title
    makeDraggable(popupTitle, popupFrame)

    local linkvertiseBtn = Instance.new("TextButton", popupFrame)
    linkvertiseBtn.Position = UDim2.new(0, 20, 0, 55)
    linkvertiseBtn.Size = UDim2.new(0.5, -30, 0, 40)
    linkvertiseBtn.Text = "🔗 Linkvertise"
    linkvertiseBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    linkvertiseBtn.TextColor3 = Color3.new(1, 1, 1)
    linkvertiseBtn.Font = Enum.Font.Gotham
    linkvertiseBtn.TextSize = 16
    local linkvertiseCorner = Instance.new("UICorner", linkvertiseBtn)
    linkvertiseCorner.CornerRadius = UDim.new(0, 8)

    local lootlabsBtn = Instance.new("TextButton", popupFrame)
    lootlabsBtn.Position = UDim2.new(0.5, 10, 0, 55)
    lootlabsBtn.Size = UDim2.new(0.5, -30, 0, 40)
    lootlabsBtn.Text = "💎 Lootlabs"
    lootlabsBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    lootlabsBtn.TextColor3 = Color3.new(1, 1, 1)
    lootlabsBtn.Font = Enum.Font.Gotham
    lootlabsBtn.TextSize = 16
    local lootlabsCorner = Instance.new("UICorner", lootlabsBtn)
    lootlabsCorner.CornerRadius = UDim.new(0, 8)

    local closeBtn = Instance.new("TextButton", popupFrame)
    closeBtn.Position = UDim2.new(1, -36, 0, 8)
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Text = "✖"
    closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    local closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(0, 8)

    local creatorLabel = Instance.new("TextLabel", popupFrame)
    creatorLabel.Size = UDim2.new(1, 0, 0, 24)
    creatorLabel.Position = UDim2.new(0, 0, 1, -28)
    creatorLabel.Text = "Creator: Laire Shot"
    creatorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    creatorLabel.BackgroundTransparency = 1
    creatorLabel.Font = Enum.Font.Gotham
    creatorLabel.TextSize = 14

    linkvertiseBtn.MouseButton1Click:Connect(function()
        setclipboard(LINKVERTISE_URL)
        notify("🔗 Linkvertise link copied! Complete the steps to get your key.")
        popupGui:Destroy()
    end)
    lootlabsBtn.MouseButton1Click:Connect(function()
        setclipboard(LOOTLABS_URL)
        notify("💎 Lootlabs link copied! Complete the steps to get your key.")
        popupGui:Destroy()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        popupGui:Destroy()
    end)
end)

-- Make main GUI draggable by title
makeDraggable(title, frame)

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
    elseif data.status == "used" then
        notify("❌ Key Already Used")
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

        -- Make countdown draggable by label
        makeDraggable(countdownLabel, countdownFrame)

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

        -- Make script picker draggable by label
        makeDraggable(label, f)

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

