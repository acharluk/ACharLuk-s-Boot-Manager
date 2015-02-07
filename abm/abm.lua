--[[ Variables ]]--
local version = "build 20150201.1706"
local defaultOsFolder = "os/"
local defaultConfigurationFile = "/config.abm"

-- Menu frame --
local shor = "-"
local sver = "|"
local scor = "+"

local w, h = term.getSize()

local color_bg_inactive = "32768"
local color_tx_inactive = "1"
local color_bg_active = "1"
local color_tx_active = "32768"

--[[ Tables ]]--
local OsList = fs.list(defaultOsFolder)
local OS = {}

--[[ Functions ]]--
function listOs()
	OS = {}
	for i, os_folder in ipairs(OsList) do
		checkSuitableOs(i, os_folder)
	end
end

function checkSuitableOs(index, os_folder)
	file = defaultOsFolder..os_folder..defaultConfigurationFile
	if fs.exists(file) then
		f = fs.open(file, "r")
		OS[index] = {
			folder = defaultOsFolder..os_folder,
			name = string.sub(f.readLine(), 6),
			version = string.sub(f.readLine(), 9),
			boot = string.sub(f.readLine(), 6)
		}
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
				acl.cls(1, 1)
				shell.run(launch)
				return
			elseif k == keys.r then
				acl.cls()
				listOs()
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