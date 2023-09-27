VERSION = "1.0.0"

local micro = import("micro")
local config = import("micro/config")

function init()
    config.MakeCommand("align", align, config.NoComplete)
    config.AddRuntimeFile("align", config.RTHelp, "help/align.md")
end

function max(arr)
    local largest = 0
    for i = 1, #arr do
        local x = arr[i]
        if x > largest then
            largest = x
        end
    end
    return largest
end

function map(arr, f)
    local arrNew = {}
    for i = 1, #arr do
        arrNew[i] = f(arr[i])
    end
    return arrNew
end

function align(bp)
    local cursors = bp.Buf:GetCursors()
    if cursors then
        local furthestX = max(map(cursors, function(cursor) return cursor:GetVisualX() end))
        for i = 1, #cursors do
            local cursor = cursors[i]
            bp.Buf:insert(-cursor.Loc, string.rep(" ", furthestX - cursor:GetVisualX()))
        end
        micro.InfoBar():Message("Aligned cursors.")
    else
        micro.InfoBar():Message("No cursors found.")
    end
end
