--[[

Copyright 2021 - Sebastian S. Cocioba - Binomica Labs
Inspired by a Tweet from @JacobPhD (Dr. Jacob A Tennessen)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

--handle passed arguments for later use 
if #arg < 1 then
	print("")
	print("AlignEmoji v1.0 - Protein Alignment to Emoji Converter")
	print("----------------------------------------------------------------------------")
	print("")
	print("usage: lua " .. arg[0] .. " [protein ALN file name] [output file name]  ")
	print("")
	print("example input: lua alignemoji.lua testAlignment.aln emojiAlignOutput.aln")
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


local emojiLine = ""
local emojiLineFull = ""



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



function lines_from(file)                               --converts a text file into a table where each line is a table element
    local lines = {}
    for line in io.lines(file) do 
      lines[#lines + 1] = line
    end
    return lines
end



alignLines = lines_from(arg[1])                                     --read all the lines from the input file and add each line to a table


for i=1,#alignLines do
    local lineLength = string.len(alignLines[i])                    --compute the length of the current line in the alignment file
    local lineHeader = alignLines[i]:sub(0,37)                      --isolate alignment header (first 37 chars in clustal format)
    local lineAlignment = alignLines[i]:sub(38, lineLength)         --isolate characters after 37 all the way to end of line
    local alignmentTable = splitByChunk(lineAlignment, 1)           --split alignment line into a table of chars
    
    if lineHeader == "" then                                        --if header is blank, alignment line is also blank (important!)
        emojiLine = ""
    end
        
        for j=1,#alignmentTable do                                  --for each letter in the alignment line table    
            
            if alignmentTable[j] == "-" then                        --if the letter is a - then 
                emojiLine = emojiLine .. "➖"                       --append new emojiLine with ➖ so it spaces emoji string properly
            end
            
            for k, v in pairs(emojiCodex) do                        --for each amino letter and it's associated emoji
                
                if alignmentTable[j] == k then                      --if the letter matches a corresponding emoji in codex
                    emojiLine = emojiLine .. v                      --append the new emojiLine with said emoji    
                end
            end
        end

    

    emojiLineFull = lineHeader .. emojiLine .. "\r"                 --combine the original header with the new emoji alignment string + newline
    outputFile:write(emojiLineFull)                                 --write the output string of emojis to a file
    emojiLine = ""
end

inputFile:close()                                                   --close file because we got what we need from it
outputFile:close()                                                  --close the output file
print("Done! Check your output file for emojis and enjoy :)")