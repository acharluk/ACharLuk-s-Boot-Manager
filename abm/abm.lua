--[[ Variables ]]--
<<<<<<< HEAD
local running = true
=======
<<<<<<< HEAD
local version = "build 20150201.1706"
local defaultOsFolder = "os/"
local defaultConfigurationFile = "/config.abm"
=======
>>>>>>> 9c821c55352351262fbae9534c9e23b4d4fac380
local ABMConfigFile = "configuration.cfg"
>>>>>>> 68c2db54fd49722fd363aace515106270cbe8a53

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
	while true do
		line = f.readLine()
		if line == nil then break end
		split = splitstr(line, "=")
		conf[split[1]] = split[2]
	end
	f.close()
end
function loadOS()
	OS = {}
	OsList = fs.list(conf["default_os_folder"])
	for i, os_folder in pairs(OsList) do
		path = conf["default_os_folder"]..os_folder..conf["default_conf_file"]
		if fs.exists(path) then
			f = fs.open(path,"r")
			t = #OS
			OS[t + 1] = {
				folder = conf["default_os_folder"]..os_folder,
				name = splitstr(f.readLine(), "=")[2],
				version = splitstr(f.readLine(), "=")[2],
				boot = splitstr(f.readLine(), "=")[2],
			}
			f.close()
		end
	end
end

--[[
	Draw main menu
]]--
function drawMenu()
	acl.cc(tonumber(conf["color_tx_inactive"]), tonumber(conf["color_bg_inactive"]))
	acl.cls()
	selected = 1
	while running do
		acl.drawFrame(w,h,shor,sver,scor)
		acl.scp(9,2)
		write("ACL Boot Manager "..conf["version"])
		for i = 1, #OS do
			acl.scp(3, math.floor(h / 3 + i))
			menu(i, OS[i].name.." - version: "..OS[i].version)
		end
		ev, k, _, line = os.pullEvent()
		if ev == "key" then
			if k == keys.up and selected > 1 and tonumber(conf["enable_touch"]) == 0 then
				selected = selected - 1
			elseif k == keys.down and selected < #OS and tonumber(conf["enable_touch"]) == 0 then
				selected = selected + 1
			elseif k == keys.enter and tonumber(conf["enable_touch"]) == 0 then
				launch = OS[selected].folder.."/"..OS[selected].boot
				acl.cls(1, 1)
				shell.run(launch)
				return
			elseif k == keys.r then
				acl.cls()
				loadOS()
			end
		elseif ev == "mouse_click" then
			for i = 1, #OS do
				if line == OS[i].line then
					launch = OS[i].folder.."/"..OS[i].boot
					acl.cls(1, 1)
					shell.run(launch)
					return
				end
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
		if tonumber(conf["enable_touch"]) == 0 then
			acl.cc(tonumber(conf["color_tx_active"]), tonumber(conf["color_bg_active"]))
			write("* ")
		else
			write("  ")
		end
	else
		write("  ")
	end
	write(text)
	_,OS[id].line = term.getCursorPos()
	acl.cc(tonumber(conf["color_tx_inactive"]), tonumber(conf["color_bg_inactive"]))
end

--[[ Main function ]]--
function main()
	os.loadAPI("apis/acl")
	w, h = acl.size()
	loadConfiguration()
	
	print()
	--listOs()
	loadOS()
	drawMenu()
end

local ok, err = pcall(main)
if not ok then
	print(err)
end