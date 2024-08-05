local button = script.Parent
local player = game.Players.LocalPlayer
local onStage = false
local stagePosition = Vector3.new(2.83, 8.884, 16.864) -- Replace with the actual position
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
	stagePart:SetAttribute("Occupied", false)
	script.Parent.Parent.TimerGui.Timer.Visible = false
	if player.Character then
		player.Character:SetPrimaryPartCFrame(CFrame.new(0, 0, 0)) -- Replace with off-stage position
	end
end

button.MouseButton1Click:Connect(function()
	if not onStage then
		if not stagePart:GetAttribute("Occupied") then
			player.Character:SetPrimaryPartCFrame(CFrame.new(stagePosition + offset))
			stagePart:SetAttribute("Occupied", true)
			onStage = true
			updateButton()


			-- Start the timer UI
			script.Parent.Parent.TimerGui.Timer.Visible = true
			local timer = 300 -- 5 minutes in seconds
			spawn(function() -- Start a new thread for the timer countdown
				while timer > 0 do
					if not onStage then break end
					script.Parent.Parent.TimerGui.Timer.Text = tostring(timer)
					wait(1)
					timer = timer - 1
				end
				if timer <= 0 then
					leaveStage()
				end
			end)
		end
	else
		leaveStage()
	end
end)
