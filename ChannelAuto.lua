local ChannelAuto = LibStub("AceAddon-3.0"):NewAddon("ChannelAuto", "AceTimer-3.0", "AceEvent-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("ChannelAuto", true)

local defaultDB = {
    profile = {
        enable = true,
        channelName = "大脚世界频道",
        maxRetry = 10,
        retryInterval = 2,
        joinAt = {
            none = true,
            pvp = false,
            arena = false,
            party = false,
            raid = false,
            scenario = false,
        },
    }
}

function ChannelAuto:isInChannel()
    return tContains({GetChannelList()}, self.db.channelName)
end

function ChannelAuto:createJoinTask()
    local task = coroutine.create(function(self)
        for i = 1, self.db.maxRetry do
            JoinChannelByName(self.db.channelName)
            SendSystemMessage(L["tryJoin"](self.db.channelName, i))
            coroutine.yield()
            if self:isInChannel() then
                SendSystemMessage(L["successJoin"](self.db.channelName))
                ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, self.db.channelName);
                break
            else
                if i == self.db.maxRetry then
                    SendSystemMessage(L["faildJoinMaxTry"](self.db.channelName, self.db.maxRetry))
                end
            end
        end
    end)
    return task
end

function ChannelAuto:joinChannel()
    self:CancelAllTimers()
    self.joinTask = nil
    self.joinTask = self:createJoinTask()
    self.joinTaskTimer = self:ScheduleRepeatingTimer("timerHandler", self.db.retryInterval)
end

function ChannelAuto:timerHandler()
    if coroutine.status(self.joinTask) == "dead" then
        self.joinTask = nil
        self:CancelTimer(self.joinTaskTimer)
    else
        coroutine.resume(self.joinTask, self)
    end
end

function ChannelAuto:leaveChannel()
    LeaveChannelByName(self.db.channelName)
    SendSystemMessage(L["leaveChannel"](self.db.channelName))
end

function ChannelAuto:PLAYER_ENTERING_WORLD(event, isInitialLogin, isReloadingUi)
    if not self.db.enable then
        return
    end

    local inInstance, instanceType = IsInInstance()
    if self:isInChannel() then
        if not self.db.joinAt[instanceType] then
            self:leaveChannel()
        end
    else
        if self.db.joinAt[instanceType] then
            self:joinChannel()
        end
    end
end

function ChannelAuto:OnInitialize()
    self.dbRaw = LibStub("AceDB-3.0"):New("ChannelAutoDB", defaultDB)
    self.db = self.dbRaw.profile
    self.options = {
        type = "group",
        name = L["options.name"],
        args = {
            enable = {
                order = 10,
                name = L["options.enable.name"],
                type = "toggle",
                width = "full",
                set = function(info, value) self.db.enable = value end,
                get = function(info) return self.db.enable end,
            },

            channelName = {
                order = 20,
                name = L["options.channelName.name"],
                type = "input",
                width = "full",
                set = function(info, value) self.db.channelName = value end,
                get = function(info) return self.db.channelName end,
            },

            maxRetry = {
                order = 30,
                name = L["options.maxRetry.name"],
                type = "range",
                width = 1.5,
                min = 1,
                max = 99,
                step = 1,
                set = function(info, value) self.db.maxRetry = value end,
                get = function(info) return self.db.maxRetry end,
            },

            retryInterval = {
                order = 40,
                name = L["options.retryInterval.name"],
                type = "range",
                width = 1.5,
                min = 1,
                max = 10,
                step = 1,
                set = function(info, value) self.db.retryInterval = value end,
                get = function(info) return self.db.retryInterval end,
            },

            joinAt = {
                order = 50,
                name = L["options.joinAt.name"],
                type = "multiselect",
                values = {
                    none = L["options.joinAt.values.none"],
                    pvp = L["options.joinAt.values.pvp"],
                    arena = L["options.joinAt.values.arena"],
                    party = L["options.joinAt.values.party"],
                    raid = L["options.joinAt.values.raid"],
                    scenario = L["options.joinAt.values.scenario"],
                },
                set = function(info, key, value) self.db.joinAt[key] = value end,
                get = function(info, key) return self.db.joinAt[key] end,
            },

        },
    }
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ChannelAuto", self.options)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ChannelAuto", "ChannelAuto")
end

function ChannelAuto:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end
