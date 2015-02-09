--[[ Variables ]]--
local running = true
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
--[[
	Load ABM configuration
]]--
function loadConfiguration()
	acl.dg("Loading configuration")
	f = fs.open("abm/"..ABMConfigFile, "r")
	while true do
		line = f.readLine()
		if line == nil then break end
		split = splitstr(line, "=")
		conf[split[1]] = split[2]
	end
	f.close()
end
--[[
	Return number of a config value
]]--
function getN(configStr)
	return tonumber(conf[configStr])
end
--[[
	Return string of a config value
]]--
function getS(configStr)
	return conf[configStr]
end
--[[
	Search for os and store them with their params in table OS
]]--
function loadOS()
	acl.dg("Clearing OS table")
	OS = {}
	acl.dg("Looking for os folders")
	OsList = fs.list(getS("default_os_folder"))
	for _, os_folder in pairs(OsList) do
		path = getS("default_os_folder")..os_folder..getS("default_conf_file")
		acl.dg("Checking os: "..path)
		if fs.exists(path) then
			f = fs.open(path,"r")
			t = #OS + 1
			OS[t] = {
				folder = getS("default_os_folder")..os_folder,
				name = splitstr(f.readLine(), "=")[2],
				version = splitstr(f.readLine(), "=")[2],
				boot = splitstr(f.readLine(), "=")[2],
			}
			f.close()
		acl.dg("OS \""..os_folder.."\" is booteable!")
		end
	end
end
--[[
	Draw main menu
]]--
function drawMenu()
	acl.dg("Starting to draw menu")
	acl.cc(getN("color_tx_inactive"), getN("color_bg_inactive"))
	acl.cls()
	selected = 1
	while running do
		acl.drawFrame(w,h,shor,sver,scor)
		acl.scp(9,2)
		write("ACL Boot Manager "..getS("version"))
		for i = 1, #OS do
			acl.scp(3, math.floor(h / 3 + i))
			menu(i, OS[i].name.." - version: "..OS[i].version)
		end
		ev, k, _, line = os.pullEvent()
		if ev == "key" then
			if k == keys.up and selected > 1 and getN("enable_touch") == 0 then
				selected = selected - 1
			elseif k == keys.down and selected < #OS and getN("enable_touch") == 0 then
				selected = selected + 1
			elseif k == keys.enter and getN("enable_touch") == 0 then
				launch = OS[selected].folder.."/"..OS[selected].boot
				acl.cls(1, 1)
				acl.dg("Booting from "..launch)
				shell.run(launch)
				return
			elseif k == keys.r then
				loadConfiguration()
				loadOS()
				acl.cls()
			elseif k == keys.q then
				print()
				print("Exiting")
				print()
				running = false
			elseif k == keys.c then
				shell.run("abm/ABMcreator.lua")
			end
		elseif ev == "mouse_click" and getN("enable_touch") == 1 then
			for i = 1, #OS do
				if line == OS[i].line then
					launch = OS[i].folder.."/"..OS[i].boot
					acl.cls(1, 1)
					acl.dg("Booting from "..launch)
					shell.run(launch)
					return
				end
			end
		end
	end
end

--[[
	New drawing function
]]--
function drawMenu2()
	acl.dg("Starting to draw menu")
	acl.cc(colors.black, colors.white)
	acl.cls()
	selected = 1
	while running do
		--acl.drawFrame(w,h,shor,sver,scor)
		--acl.scp(9,2)
		--write("ACL Boot Manager "..getS("version"))
		for i = 1, #OS do
			acl.scp(3, math.floor(h / 3 + i))
			menu(i, OS[i].name.." - version: "..OS[i].version)
			if fs.exists(OS[i].folder.."/icon.nfp") then
				img = paintutils.loadImage(OS[i].folder.."/icon.nfp")
				paintutils.drawImage(img,w-5,i*5)
				acl.cc(colors.white,colors.black)
			end
		end
		ev, k, _, line = os.pullEvent()
		if ev == "key" then
			if getN("enable_touch") == 0 then
				if k == keys.up and selected > 1 then
					selected = selected - 1
				elseif k == keys.down and selected < #OS then
					selected = selected + 1
				elseif k == keys.enter then
					launch = OS[selected].folder.."/"..OS[selected].boot
					acl.cls(1, 1)
					acl.dg("Booting from "..launch)
					shell.run(launch)
					return
				end
			end
			if k == keys.r then
				loadConfiguration()
				loadOS()
				acl.cls()
			elseif k == keys.q then
				print()
				print("Exiting")
				print()
				running = false
			elseif k == keys.c then
				shell.run("abm/ABMcreator.lua")
			end
		elseif ev == "mouse_click" and getN("enable_touch") == 1 then
			for i = 1, #OS do
				if line == OS[i].line then
					launch = OS[i].folder.."/"..OS[i].boot
					acl.cls(1, 1)
					acl.dg("Booting from "..launch)
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
		if getN("enable_touch") == 0 then
			acl.cc(getN("color_tx_active"), getN("color_bg_active"))
			write("* ")
		else
			write("  ")
		end
	else
		write("  ")
	end
	write(text)
	_,OS[id].line = term.getCursorPos()
	acl.cc(getN("color_tx_inactive"), getN("color_bg_inactive"))
end

--[[
	Main function
]]--
function main()
	os.loadAPI("apis/acl")
	w, h = acl.size()
	loadConfiguration()
	loadOS()
	drawMenu2()
end

local ok, err = pcall(main)
if not ok then
	print(err)
end