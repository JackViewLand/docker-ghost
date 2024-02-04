local tool = require 'module/toolModule'

local req_header = ngx.req.get_headers()
local admin = req_header['admin']

local user_info = {}
user_info['remote_addr'] = ngx.var.remote_addr
user_info['user_agent'] = ngx.var.http_user_agent
local remote_addr = ngx.var.remote_addr
local ua = ngx.var.http_user_agent

function get_time()
    local local_unix_time = ngx.time(ngx.localtime())
    local gmt_offset = 8 * 60 * 60
    local gmt8_unix_time = local_unix_time + gmt_offset
    local formatted_time = os.date("%Y-%m-%d %H:%M:%S", gmt8_unix_time)
    return formatted_time
end

local timestamp = get_time()

if admin == 'admin' then
    tool.swrite(timestamp.." -- ".."admin login!")
else
    ngx.header.content_type = "text/html"	
    ngx.say("you are not admin!")
    tool.swrite(timestamp.." remote_addr: "..remote_addr.." user_agent: "..ua)
end



