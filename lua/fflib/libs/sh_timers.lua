FFLib.Timers = FFLib.Timers or {}
FFLib.Timers.Registered = {}

local function getUniqueID(id, bind)
    if bind and IsValid(bind) and bind.EntIndex then
        return id .. "_" .. bind:EntIndex()
    end
    return id
end

--- Создание своего Таймера.
-- @param id        string         Logical timer name
-- @param delay     number         Seconds between calls
-- @param reps      number         Number of times to fire; 0 = infinite
-- @param callback  function       Function to call each fire
-- @param bind      Entity|nil     Optional entity to auto-remove when invalid
function FFLib.Timers:Create(id, delay, reps, callback, bind)
    if type(callback) ~= "function" then return end

    local now = FFLib.Time:Cur()
    local uid = getUniqueID(id, bind)

    self.Registered[uid] = {
        id        = id,
        bind      = bind,
        callback  = callback,
        delay     = delay or 0,
        reps      = reps or 1,
        remaining = reps or 1,
        nextCall  = now + (delay or 0),
        paused    = false,
        pauseTime = nil,
    }
end

--- Одноразовый таймер, слабый но подойдет для типа КД.
-- @param id        string
-- @param delay     number
-- @param callback  function
-- @param bind      Entity|nil
function FFLib.Timers:Simple(id, delay, callback, bind)
    self:Create(id, delay, 1, callback, bind)
end

--- Удаляем таймер.
-- @param id    string
-- @param bind  Entity|nil
function FFLib.Timers:Remove(id, bind)
    local uid = getUniqueID(id, bind)
    self.Registered[uid] = nil
end

--- Ставим на паузу таймер.
-- @param id    string
-- @param bind  Entity|nil
function FFLib.Timers:Pause(id, bind)
    local uid = getUniqueID(id, bind)
    local t = self.Registered[uid]
    if t and !t.paused then
        t.paused    = true
        t.pauseTime = FFLib.Time:Cur()
    end
end

--- Продолжить после паузы.
-- @param id    string
-- @param bind  Entity|nil
function FFLib.Timers:Resume(id, bind)
    local uid = getUniqueID(id, bind)
    local t = self.Registered[uid]
    if t and t.paused then
        local now = FFLib.Time:Cur()
        local pausedDuration = now - (t.pauseTime or now)
        t.nextCall = (t.nextCall or now) + pausedDuration
        t.paused   = false
        t.pauseTime = nil
    end
end

--- Проверять на наличие таймера.
-- @param id    string
-- @param bind  Entity|nil
-- @return boolean
function FFLib.Timers:Exists(id, bind)
    local uid = getUniqueID(id, bind)
    return self.Registered[uid] ~= nil
end

--- Просмотр скок времени осталось.
-- @param id    string
-- @param bind  Entity|nil
-- @return number|nil
function FFLib.Timers:GetTimeLeft(id, bind)
    local uid = getUniqueID(id, bind)
    local t   = self.Registered[uid]
    if !t then return nil end

    local now = FFLib.Time:Cur()
    return math.max(0, (t.nextCall or now) - now)
end

FFLib.Hook.Add(
    'Think',
    'Timers:Update',
    function()
        local now = FFLib.Time:Cur()
        local toRemove = {}

        for uid, t in pairs(FFLib.Timers.Registered) do
            if t.bind then
                if !IsValid(t.bind) or (t.bind:IsPlayer() and !t.bind:IsConnected()) then
                    table.insert(toRemove, uid)
                    continue
                end
            end

            if !t.paused and now >= (t.nextCall or now) then
                ProtectedCall(function() t.callback() end)

                if t.reps > 0 then
                    t.remaining = t.remaining - 1
                    if t.remaining <= 0 then
                        table.insert(toRemove, uid)
                    else
                        t.nextCall = now + t.delay
                    end
                else
                    t.nextCall = now + t.delay
                end
            end
        end

        for _, uid in ipairs(toRemove) do
            FFLib.Timers.Registered[uid] = nil
        end
    end
)