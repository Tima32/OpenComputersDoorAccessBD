--properties
local door_access_BD_port = 32001;
local door_access_BD_adr = ""
local port = 32002;
local doors_adr = "doors_table.json"
local controllers_adr = "controllers_table.json"

--imporst
local ser = require("serialization")
local com = require("component")
local event = require("event")

--global
local modem = com.modem;


function main()
    modem.open(port)
end

main()