--[[ Variables ]]--
local defaultOsFolder = "os/"
local defaultConfigurationFile = "/config.abm"

--[[ Tables ]]--
local OsList = fs.list(defaultOsFolder)
local OS = {
	[1] = {name = "hoa", version = "1.2", boot = "asdsad.lua"}
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
		OS[index] = {name = string.sub(f.readLine(), 6), version = string.sub(f.readLine(), 9), boot = string.sub(f.readLine(), 6)}
		f.close()
	end
end

--[[ Main function ]]--
function main()
	listOs()
	term.write("Select OS: ")
	selection = read()
	--Run main file of the selected os
end

local ok, err = pcall(main)
if not ok then
	print(err)
end