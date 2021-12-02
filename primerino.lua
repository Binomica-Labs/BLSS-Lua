--[[

Copyright 2021 - Sebastian S. Cocioba - Binomica Labs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--


--handle passed arguments for later use 
if #arg < 1 then
	print("")
	print("Primerino v0.2 - Primer3 Interactive CLI App")
	print("----------------------------------------------------------------------------")
	print("")
	print("usage: lua " .. arg[0] .. " detect ")
	print("")
	print("Please note this is still in development. Do not use generated data for actual research yet!")
	print("")
	return
end

local function fileExists(fileName)
	local f = io.open(fileName, "r")

	if f ~= nil then
		 io.close(f)
		return true
	else
		return false
	end
end


local function parseFasta(fileName)
	file = io.open(fileName, "r")	--declare a file variable and open said passed file by its name
	local header = file:read()	--read first line of file, store as FASTA header variable
	local fileContent = file:read("*all")	--store the entire contents of the file as a single string
	file:close()							--close the file
	local trimmedSeq = string.gsub(fileContent, header, "")	--remove the FASTA header
	local polishedSeq = string.upper(trimmedSeq:gsub("[\r\n]", ""))	--remove all carriage returns so the actual sequence is a single string
	return header, polishedSeq	--return these two variables to be used later
end



local function makeDetectionPrimers()
	local inputAmplicon = ""
	local amplicon = ""
	local detectionFile = io.open("DET", "w")	--make a temporary file called DET and make it writeable
	
	os.execute("clear")		--clear the terminal window

	print("Welcome to an interactive Lua wrapper for Primer3!")
	print("")

	print("Tell me the file name or, if you feel brave, copy and paste the sequence")
	print("information directly. Be sure to use only single FASTA entries for now.")

	io.write("Please type in a file name or sequence here: ")

	inputAmplicon = io.read()	--store user input as amplicon reference
	fileAmplicon = io.open(inputAmplicon, "r")
	if fileAmplicon then
		fileAmplicon:close()
   		ampName, amplicon = parseFasta(inputAmplicon)
	else
		amplicon = inputAmplicon
	end
	
	print("")

	print("Input Sequence Length: " .. amplicon:len())
	print("")
	print("At what temp do you wish to anneal your primers? Default is 60 degrees Celsius.")

	io.write("Please type in a temperature here: ")
	local idealAnnealingTemp = io.read()

	print("")
	print("How long should your oligos be? Typically 25bp gives nice unique sequences.")

	io.write("Please type in your desired oligo length here: ")
	local idealPrimerLength = io.read()

	print("Cool. I'll write up the necessary file to feed into Primer3. One moment, please!")
	
	local settingsList = {}		--table for storing the Primer3 input file settings and user inputs


	settingsList[1] = "SEQUENCE_ID=" .. "detectionTest" .. "\n"
	settingsList[2] = "SEQUENCE_TEMPLATE=" .. amplicon .. "\n"
	settingsList[3] = "PRIMER_TASK=generic" .. "\n"
	settingsList[4] = "PRIMER_PICK_LEFT_PRIMER=1" .. "\n"
	settingsList[5] = "PRIMER_PICK_INTERNAL_OLIGO=0" .. "\n"
	settingsList[6] = "PRIMER_PICK_RIGHT_PRIMER=1" .. "\n"
	settingsList[7] = "PRIMER_OPT_SIZE=" .. idealPrimerLength .. "\n"
	settingsList[8] = "PRIMER_MIN_SIZE=18" .. "\n"
	settingsList[9] = "PRIMER_MAX_SIZE=36" .. "\n"	--Primer3 hard capped at 36bp
	settingsList[10] = "PRIMER_PRODUCT_SIZE_RANGE=450-550" .. "\n"	--amplicon size rage, will port this out soon
	settingsList[11] = "PRIMER_EXPLAIN_FLAG=0" .. "\n"	--shut off verbose mode for easy parsing later
	settingsList[12] = "=" .. "\n" --necessary end character

	for i=1, #settingsList do
		detectionFile:write(settingsList[i])		
	end
	detectionFile:close()
	
	os.execute("./primer3 DET > detectionPrimers.txt\n")	--run primer3's core binary from the terminal using file called "DET" (temporary settings file)
	os.execute("rm DET")	--remove temporary Primer3 input file; comment out if you want to keep it
	print("")
	print("")
	print("Done! See file detectionPrimers.txt for the raw Primer3 output.")
	print("Output parser and CSV generator comming soon.")
	print("Enjoy your day! :)")
end 

if arg[1] == "detect" then
	makeDetectionPrimers()
end
