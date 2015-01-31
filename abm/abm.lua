--[[ Variables ]]--

--[[ Tables ]]--
local OsList = fs.list("os/")

--[[ Functions ]]--
function listOs()
	for i, os_folder in ipairs(OsList) do
		print(i..". "..os_folder)
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