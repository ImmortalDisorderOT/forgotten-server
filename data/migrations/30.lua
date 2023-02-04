function onUpdateDatabase()
	print("> Updating database to version 30 (add looktitle, lookwings, lookaura, lookshader")
	db.query("ALTER TABLE `players` ADD `looktitle` int NOT NULL DEFAULT '0'")
	db.query("ALTER TABLE `players` ADD `lookwings` int NOT NULL DEFAULT '0'")
	db.query("ALTER TABLE `players` ADD `lookaura` int NOT NULL DEFAULT '0'")
	db.query("ALTER TABLE `players` ADD `lookshader` int NOT NULL DEFAULT '0'")

	return true
end
