local Player = game:GetService("Players").LocalPlayer
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Connection

local function loadGui()
	if Connection then
		Connection:Disconnect()
	end
	if game:GetService("CoreGui"):FindFirstChild("Rayfield") then
		game:GetService("CoreGui").Rayfield:Destroy()
	end

	local CurrentPreset
	repeat
		for _, v in pairs(workspace:GetChildren()) do
			if v:FindFirstChild("Furnitures") then
				CurrentPreset = v
				break
			end
		end
		task.wait()
	until CurrentPreset ~= nil

	local Window = Rayfield:CreateWindow({
		Name = "ZLN HUB | Granny: Multiplayer",
		LoadingTitle = "ZLN HUB running!...",
		LoadingSubtitle = "Welcome " .. Player.DisplayName,
		ConfigurationSaving = {
			Enabled = true,
			FolderName = "ZLN_Hub",
			FileName = "GrannyMP"
		},
		KeySystem = false,
		ToggleUIKeybind = "K"
	})

	local Tab1 = Window:CreateTab("Main/Items", 4483362458)
	for _, v in pairs(CurrentPreset:GetChildren()) do
		if v:FindFirstChild("InteractRemote") then
			Tab1:CreateButton({
				Name = "Get " .. v.Name,
				Callback = function()
					v.InteractRemote:FireServer(Player)
				end,
			})
		end
	end

	local Tab2 = Window:CreateTab("Ammo", 4483362458)
	local ammoFolder = CurrentPreset:FindFirstChild("Ammo")
	if ammoFolder then
		for _, v in pairs(ammoFolder:GetChildren()) do
			if v:FindFirstChild("InteractRemote") then
				Tab2:CreateButton({
					Name = "Get " .. v.Name,
					Callback = function()
						v.InteractRemote:FireServer(Player)
					end,
				})
			end
		end
	end
	if game.PlaceId == 10384858885 then
		local stonesFolder = workspace:FindFirstChild("Stones")
		for _, v in pairs(stones:GetChildren()) do
			if v:FindFirstChild("InteractRemote") then
				Tab2:CreateButton({
					Name = "Get " .. v.Name,
					Callback = function()
						v.InteractRemote:FireServer(Player)
					end,
				})
			end
		end
	end

	local Tab3 = Window:CreateTab("Weapons/Other Items", 4483362458)
	local generalItems = workspace:FindFirstChild("General Items")
	if generalItems then
		for _, v in pairs(generalItems:GetChildren()) do
			if v:FindFirstChild("InteractRemote") then
				Tab3:CreateButton({
					Name = "Get " .. v.Name,
					Callback = function()
						v.InteractRemote:FireServer(Player)
					end,
				})
			end
		end
	end

	Connection = workspace.ChildAdded:Connect(function(child)
		if string.find(child.Name, "Preset") and child:FindFirstChild("Furnitures") then
			loadGui()
		end
	end)
end

loadGui()
