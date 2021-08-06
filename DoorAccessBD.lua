--propirties
local port = 32001;
local client_table_adr = "client_table.json";
local door_controller_table_adr = "door_controller_table.json"
local bd_adr = "door_access_BD.json"
local default_admin = "admin"     
local default_admin_pass = "admin" --edit in $client_table_adr file

--imporst
local ser = require("serialization")
local com = require("component")
local event = require("event")

--global
local client_table = {}
local door_controller_table = {}
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

--Door controller table
function LoadDoorTable()
    local file =  io.open(door_controller_table_adr, "r")

    if file == nil then
        print("NotOpen")
        door_controller_table[1] = "86a873b5-bc"
        SaveDoorTable()
    end

    if file ~= nil then
        local table = file:read();
        door_controller_table = ser.unserialize(table);
        file:close();
    end
end
function SaveDoorTable()
    local table = ser.serialize(door_controller_table);
    local file = io.open(door_controller_table_adr, "w");
    file:write(table);
    file:close();
end

--BD
function LoadBD()
    local file =  io.open(bd_adr, "r")

    --пример
    if file == nil then
        --bd["door_id"]["players"] = {"Tim", "Admin"}
        --bd["door_id"]["cards"] = {"id1", "id2"}
        --bd["door_id"]["password"] = "123"

        local players = {"Admin"}
        local cards = {"1d5c8a18-17e9-4d2e-8548-f7ebc5cd5f35"}
        local password = "123"

        local door = {}
        door["players"] = players;
        door["cards"] = cards;
        door["password"] = password;

        bd["door_id"] = door;
        SaveBD();
    end

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


--Events
function EventHandling(event)
    for i = 1, #event do
        io.write(tostring(event[i]) .. " ")
    end
    io.write("\n")

    if event[i] == "interrupted" then
        os.exit();
    end
end

function main() --main
    LoadClientTable();
    LoadDoorTable();
    LoadBD();

    if modem == nil then
        print("Error: no modem")
        return;
    end
    modem.open(port);

    while true do
        local event = {event.pull()}
        EventHandling(event)
    end

end


main()