local _M = {}

local path = "/var/log/nginx/lua.log"

local function swrite(content)
    local file = io.open(path,'a+');
    file:write(content.."\n")
    file:close()
end


_M.swrite = swrite

return _M
