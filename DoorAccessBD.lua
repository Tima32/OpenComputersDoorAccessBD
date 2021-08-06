--propirties
local port = 32001;
local client_table_adr = "client_table.json";
local bd_adr = "DoorAccessBD.json"
local default_admin = "admin"     
local default_admin_pass = "admin" --edit in $client_table_adr file

--imporst
local ser = require("serialization")
local com = require("component")
local event = require("event")

--global
local client_table = {}
local bd = {}
local modem = com.modem;

--Client table
function LoadClientTable()
    local file =  io.open(client_table_adr, "r")
    if file ~= nil then
        local table = file:read();
        client_table = ser.unserialize(table);
        file:close();
    end

    --Если админа нет добавим
    if client_table == nil or client_table[default_admin] == nil then
        client_table[default_admin] = {};
        client_table[default_admin]["password"] = default_admin_pass;
        local access = {};
        access["read"] = true;
        access["write"] = true;
        access["configure"] = true;
        client_table[default_admin]["access"] = access;

        SaveClientTable();
    end
end
function SaveClientTable()
    local table = ser.serialize(client_table);
    local file = io.open(client_table_adr, "w");
    file:write(table);
    file:close();
end

--BD
function LoadBD()
    local file =  io.open(bd_adr, "r")
    if file ~= nil then
        local table = file:read();
        bd = ser.unserialize(table);
        file:close();
    end
end
function SaveBD()
    local table = ser.serialize(bd);
    local file = io.open(bd_adr, "w");
    file:write(table);
    file:close();
end



function EventHandling(event)
    print(event)
end

function main() --main
    LoadClientTable();
    LoadBD();

    if modem == nil then
        print("Error: no modem")
        return;
    end
    modem.open(port);

    for true do
        local event = {event.pull()}
        EventHandling(event)
    end

end


main()