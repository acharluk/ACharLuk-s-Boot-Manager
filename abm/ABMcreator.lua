local tArgs = { ... }

mode = tArgs[1]
if mode == "create" then
	folder = tArgs[2]
	name = tArgs[3]
	version = tArgs[4]
	boot = tArgs[5]

	fs.makeDir("os/"..folder)
	file = fs.open("os/"..folder.."/config.abm", "w")
	file.writeLine("name="..name)
	file.writeLine("version="..version)
	file.writeLine("boot="..boot)
	file.close()
elseif mode == "delete" then
	folder = tArgs[2]
	fs.delete("os/"..folder)
else
	printError("Usage: ABMcreator.lua [create/delete] folder name version boot")
end