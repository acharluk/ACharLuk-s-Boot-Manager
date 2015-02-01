--[[ Variables ]]--
local version = "build 20150131.1926"
local defaultOsFolder = "os/"
local defaultConfigurationFile = "/config.abm"

--[[ Menu frame ]]--
shor = "-"
sver = "|"
scor = "+"
w, h = term.getSize()
color_bg_inactive = "1"
color_tx_inactive = "32768"
color_bg_active = "32768"
color_tx_active = "1"

--[[ Tables ]]--
local OsList = fs.list(defaultOsFolder)
local OS = {
	[2] = {folder="lellua",name = "prueba", version = "v1.2.3.4.5", boot = "launch.lua"} -- This is a test menu option
}

--[[ Functions ]]--
function listOs()
	for i, os_folder in ipairs(OsList) do
		checkSuitableOs(i, os_folder)
	end
	for i = 1, #OS do
		print(i..". "..OS[i].name.."  Version: "..OS[i].version.."  Main file: "..OS[i].boot)
	end
end

function checkSuitableOs(index, os_folder)
	file = defaultOsFolder..os_folder..defaultConfigurationFile
	if fs.exists(file) then
		f = fs.open(file, "r")
		OS[index] = {folder = defaultOsFolder..os_folder, name = string.sub(f.readLine(), 6), version = string.sub(f.readLine(), 9), boot = string.sub(f.readLine(), 6)}
		f.close()
	end
end

--[[
	Draw main menu
]]--
function drawMenu()
	term.setBackgroundColor(tonumber(color_bg_inactive))
	term.setTextColor(tonumber(color_tx_inactive))
	term.clear()
	selected = 1
	while true do
		drawFrame()
		for i = 1, #OS do
			term.setCursorPos(3, math.floor(h / 3 + i))
			menu(i, OS[i].name.." - version: "..OS[i].version)
		end

		ev, k = os.pullEvent()
		if ev == "key" then

			if k == keys.up and selected > 1 then
				selected = selected - 1
			elseif k == keys.down and selected < #OS then
				selected = selected + 1
			elseif k == keys.enter then
				launch = OS[selected].folder.."/"..OS[selected].boot
				print()
				print("Launching: "..launch)
				shell.run(launch)
				return
			end
		end
	end
end

--[[
	Draw screen frame and title
]]--
function drawFrame()
	for i = 2, w - 1 do
		term.setCursorPos(i, 4)
		write(shor)
		term.setCursorPos(i, h - 4)
		write(shor)
	end
	for i = 4, h - 4 do
		term.setCursorPos(1, i)
		write(sver)
		term.setCursorPos(w, i)
		write(sver)
	end
	
	term.setCursorPos(1,4) write(scor)
	term.setCursorPos(1,h - 4) write(scor)
	term.setCursorPos(w,h - 4) write(scor)
	term.setCursorPos(w,4) write(scor)

	title = "ACL Boot Manager "..version
	term.setCursorPos(9,2)
	write(title)
end

--[[
	Draw menu items
	param id -> selected OS
	param text -> OS name
]]--
function menu(id, text)
	if selected == id then
		term.setBackgroundColor(tonumber(color_bg_active))
		term.setTextColor(tonumber(color_tx_active))
		write("* ")
	else
		write("  ")
	end
	write(text)
	term.setBackgroundColor(tonumber(color_bg_inactive))
	term.setTextColor(tonumber(color_tx_inactive))
end

--[[ Main function ]]--
function main()
	--[[
	term.clear()
	term.setCursorPos(1,1)
	print("ACL Boot Manager "..version)
	print()
	listOs()
	print()
	term.write("Select OS: ")
	selection = tonumber(read())
	launch = OS[selection].folder.."/"..OS[selection].boot
	print("Launching: "..launch)
	shell.run(launch)
	]]--
	listOs()
	drawMenu()
end

local ok, err = pcall(main)
if not ok then
	print(err)
end