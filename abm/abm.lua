--[[ Variables ]]--
local defaultOsFolder = "os/"
local defaultConfigurationFile = "/config.abm"

--[[ Tables ]]--
local OsList = fs.list(defaultOsFolder)
local OsBootFile = {}

--[[ Functions ]]--
function listOs()
	for i, os_folder in ipairs(OsList) do
		if checkSuitableOs(os_folder) then
			print(i..". "..os_folder)
		end
	end
end

function checkSuitableOs(os_folder)
	if fs.exists(defaultOsFolder..os_folder..defaultConfigurationFile) then
		--Check configuration file
		print("yep, suitable")
		return true
	else
		print("Not a valid os")
		return false
	end
end

--[[ Main function ]]--
function main( ... )
	listOs()
	term.write("Select OS: ")
	selection = read()
	--Run main file of the selected os
end

local ok, err = pcall(main)
if not ok then
	print(err)
end