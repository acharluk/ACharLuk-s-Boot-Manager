--[[ Variables ]]--
local version = "build 20150131.1926"
local defaultOsFolder = "os/"
local defaultConfigurationFile = "/config.abm"

-- Menu frame --
shor = "-"
sver = "|"
scor = "+"

w, h = term.getSize()

color_bg_inactive = "32768"
color_tx_inactive = "1"
color_bg_active = "1"
color_tx_active = "32768"

--[[ Tables ]]--
local OsList = fs.list(defaultOsFolder)
local OS = {
	[2] = {folder = "lellua", name = "prueba", version = "v1.2.3.4.5", boot = "main.lua"} -- This is a test menu option
}

--[[ Functions ]]--
function listOs()
	for i, os_folder in ipairs(OsList) do
		checkSuitableOs(i, os_folder)
	end
	for i = 1, #OS do
		print(i..". "..OS[i].name.."  Version: "..OS[i].version)
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
	acl.cc(tonumber(color_tx_inactive), tonumber(color_bg_inactive))
	acl.cls()
	selected = 1
	while true do
		acl.drawFrame(w,h,shor,sver,scor)
		acl.scp(9,2)
		write("ACL Boot Manager "..version)
		for i = 1, #OS do
			acl.scp(3, math.floor(h / 3 + i))
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
				acl.cls(1, 1)
				shell.run(launch)
				return
			end
		end
	end
end

--[[
	Draw menu items
	param id -> selected OS
	param text -> OS name
]]--
function menu(id, text)
	if selected == id then
		acl.cc(tonumber(color_tx_active),tonumber(color_bg_active))
		write("* ")
	else
		write("  ")
	end
	write(text)
	acl.cc(tonumber(color_tx_inactive), tonumber(color_bg_inactive))
end

--[[ Main function ]]--
function main()
	os.loadAPI("apis/acl")
	listOs()
	drawMenu()
end

local ok, err = pcall(main)
if not ok then
	print(err)
end