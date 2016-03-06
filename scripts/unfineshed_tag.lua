-- This script automatically remove the Unfinished label
-- Depend on `brew install tag`

utils = require 'mp.utils'

DEBUG = false
TAG_UNFINISHED = 'Unfinished'

local path

function markUnfinished()
    if path then
        mp.msg.info('Mark Unfinished', path)
        local result = utils.subprocess({args = {'/usr/local/bin/tag', '-s', TAG_UNFINISHED, path}, cancellable = false})

        if result.status == 0 then
            mp.osd_message('Mark Unfinished')
        end
    end
end

function removeUnfinished()
    if path then
        mp.msg.info('Remove Unfinished', path)
        local result = utils.subprocess({args = {'/usr/local/bin/tag', '-r', TAG_UNFINISHED, path}, cancellable = false})

        if result.status == 0 then
            mp.osd_message('Remove Unfinished')
        end
    end
end

function checkHasTag()
    local hasTag = utils.subprocess({args = {'which', '-s', '/usr/local/bin/tag'}, cancellable = false})
    if hasTag.status == 0 then
        return true
    else
        mp.msg.warn('Not have tag', hasTag.status, hasTag.error)
        return false
    end
end

function hasUnfinishedTag()
    if checkHasTag() then
        if not path then return false end

        local tags = utils.subprocess({args = {'/usr/local/bin/tag', '-lN', path}, cancellable = false})

        if tags.status == 0 then
            return string.find(tags.stdout, TAG_UNFINISHED) ~= nil
        else
            mp.msg.warn('List tag failed', tags.status, tags.error)
            return false
        end
    else
        return false
    end
end

function onStartFile( event )
    path = mp.get_property('path')
    mp.msg.info('start-file')
    if hasUnfinishedTag() == false then
        markUnfinished()
    end
end

function onEndFile( event )
    mp.msg.info('end-file ',event.reason)
    if event.reason == 'eof' then
        if hasUnfinishedTag() == true then
            removeUnfinished()
        end
    end
end

mp.register_event('start-file', onStartFile)
mp.register_event('end-file', onEndFile)
