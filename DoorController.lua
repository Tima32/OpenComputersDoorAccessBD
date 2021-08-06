--properties
local door_access_BD_port = 32001;
local door_access_BD_adr = "97bb736b"
local port = 32002;
local doors_adr = "doors_table.json"
local controllers_adr = "controllers_table.json"

--imporst
local ser = require("serialization")
local com = require("component")
local event = require("event")

--global
local modem = com.modem;

--Events
function EventHandling(event)
    for i = 1, #event do
        io.write(tostring(event[i]) .. " ")
    end
    io.write("\n")

    if event[1] == "interrupted" then
        os.exit();
    end

    if event[1] == "modem_message" then

    end
end
function EventModemMessage(event)
    --нужно дополнить адрес?
    if string.len(door_access_BD_adr) ~= 32 and string.match(event[3], door_access_BD_adr) == 1 then
        local file = io.open("DoorController.lua", "r")
        local code = "";
        file:read(code);
        file:close()
        string.gsub(code, door_access_BD_adr, event[3]);
        file = io.open("DoorController.lua", "w")
        file:write(code);
        file:close();
    end
end

function main()

    if modem == nil then
        print("Error: no modem")
        return;
    end
    modem.open(port)

    while true do
        local event = {event.pull()}
        EventHandling(event)
    end
end

main()