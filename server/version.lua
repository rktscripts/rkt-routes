local resourceName = 'rkt-routes'
local currentVersion = GetResourceMetadata(resourceName, 'version', 0)
local lang = Config.Lang['pt-br']

local CheckVersion = function()
    if not currentVersion then
        print("^5["..resourceName.."] Unable to determine current resource version for '" ..resourceName.. "' ^0")
        return
    end
    SetTimeout(1000, function()
        PerformHttpRequest('https://api.github.com/repos/rktscripts/' ..resourceName.. '/releases/latest', function(status, response)
            if status ~= 200 then return end
            response = json.decode(response)
            local latestVersion = response.tag_name
            if not latestVersion or latestVersion == currentVersion then return end
            if latestVersion ~= currentVersion then
                print('^6'..lang.aviable_version ..resourceName.. '^0')
                print('^6'..lang.current_version ..currentVersion.. '^0')
                print('^6'.. lang.latest_version..latestVersion.. '^0')
                print('^6'..lang.download_latest..'https://github.com/rktscripts/'..resourceName..'/releases^0')
                print('^6'..lang.more_info)

            end
        end, 'GET')
    end)
end


CreateThread(CheckVersion)