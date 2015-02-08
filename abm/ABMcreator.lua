local tArgs = { ... }

function create(folder, name, version, boot)
	fs.makeDir("os/"..folder)
	file = fs.open("os/"..folder.."/config.abm", "w")
	file.writeLine("name="..name)
	file.writeLine("version="..version)
	file.writeLine("boot="..boot)
	file.close()
end
function delete(folder)
	fs.delete("os/"..folder)
end
mode = tArgs[1]
function main()
	os.loadAPI("apis/acl")
	if #tArgs > 0 then
		if mode == "create" then
			create(tArgs[2], tArgs[3], tArgs[4], tArgs[5])
		elseif mode == "delete" then
			delete(tArgs[2])
		else
			printError("Usage: ABMcreator.lua [create/delete] folder name version boot")
		end
	else
		acl.cls(1, 1)
		print("ABM os configuration file creator")
		
		write("Enter folder: ")
		folder = read()
		print()

		write("Enter name: ")
		name = read()
		print()

		write("Enter version: ")
		version = read()
		print()

		write("Enter boot: ")
		boot = read()
		print()

		create(folder, name, version, boot)
	end
end
local ok, err = pcall(main)
if not ok then
	print(err)
end