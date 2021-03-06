local component = require("component")
local event = require("event")
local net = require("libnet")
local termui = require("libtermui")

local TYPE = {"server", "client"}
local settings = {}

local function onRequest(remoteAddress, data)
    termui.write(1,2,"Request: "..tostring(data))
    local upper = string.upper(tostring(data))
    net.send(remoteAddress, upper, "reply")
end

local function onReply(remoteAddress, data)
    termui.write(1,2,"Reply: "..tostring(data))
end

-- Select program mode
termui.clear()
termui.write(1, 1, "LibNet Test")
termui.write(1, 2, "Select mode:")
settings.type = TYPE[termui.selectOptions(2,3,TYPE)]

net.open(3000, "test")
if settings.type == "server" then
    net.connectEvent("request", onRequest)
else
    net.connectEvent("reply", onReply)
end

termui.clear()
termui.write(1, 1, "LibNet Test: "..settings.type)
while event.pull(0.01, "interrupted") == nil do
    if settings.type == "client" then
        local message = termui.read(1,4,false)
        if message ~= "" then
            net.broadcast(message, "request")
        end
    end
end
net.close()