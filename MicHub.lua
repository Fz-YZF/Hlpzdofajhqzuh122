-- FUNCTIONS --
local function findplr(name)
	for _, plr in pairs(game.Players:GetPlayers()) do
		if string.find(plr.Name:lower(), name:lower()) then
			return plr
		end
	end
	return nil
end

local function setupProximityPrompt(stall)
	local ProximityPrompt = stall:FindFirstChild("Activate"):FindFirstChildOfClass("ProximityPrompt")
	if ProximityPrompt then
		ProximityPrompt.Enabled = true
		ProximityPrompt.ClickablePrompt = true
		ProximityPrompt.MaxActivationDistance = 15
		ProximityPrompt.RequiresLineOfSight = false
		ProximityPrompt.HoldDuration = 0
	end
end

local function getPlayerBooth(player)
	for _, booth in ipairs(game:GetService("Workspace").Booth:GetChildren()) do
		local username = booth:FindFirstChild("Username")
		if username and username:FindFirstChild("BillboardGui").TextLabel.Text == "Owned by: " .. player.Name then
			return booth
		end
	end
	return nil
end

local function unclaimBooth(victim)
	if victim == "" then return end
	local targetPlayer = findplr(victim)
	if not targetPlayer then return end
	local playerBooth = getPlayerBooth(targetPlayer)
	if not playerBooth then return end
	setupProximityPrompt(playerBooth)
	local localPlayer = game.Players.LocalPlayer
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local originalCFrame = humanoidRootPart.CFrame
	humanoidRootPart.CFrame = playerBooth:GetPivot()
	task.wait(0.3)
	local proximityPrompt = playerBooth:FindFirstChild("Activate"):FindFirstChildOfClass("ProximityPrompt")
	if proximityPrompt then
		fireproximityprompt(proximityPrompt)
	end
	task.wait(0.2)
	game:GetService("ReplicatedStorage"):WaitForChild("DeleteBoothOwnership"):FireServer()
	humanoidRootPart.CFrame = originalCFrame
end

-- LOCALS --
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fz-YZF/El-patron-UI-lib/refs/heads/main/Module.lua"))()
local plr = game.Players.LocalPlayer
local RunServiceStepped = game:GetService("RunService").Stepped
local RagdollEvent = workspace.Parent:GetService("ReplicatedStorage").RagdollEvent
local UnRagdollEvent = workspace.Parent:GetService("ReplicatedStorage").UnragdollEvent
local BathSeat = workspace.Parent:GetService("Workspace").TheRoom.Room.HotTub:WaitForChild("Seat")

-- LOAD -- 
local BaseplateVariable
if game.workspace:FindFirstChild("Game") then
	BaseplateVariable = game.workspace.Game.Baseplate
elseif game.workspace:FindFirstChild("SoccerField") then
	BaseplateVariable = game.workspace.SoccerField.Baseplate
else
	BaseplateVariable = game.workspace.Baseplate
end
BaseplateVariable.Size = Vector3.new(600, 16, 600)

-- MAIN
local UI = Material.Load({
	Title = "MicHub.FZ_YZF",
	Style = 3,
	SizeX = 180,
	SizeY = 255,
	Theme = "Dark",
})

local main = UI.New({
	Title = "Functions"
})

main.TextField({
	Text = "steal stand (plr)",
	Callback = function(playerName)
		unclaimBooth(playerName)
	end
})

main.Toggle({
	Text = "Invisible",
	Callback = function(Value)
		if Value == true then
			RagdollEvent:FireServer()
			plr.Character.HumanoidRootPart.CFrame = BathSeat.CFrame
		elseif Value == false then
			UnRagdollEvent:FireServer()
		end
	end
})

main.Button({
	Text = "Lower Baseplate",
	Callback = function()
		BaseplateVariable.CFrame = CFrame.new(BaseplateVariable.CFrame.Position.X,-20,BaseplateVariable.CFrame.Position.Z)
	end
})

main.Button({
	Text = "Normal Baseplate",
	Callback = function()
		for i = -16, -8, 0.01 do
			BaseplateVariable.CFrame = CFrame.new(BaseplateVariable.CFrame.Position.X,i,BaseplateVariable.CFrame.Position.Z)
			RunServiceStepped:wait()
		end

	end
})

main.Button({
	Text = "FE Jerk Off",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
	end
})

main.Button({
	Text = "FE Flip",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Fz-YZF/FE-Flip/refs/heads/main/FEFlip.lua"))()
	end
})

main.Button({
	Text = "FE Troll GUI",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/38Jra00x"))()
	end
})

local notifSound = Instance.new("Sound",workspace)
notifSound.PlaybackSpeed = 1.5
notifSound.Volume = 0.15
notifSound.SoundId = "rbxassetid://170765130"
notifSound.PlayOnRemove = true
notifSound:Destroy()
game.StarterGui:SetCore("SendNotification", {Title = "MicHub", Text = "MicHub loaded successfully!", Icon = "rbxassetid://505845268", Duration = 5, Button1 = "Okay"})