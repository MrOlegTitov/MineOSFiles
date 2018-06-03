local event = require("event")
local gpu = require("component").gpu
 
------------------------------------------------------------------------------------------------------------
 
local maximumLines = 60
local minimumLineLength = 5
local maximumLineLength = 55
 
local chars = { "ァ", "ア", "ィ", "イ", "ゥ", "ウ", "ェ", "エ", "ォ", "オ", "カ", "ガ", "キ", "ギ", "ク", "グ", "ケ", "ゲ", "コ", "ゴ", "サ", "ザ", "シ", "ジ", "ス", "ズ", "セ", "ゼ", "ソ", "ゾ", "タ", "ダ", "チ", "ヂ", "ッ", "ツ", "ヅ", "テ", "デ", "ト", "ド", "ナ", "ニ", "ヌ", "ネ", "ノ", "ハ", "バ", "パ", "ヒ", "ビ", "ピ", "フ", "ブ", "プ", "ヘ", "ベ", "ペ", "ホ", "ボ", "ポ", "マ", "ミ", "ム", "メ", "モ", "ャ", "ヤ", "ュ", "ユ", "ョ", "ヨ", "ラ", "リ", "ル", "レ", "ロ", "ヮ", "ワ", "ヰ", "ヱ", "ヲ", "ン", "ヴ", "ヵ", "ヶ", "・", "ー", "ヽ", "ヾ" }
local lineColorsForeground = { 0xFFFFFF, 0xBBFFBB, 0x88FF88, 0x33FF33, 0x00FF00, 0x00EE00, 0x00DD00, 0x00CC00, 0x00BB00, 0x00AA00, 0x009900, 0x008800, 0x007700, 0x006600, 0x005500, 0x004400, 0x003300, 0x002200, 0x001100 }
local lineColorsBackground = { 0x004400, 0x004400, 0x003300, 0x003300, 0x002200, 0x001100 }
 
local charsSize = #chars
local lineColorsForegroundSize = #lineColorsForeground
 
------------------------------------------------------------------------------------------------------------
 
local screenWidth, screenHeight = gpu.getResolution()
local lines = {}
local currentBackground, currentForeground
 
------------------------------------------------------------------------------------------------------------
 
local function setBackground(color)
    if currentBackground ~= color then
        gpu.setBackground(color)
        currentBackground = color
    end
end
 
local function setForeground(color)
    if currentForeground ~= color then
        gpu.setForeground(color)
        currentForeground = color
    end
end
 
local function clearScreen()
    setBackground(0x000000)
    setForeground(0xFFFFFF)
    gpu.fill(1, 1, screenWidth, screenHeight, " ")
end
 
------------------------------------------------------------------------------------------------------------
 
clearScreen()
 
local i, eventType, keyCode, part
while true do
    while #lines < maximumLines do
        table.insert(lines, {
            x = math.random(1, screenWidth),
            y = 1,
            length = math.random(minimumLineLength, maximumLineLength)
        })
    end
 
    gpu.copy(1, 1, screenWidth, screenHeight, 0, 1)
    setBackground(0x000000)
    gpu.fill(1, 1, screenWidth, 1, " ")
 
    i = 1
    while i <= #lines do
        if lines[i].y - lines[i].length <= 0 then
            part = math.ceil(lineColorsForegroundSize * lines[i].y / lines[i].length)
           
            setForeground(lineColorsForeground[part] or 0x000000)
            setBackground(lineColorsBackground[part] or 0x000000)
            gpu.set(lines[i].x, 1, chars[math.random(1, charsSize)])
 
            i, lines[i].y = i + 1, lines[i].y + 1
        else
            table.remove(lines, i)
        end
    end
 
    eventType, _, _, keyCode = event.pull(0)
    if eventType == "touch" or eventType == "key_down" and keyCode == 28 then
        clearScreen()
        break
    end
end