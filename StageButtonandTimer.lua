local button = script.Parent
local player = game.Players.LocalPlayer
local onStage = false
local stagePosition = Vector3.new(2.83, 8.884, 16.864) 
local offset = Vector3.new(0, 0, -2)
local stagePart = game.Workspace.Stage -- Replace 'Stage' with the actual part name

local function updateButton()
	if onStage then
		button.Text = "Leave Stage"
		button.BackgroundColor3 = Color3.new(1, 0, 0) -- Red background
	else
		button.Text = "Go on Stage"
		button.BackgroundColor3 = Color3.new(0, 1, 0) -- Green background
	end
end

local function leaveStage()
	onStage = false
	updateButton()
	if stagePart then
		stagePart:SetAttribute("Occupied", false)
	end
	local timerGui = script.Parent.Parent:FindFirstChild("TimerGui")
	if timerGui then
		local timerLabel = timerGui:FindFirstChild("Timer")
		if timerLabel then
			timerLabel.Visible = false
		end
	end
	if player.Character then
		player.Character:SetPrimaryPartCFrame(CFrame.new(2.184, 4.768, 52.11)) -- Replace with off-stage position
	end
end

button.MouseButton1Click:Connect(function()
	if not onStage then
		if stagePart and not stagePart:GetAttribute("Occupied") then
			player.Character:SetPrimaryPartCFrame(CFrame.new(stagePosition))
			stagePart:SetAttribute("Occupied", true)
			onStage = true
			updateButton()


			-- Start the timer UI
			local timerGui = script.Parent.Parent:FindFirstChild("TimerGui")
			if timerGui then
				local timerLabel = timerGui:FindFirstChild("Timer")
				if timerLabel then
					timerLabel.Visible = true
					local timer = 300 -- 5 minutes in seconds
					spawn(function() -- Start a new thread for the timer countdown
						while timer > 0 do
							if not onStage then break end
							timerLabel.Text = tostring(timer)
							wait(1)
							timer = timer - 1
						end
						if timer <= 0 then
							leaveStage()
						end
					end)
				end
			end
		end
	else
		leaveStage()
	end
end)
