import "stringUtil"
if not version.hostName.startsWith("Command-Line") then
	print "Whoops!  You're meant to run this from command-line MiniScript."
	exit
end if

srcFolder = "../basic-computer-games/00_Alternate_Languages"
if not file.info(srcFolder) then
	print "Unable to find source files at " + srcFolder
	exit
end if

filesEndingIn = function(folderPath, endIn)
	result = []
	for f in file.children(folderPath)
		if f.endsWith(endIn) then result.push f
	end for
	return result
end function

copyToFolder = function(srcFolder, fileName, destFolder)
	print "   " + fileName
	srcPath = file.child(srcFolder, fileName)
	destPath = file.child(destFolder, fileName)
	if not file.copy(srcPath, destPath) then
		print "ERROR: unable to copy " + srcPath + " -> " + destPath
		exit
	end if
end function

children = file.children(srcFolder)
children.sort
for f in children
	srcPath = file.child(srcFolder, f)
	if not file.info(srcPath).isDirectory then continue
	destPath = file.child(file.curdir, f)
	print f + "..." + " --> " + destPath
	if not file.exists(destPath) then
		if not file.makedir(destPath) then
			print "Unable to create directory: " + destPath
			exit
		end if
	end if
	
	// get the README file and .bas files from the top-level folder
	topProgPath = file.child(file.parent(srcFolder), f)	
	readMePath = file.child(topProgPath, "README.md")
	copyToFolder topProgPath, "README.md", destPath
	for basFile in filesEndingIn(topProgPath, ".bas")
		copyToFolder topProgPath, basFile, destPath
	end for
	
	// copy the .ms files out of the MiniScript folder
	msFolder = file.child(srcPath, "MiniScript")
	if not file.exists(msFolder) then
		print "No MiniScript folder found in " + srcFolder
		continue
	end if
	for msFile in filesEndingIn(msFolder, ".ms")
		copyToFolder msFolder, msFile, destPath
	end for
end for
