--[[

Copyright 2021 - Sebastian S. Cocioba - Binomica Labs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]] --



-- handle passed arguments for later use 
if #arg < 1 then
    print("")
    print("ProteStats v1.0 - Quick Proteome Stats")
    print(
        "----------------------------------------------------------------------------")
    print("")
    print("usage: lua " .. arg[0] ..
              " [protein multi-seq FASTA file name] [output file name]  ")
    print("")
    print("example input: lua protestats.lua testProteome.faa testStats.faa")
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



-- Handy Functions to Call Later
function splitByChunk(text, chunkSize) -- basic function to split string into table of substrings 
    local s = {} -- chunkSize denotes how long substring is; 1 = single char
    for i = 1, #text, chunkSize do -- returns a table of substrings or chars
        s[#s + 1] = text:sub(i, i + chunkSize - 1)
    end
    return s
end



function delimiterSplit(delim, str) -- chop string using custom char delimiter, to table
    local strTable = {}
    for substr in string.gmatch(str, "[^" .. delim .. "]+") do
        if substr ~= nil and string.len(substr) > 0 then
            table.insert(strTable, substr)
        end
    end
    return strTable
end



function parseProteome(proteomeFile)
    local proteomeInputString = proteomeFile:read("*all") -- read entire file as one string + all end of line chars
    proteomeFile:close() -- close file because we got what we need from it
    local proteomeLines = delimiterSplit("\n", proteomeInputString)

    for i = #proteomeLines, 1, -1 do
        if string.find(proteomeLines[i], ">") then
            table.remove(proteomeLines, i)
            table.insert(proteomeLines, i, ">")
        end
    end

    local trimmedProteome = table.concat(proteomeLines, "")
    local proteomeTable = delimiterSplit(">", trimmedProteome) -- fill table with protein sequences, one protein per element
    return proteomeTable
end



local proteomeTable = parseProteome(inputFile)
local aminoCountTable = {}

for i = 1, #proteomeTable do

    for amino in string.gmatch(proteomeTable[i], "%w") do
        if aminoCountTable[amino] then
            aminoCountTable[amino] = aminoCountTable[amino] + 1
        else
            aminoCountTable[amino] = 1
        end
    end
end



totalAminos = aminoCountTable["A"] +
              aminoCountTable["C"] +
              aminoCountTable["D"] + 
              aminoCountTable["E"] + 
              aminoCountTable["F"] + 
              aminoCountTable["G"] + 
              aminoCountTable["H"] + 
              aminoCountTable["I"] + 
              aminoCountTable["K"] + 
              aminoCountTable["L"] + 
              aminoCountTable["M"] + 
              aminoCountTable["N"] + 
              aminoCountTable["P"] + 
              aminoCountTable["Q"] + 
              aminoCountTable["R"] + 
              aminoCountTable["S"] + 
              aminoCountTable["T"] + 
              aminoCountTable["V"] + 
              aminoCountTable["W"] + 
              aminoCountTable["Y"]   

print(totalAminos)

outputFile:write("A" .. "," .. (aminoCountTable["A"]/totalAminos)*100 .. "\n")
outputFile:write("C" .. "," .. (aminoCountTable["C"]/totalAminos)*100 .. "\n")
outputFile:write("D" .. "," .. (aminoCountTable["D"]/totalAminos)*100 .. "\n")
outputFile:write("E" .. "," .. (aminoCountTable["E"]/totalAminos)*100 .. "\n")
outputFile:write("F" .. "," .. (aminoCountTable["F"]/totalAminos)*100 .. "\n")
outputFile:write("G" .. "," .. (aminoCountTable["G"]/totalAminos)*100 .. "\n")
outputFile:write("H" .. "," .. (aminoCountTable["H"]/totalAminos)*100 .. "\n")
outputFile:write("I" .. "," .. (aminoCountTable["I"]/totalAminos)*100 .. "\n")
outputFile:write("K" .. "," .. (aminoCountTable["K"]/totalAminos)*100 .. "\n")
outputFile:write("L" .. "," .. (aminoCountTable["L"]/totalAminos)*100 .. "\n")
outputFile:write("M" .. "," .. (aminoCountTable["M"]/totalAminos)*100 .. "\n")
outputFile:write("N" .. "," .. (aminoCountTable["N"]/totalAminos)*100 .. "\n")
outputFile:write("P" .. "," .. (aminoCountTable["P"]/totalAminos)*100 .. "\n")
outputFile:write("Q" .. "," .. (aminoCountTable["Q"]/totalAminos)*100 .. "\n")
outputFile:write("R" .. "," .. (aminoCountTable["R"]/totalAminos)*100 .. "\n")
outputFile:write("S" .. "," .. (aminoCountTable["S"]/totalAminos)*100 .. "\n")
outputFile:write("T" .. "," .. (aminoCountTable["T"]/totalAminos)*100 .. "\n")
outputFile:write("V" .. "," .. (aminoCountTable["V"]/totalAminos)*100 .. "\n")
outputFile:write("W" .. "," .. (aminoCountTable["W"]/totalAminos)*100 .. "\n")
outputFile:write("Y" .. "," .. (aminoCountTable["Y"]/totalAminos)*100 .. "\n")
outputFile:close()