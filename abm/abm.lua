--[[ Variables ]]--
local version = "build 20150131.1926"
local defaultOsFolder = "os/"
local defaultConfigurationFile = "/config.abm"

--[[ Tables ]]--
local OsList = fs.list(defaultOsFolder)
local OS = {}

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

--[[ Main function ]]--
function main()
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
end

local ok, err = pcall(main)
if not ok then
	print(err)
end