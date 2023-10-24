import "stringUtil"

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

filesEndingIn = function(folderPath, endIn)
	result = []
	for f in file.children(folderPath)
		if f.endsWith(endIn) then result.push f
	end for
	return result
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
		text.color = "#CCCCCC"; print s
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
	text.color = "#CCCCCC"
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
		lines[i] = lines[i].replace(char(8212), "--")
		if lines[i].len > 68 then
			p = 68
			while p > 10 and lines[i][p] != " "; p -= 1; end while
			if p <= 10 then p = 68
			lines.insert i+1, lines[i][p:]
			lines[i] = lines[i][:p]
		end if
		i += 1
	end while
	// then display, one page at a time
	text.color = "#CCCCCC"
	pageThrough lines
	text.color = "#CCCCCC"; print "Press ", ""
	text.color = color.yellow; print "R", ""
	text.color = "#CCCCCC"; print " to Run, any other key to return to menu: "
	key.clear; k = key.get
	if k == "r" or k == "R" then
		msFiles = filesEndingIn(folder, ".ms")
		if msFiles.len == 0 then
			print "Whoops!  No MiniScript file found!"
			wait 2
		else
			env.shell = "/usr/menu.ms"
			reset; globals.returning = true
			text.color = color.orange
			load file.child(folder, msFiles[0])
			clear
			run
			exit
		end if
	end if
end function

if globals.hasIndex("returning") and returning == true then
	print
	text.color = "#AAAAAA"
	print "(Press any key to return to menu.)"
	key.clear; key.get
end if

while true
	num = mainMenu
	if num < 1 or num > folders.len then continue
	folder = folders[num-1]
	doProgram folder
end while

