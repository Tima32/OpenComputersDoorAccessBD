--propirties
local port = 32001;
local client_table_adr = "client_table.json";
local bd_f = "DoorAccessBD.json"
local default_admin = "admin"     
local default_admin_pass = "admin" --edit in $client_table_adr file

--imporst
local ser = require("serialization")
local com = require("component")
local event = require("event")

--global
local clien_table = {}

function LoadClientTable()
    local file =  io.open(client_table_adr, "r")
    if file ~= nil then
        local table = file:read();
        client_table = ser.unserialize(table);
    end

    if client_table[default_admin] == nil then
        client_table[default_admin]["password"] = default_admin_pass;
        local access = {};
        access["read"] = true;
        access["write"] = true;
        access["configure"] = true;
        client_table[default_admin]["access"] = access;
    end
end

function main()

end


main()