--[[

Copyright 2021 - Sebastian S. Cocioba - Binomica Labs
Inspired by a Tweet from @JacobPhD (Dr. Jacob A Tennessen)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]] --



-- handle passed arguments for later use 
if #arg < 1 then
    print("")
    print("ProtEmojiome v1.0 - Whole Proteome to Emojiome Converter")
    print(
        "----------------------------------------------------------------------------")
    print("")
    print("usage: lua " .. arg[0] ..
              " [protein multi-seq FASTA file name] [output file name]  ")
    print("")
    print(
        "example input: lua protemojiome.lua testProteome.faa testProtEmojiomeOutput.faa")
    print("")
    return
end

-- set file logic and catch loading errors
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



emojiCodex = 
{
    -- Hydrophobic
    -- Big
    W = "🐂",
    F = "🐎",
    Y = "🐫",
    -- Small
    A = "🐿️",
    V = "🐈",
    I = "🐒",
    L = "🐕",
    P = "🐗",
    M = "🌰",
    C = "🥜",
    G = "🥔",
    -- Hydrophilic 
    -- Polar
    S = "🐊",
    T = "🐸",
    N = "🐠",
    Q = "🐟",
    -- Negative
    E = "🦑",
    D = "🐙",
    -- Positive
    R = "🐳",
    K = "🐋",
    H = "🐬"
}



function delimiterSplit(delim, str) -- chop string using custom char delimiter, to table
    local strTable = {}
    for substr in string.gmatch(str, "[^" .. delim .. "]+") do
        if substr ~= nil and string.len(substr) > 0 then
            table.insert(strTable, substr)
        end
    end
    return strTable
end



function splitByChunk(text, chunkSize) -- basic function to split string into table of substrings 
    local s = {} -- chunkSize denotes how long substring is; 1 = single char
    for i = 1, #text, chunkSize do -- returns a table of substrings or chars
        s[#s + 1] = text:sub(i, i + chunkSize - 1)
    end
    return s
end



-- intialize a table
local proteomeInputString = inputFile:read("*all") -- read entire file as one string + all end of line chars
inputFile:close() -- close file because we got what we need from it
local proteomeLines = delimiterSplit("\n", proteomeInputString)

for i = #proteomeLines, 1, -1 do
    if string.find(proteomeLines[i], ">") then
        table.remove(proteomeLines, i)
        table.insert(proteomeLines, i, ">")
    end
end

local trimmedProteome = table.concat(proteomeLines, "")
local proteomeTable = delimiterSplit(">", trimmedProteome) -- fill table with protein sequences, one protein per element

for i = 1, #proteomeTable do

    proteinTable = splitByChunk(proteomeTable[i], 1)

    for j = 1, #proteinTable do

        for k, v in pairs(emojiCodex) do -- for each amino letter and it's associated emoji

            if proteinTable[j] == k then -- if the letter matches a corresponding emoji in codex
                emojiLine = emojiLine .. v -- append the new emojiLine with said emoji    
            end
        end

    end
    emojiLine = emojiLine .. "\n" -- combine the original header with the new emoji alignment string + newline
    outputFile:write(emojiLine) -- write the output string of emojis to a file
    emojiLine = ""
end

print("Total proteins in this proteome file: " .. #proteomeTable)
