--[[ Variables ]]--
local ABMConfigFile = "configuration.cfg"

-- Menu frame --
local shor = "-"
local sver = "|"
local scor = "+"

local w, h = 0, 0

--[[ Tables ]]--
local conf = {}
local OsList = {}
local OS = {}

--[[ Functions ]]--

--[[
	Spit string at a regex
	param string -> input string
	param reg -> regex
]]--
function splitstr(string, reg)
        if reg == nil then
                reg = "%s"
        end
        t = {}
        i = 1
        for str in string.gmatch(string, "([^"..reg.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end
function loadConfiguration() 
	f = fs.open("abm/"..ABMConfigFile, "r")
	--i = 1
	while true do
		line = f.readLine()
		if line == nil then break end
		split = splitstr(line, "=")
		conf[split[1]] = split[2]
	end
	f.close()
end
function listOs()
	OS = {}
	for i, os_folder in ipairs(OsList) do
		checkSuitableOs(i, os_folder)
	end
end

function checkSuitableOs(index, os_folder)
	file = conf["default_os_folder"]..os_folder..conf["default_conf_file"]
	if fs.exists(file) then
		f = fs.open(file, "r")
		OS[index] = {
			folder = conf["default_os_folder"]..os_folder,
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
	acl.cc(tonumber(conf["color_tx_inactive"]), tonumber(conf["color_bg_inactive"]))
	acl.cls()
	selected = 1
	while true do
		acl.drawFrame(w,h,shor,sver,scor)
		acl.scp(9,2)
		write("ACL Boot Manager "..conf["version"])
		for i = 1, #OS do
			acl.scp(3, math.floor(h / 3 + i))
			menu(i, OS[i].name.." - version: "..OS[i].version)
		end
		_, k = os.pullEvent("key")
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

--[[
	Draw menu items
	param id -> selected OS
	param text -> OS name
]]--
function menu(id, text)
	if selected == id then
		acl.cc(tonumber(conf["color_tx_active"]), tonumber(conf["color_bg_active"]))
		write("* ")
	else
		write("  ")
	end
	write(text)
	acl.cc(tonumber(conf["color_tx_inactive"]), tonumber(conf["color_bg_inactive"]))
end

--[[ Main function ]]--
function main()
	os.loadAPI("apis/acl")
	w, h = acl.size()
	loadConfiguration()
	OsList = fs.list(conf["default_os_folder"])
	listOs()
	drawMenu()
end

local ok, err = pcall(main)
if not ok then
	print(err)
end