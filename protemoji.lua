--[[

Copyright 2021 - Sebastian S. Cocioba - Binomica Labs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

--handle passed arguments for later use 
if #arg < 1 then
	print("")
	print("ProtEmoji v1.0 - Amino to Emoji Converter")
	print("----------------------------------------------------------------------------")
	print("")
	print("usage: lua " .. arg[0] .. " [protein FASTA file name] [output file name]  ")
	print("")
	print("example input: lua protemoji.lua testProtein.faa testOutput.faa")
	print("")
	return
end

--set file logic and catch loading errors
local inputFile = io.open(arg[1], "r")
local outputFile = io.open(arg[2], "w")
if not inputFile or not outputFile then
	print("")
	print("")
	print("Error: could not open files; check file names and paths!")
	print("")
	print("")
	return
end

proteinInputString = ""
emojiOutputString = ""
proteinInputTable = {}
emojiOutputTable = {}



emojiCodex = 
{
    --Hydrophobic
    --Big
    W = "🐂",
    F = "🐎",
    Y = "🐫",
    --Small
    A = "🐿️",
    V = "🐈",
    I = "🐒",
    L = "🐕",
    P = "🐗",
    M = "🌰",
    C = "🥜",
    G = "🥔",
    --Hydrophilic 
    --Polar
    S = "🐊",
    T = "🐸",
    N = "🐠",
    Q = "🐟",
    --Negative
    E = "🦑",
    D = "🐙",
    --Positive
    R = "🐳",
    K = "🐋",
    H = "🐬"
}



function splitByChunk(text, chunkSize)                  --basic function to split string into table of substrings 
    local s = {}                                        --chunkSize denotes how long substring is; 1 = single char
        for i=1, #text, chunkSize do                    --returns a table of substrings or chars
            s[#s+1] = text:sub(i,i+chunkSize - 1)
        end
        return s
end



firstLine = inputFile:read()                            --read first line of file (FASTA header)
proteinInputString = inputFile:read("*all")             --read entire file as one string + all end of line chars
inputFile:close()                                       --close file because we got what we need from it

trimmedSequence = string.gsub(proteinInputString, firstLine, "")        --remove the FASTA header

polishedSequence = string.upper(trimmedSequence:gsub("[\r\n]", ""))     --remove new lines and carriage reture chars

proteinInputTable = splitByChunk(polishedSequence, 1)                   --split protein seq into table of chars



for i=1,#proteinInputTable do                               --for every amino letter in the table,
    for k, v in pairs(emojiCodex) do                        
        if proteinInputTable[i] == k then                   --if the letter matches a corresponding emoji in codex
            emojiOutputString = emojiOutputString .. v      --append output string of emojis with corresponding emoji
        end
    end
end



outputFile:write(emojiOutputString)         --write the output string of emojis to a file
outputFile:close()                          --close the output file
print("Done! Check your output file for emojis and enjoy :)")