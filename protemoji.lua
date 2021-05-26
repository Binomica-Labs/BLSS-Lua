--handle passed arguments for later use 
if #arg < 1 then
	print("")
	print("")
	print("")
	print("")
	print("ProtEmoji v1.0 - Amino to Emoji Converter")
	print("----------------------------------------------------------------------------")
	print("")
	print("usage: lua " .. arg[0] .. " [protein file name] [output file name]  ")
	print("")
	print("")
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
    --Avoids Water
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
    --Loves Water
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

function splitByChunk(text, chunkSize)
    local s = {}
        for i=1, #text, chunkSize do
            s[#s+1] = text:sub(i,i+chunkSize - 1)
        end
        return s
end

firstLine = inputFile:read()
proteinInputString = inputFile:read("*all")
print("First line: " .. firstLine)
inputFile:close()

trimmedSequence = string.gsub(proteinInputString, firstLine, "")

polishedSequence = string.upper(trimmedSequence:gsub("[\r\n]", ""))
proteinInputTable = splitByChunk(polishedSequence, 1)

for i=1,#proteinInputTable do
    for k, v in pairs(emojiCodex) do
        if proteinInputTable[i] == k then
            --emojiOutputTable[i] = v
            emojiOutputString = emojiOutputString .. v
        end
    end
end

outputFile:write(emojiOutputString)
outputFile:close()