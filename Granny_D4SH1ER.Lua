local Player = game:GetService("Players").LocalPlayer
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Connection

-- Hook management
local hooks = {
	shotgunAmmo = {
		active = false,
		hook = nil
	}
}

local function createItemButtons(tab, folder, filterName)
	if not folder then
		return
	end
	
	for _, item in pairs(folder:GetChildren()) do
		if item:FindFirstChild("InteractRemote") then
			tab:CreateButton({
				Name = "Get " .. item.Name,
				Callback = function()
					item.InteractRemote:FireServer(Player)
				end,
			})
		end
	end
end

-- Wait for preset to load
local function waitForPreset()
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
	return CurrentPreset
end

local function loadGui()
	if Connection then
		Connection:Disconnect()
	end
	if game:GetService("CoreGui"):FindFirstChild("Rayfield") then
		game:GetService("CoreGui").Rayfield:Destroy()
	end

	local CurrentPreset = waitForPreset()

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

	-- Main/Items Tab
	local Tab1 = Window:CreateTab("Main/Items", 4483362458)
	createItemButtons(Tab1, CurrentPreset)

	-- Ammo Tab
	local Tab2 = Window:CreateTab("Ammo", 4483362458)
	createItemButtons(Tab2, CurrentPreset:FindFirstChild("Ammo"))
	
	if game.PlaceId == 10384858885 then
		createItemButtons(Tab2, workspace:FindFirstChild("Stones"))
	end

	-- Weapons/Other Items Tab
	local Tab3 = Window:CreateTab("Weapons/Other Items", 4483362458)
	createItemButtons(Tab3, workspace:FindFirstChild("General Items"))

-- Get Shotgun button
	for _, v in pairs(CurrentPreset:GetDescendants()) do
		if v.Name == "Shotgun" and v:FindFirstChild("InteractRemote") then
			Tab3:CreateButton({
				Name = "Get Shotgun",
				Callback = function()
					v.InteractRemote:FireServer(Player)
				end,
			})
			break
		end
	end

	-- OP Stuff Tab
	local Tab4 = Window:CreateTab("OP Stuff", 4483362458)
	Tab4:CreateToggle({
		Name = "Infinite Shotgun Ammo (DO NOT EQUIP SHOTGUN WHEN TURNING ON AND TAKE 1 BULLET FIRST!)",
		CurrentValue = false,
		Flag = "InfiniteShotgunAmmo",
		Callback = function(Value)
			hooks.shotgunAmmo.active = Value
			
			if Value then
				local success, err = pcall(function()
					local sus = game:GetService("Players").LocalPlayer.Backpack:WaitForChild("ShotgunAmmo")
					hooks.shotgunAmmo.hook = hookmetamethod(game, "__index", function(self, v)
						if hooks.shotgunAmmo.active and self == sus and v == "Value" then
							return 2
						end
						return hooks.shotgunAmmo.hook(self, v)
					end)
				end)
				if not success and err then
					warn(err)
				end
			end
		end,
	})

	Connection = workspace.ChildAdded:Connect(function(child)
		if string.find(child.Name, "Preset") and child:FindFirstChild("Furnitures") then
			loadGui()
		end
	end)
end

loadGui()
