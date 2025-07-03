local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("ScriptLoaderUI") then
    CoreGui.ScriptLoaderUI:Destroy()
end

local GLITCH_URL = "https://noiseless-extreme-thief.glitch.me"
local LINKVERTISE_URL = "https://link-hub.net/1054419/pfhjcPm4gZj2"

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ScriptLoaderUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 220) -- increased height for logo
frame.Position = UDim2.new(0.5, -150, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

-- 🔴 Logo Image
local logo = Instance.new("ImageLabel", frame)
logo.Size = UDim2.new(0, 100, 0, 100)
logo.Position = UDim2.new(0.5, -50, 0, 5)
logo.Image = "rbxassetid://893052425"
logo.BackgroundTransparency = 1

-- 🏷️ Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 110)
title.Text = "Enter Access Code"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- 🧾 Input
local input = Instance.new("", frame)
input.Position = UDim2.new(0, 10, 0, 145)
input.Size = UDim2.new(1, -20, 0, 30)
input.PlaceholderText = "Paste Code Here"
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.TextColor3 = Color3.new(1, 1, 1)
input.TextSize = 16
input.ClearTextOnFocus = false

-- 🔗 Get Code Button
local getBtn = Instance.new("TextButton", frame)
getBtn.Position = UDim2.new(0, 10, 0, 180)
getBtn.Size = UDim2.new(0.5, -15, 0, 30)
getBtn.Text = "Get Code"
getBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
getBtn.TextColor3 = Color3.new(1, 1, 1)

getBtn.MouseButton1Click:Connect(function()
    setclipboard(LINKVERTISE_URL)
end)

-- ✅ Submit Button
local submitBtn = Instance.new("TextButton", frame)
submitBtn.Position = UDim2.new(0.5, 5, 0, 180)
submitBtn.Size = UDim2.new(0.5, -15, 0, 30)
submitBtn.Text = "Submit Code"
submitBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
submitBtn.TextColor3 = Color3.new(1, 1, 1)

submitBtn.MouseButton1Click:Connect(function()
    local code = input.Text
    if code == "" then
        return
    end

    local isValid = false
    pcall(function()
        local result = game:HttpGet(GLITCH_URL .. "/check_code?code=" .. code)
        if result == "valid" then
            isValid = true
        end
    end)

    if isValid then
        gui:Destroy()

        -- Script Picker UI
        local picker = Instance.new("ScreenGui", CoreGui)
        picker.Name = "ScriptPickerUI"
        local f = Instance.new("Frame", picker)
        f.Size = UDim2.new(0, 300, 0, 160)
        f.Position = UDim2.new(0.5, -150, 0.5, -80)
        f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

        local label = Instance.new("TextLabel", f)
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Text = "Choose Script"
        label.TextColor3 = Color3.new(1, 1, 1)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 20

        local s1 = Instance.new("TextButton", f)
        s1.Position = UDim2.new(0, 10, 0, 50)
        s1.Size = UDim2.new(0.5, -15, 0, 40)
        s1.Text = "Script 1"
        s1.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        s1.TextColor3 = Color3.new(1, 1, 1)

        local s2 = Instance.new("TextButton", f)
        s2.Position = UDim2.new(0.5, 5, 0, 50)
        s2.Size = UDim2.new(0.5, -15, 0, 40)
        s2.Text = "Script 2"
        s2.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        s2.TextColor3 = Color3.new(1, 1, 1)

        s1.MouseButton1Click:Connect(function()
            picker:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatHub.lua"))()
        end)

        s2.MouseButton1Click:Connect(function()
            picker:Destroy()
            loadstring(game:HttpGet(
                "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
        end)
    else
        submitBtn.Text = "Invalid!"
        wait(1.5)
        submitBtn.Text = "Submit Code"
    end
end)
