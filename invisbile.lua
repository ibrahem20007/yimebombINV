local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local isHidden = false

-- Create the UI button
local gui = Instance.new("ScreenGui")
gui.Name = "InvisibilityUI"
gui.Parent = PlayerGui

local hideButton = Instance.new("TextButton")
hideButton.Name = "HideButton"
hideButton.Text = "إخفاء"
hideButton.AnchorPoint = Vector2.new(0.5, 0.5)
hideButton.Position = UDim2.new(0.25, 0, 0.5, 0)
hideButton.Size = UDim2.new(0.15, 0, 0.1, 0)
hideButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
hideButton.TextColor3 = Color3.new(1, 1, 1)
hideButton.Font = Enum.Font.SourceSansBold
hideButton.TextScaled = true
hideButton.Parent = gui

-- Function to handle hiding and unhiding
local function toggleVisibility()
    if isHidden then
        -- Return to normal
        isHidden = false
        hideButton.Text = "إخفاء"
        
        local character = LocalPlayer.Character
        local clonedCharacter = character:FindFirstChild("MyClone")
        
        if clonedCharacter then
            -- Set the original character's CFrame to the clone's position
            character:SetPrimaryPartCFrame(clonedCharacter.PrimaryPart.CFrame)
            
            -- Make original character visible
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
            
            -- Destroy the clone
            clonedCharacter:Destroy()
        end
        
    else
        -- Hide the player
        isHidden = true
        hideButton.Text = "إظهار"
        
        local character = LocalPlayer.Character
        if not character then return end
        
        -- Create a clone
        local clonedCharacter = character:Clone()
        clonedCharacter.Name = "MyClone"
        clonedCharacter.Parent = workspace
        
        -- Make the clone semi-transparent and non-collidable
        for _, part in ipairs(clonedCharacter:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.8 -- Adjust transparency as needed
                part.CanCollide = false
            end
        end
        
        -- Hide the original character and move it high up
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
            end
        end
        character:SetPrimaryPartCFrame(CFrame.new(0, 100000, 0))
    end
end

-- Update the clone's position to follow the original character's
RunService.Heartbeat:Connect(function()
    if isHidden then
        local character = LocalPlayer.Character
        local clonedCharacter = character:FindFirstChild("MyClone")
        if clonedCharacter then
            clonedCharacter:SetPrimaryPartCFrame(character:GetPrimaryPartCFrame())
        end
    end
end)

hideButton.MouseButton1Click:Connect(toggleVisibility)

-- Don't delete the button on death
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    -- This handles the case where the player respawns
    if isHidden then
        toggleVisibility()
    end
end)