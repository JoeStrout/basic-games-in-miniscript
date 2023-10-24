text.delimiter = char(13)
folders = file.children("/usr")
for i in range(folders.len-1)
	if folders[i][0] == "." or 
	not file.info(file.child("/usr", folders[i])).isDirectory then
		folders.remove i
	end if
end for

printCentered = function(s)
	text.column = 34 - s.len/2
	print s
end function

mainMenu = function
	clear
	text.color = color.yellow; text.row = 25
	printCentered "BASIC Computer Games, Ported to MiniScript"
	
	column = 0
	row = 0
	colWidth = 17
	for f in folders
		words = f.split("_")
		s = words[1:].join
		if s.len > colWidth-3 then s = s[:colWidth-4] + "…"
		text.row = 24 - row; text.column = colWidth * column
		text.color = "#AAAAFF"; print words[0], "."
		text.color = "#AAAAAA"; print s
		row += 1
		if row > 23 then
			row = 0
			column += 1
		end if
	end for
	
	text.row = 0; text.color = color.yellow
	num = input("Enter number (1-96): ").val
	return num
end function

doProgram = function(folder)
	clear
	text.row = 25; text.color = color.yellow
	words = folder.split("_")
	printCentered words[0] + ". " + words[1:].join
	
	// get lines of the README.md file
	lines = file.readLines(file.child(folder, "README.md"))
	// wrap lines to 68 columns, and truncate at "---"
	i = 0
	while i < lines.len
		if lines[i] == "---" then
			lines = lines[:i]
			break
		end if
		lines[i] = lines[i].replace(char(9), "    ")
		lines[i] = lines[i].replace(char(8217), "'")
		lines[i] = lines[i].replace(char(8220), """")
		lines[i] = lines[i].replace(char(8221), """")		
		lines[i] = lines[i].replace(char(9679), "•")		
		if lines[i].len > 68 then
			p = 68
			while lines[i][p] != " "; p -= 1; end while
			lines.insert i+1, lines[i][p:]
			lines[i] = lines[i][:p]
		end if
		i += 1
	end while
	// then display, one page at a time
	pageThrough lines
	key.clear; key.get
end function

while true
	num = mainMenu
	if num < 1 or num > folders.len then continue
	folder = folders[num-1]
	doProgram folder
end while

