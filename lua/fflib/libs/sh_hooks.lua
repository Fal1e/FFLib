FFLib.Hook = {}
FFLib.HookName = 'FFLib.Hook:'

function FFLib.Hook.Add(hookName, identifier, func)
    hook.Add(hookName, FFLib.HookName .. identifier, func)
end

function FFLib.Hook.Remove(hookName, identifier)
    hook.Remove(hookName, FFLib.HookName .. identifier)
end

function FFLib.Hook.Call(hookName, tbl, ...)
    hook.Call(hookName, tbl or nil, ...)
end

function FFLib.Hook.Run(hookName, ...)
    return hook.Run(hookName, ...)
end

function FFLib.Hook.SCall(hookName, identifier, ...)
    local hooks = hook.GetTable()[hookName]
    if hooks and hooks[FFLib.HookName .. identifier] then
        return hooks[FFLib.HookName .. identifier](...)
    end
end