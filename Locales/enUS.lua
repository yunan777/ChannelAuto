local L = LibStub("AceLocale-3.0"):NewLocale("ChannelAuto", "enUS", true)

if L then
    L["tryJoin"] = function(channelName, tryTime)
        return format("Try to join channel - %s. Try times: %d. ", channelName, tryTime)
    end

    L["successJoin"] = function(channelName)
        return format("Success joining channel - %s. ", channelName)
    end

    L["faildJoinMaxTry"] = function(channelName, maxTry)
        return format("Faild to join channel - %s, too much times tried (%d). ", channelName, maxTry)
    end

    L["leaveChannel"] = function(channelName)
        return format("Leave channel - %s. ", channelName)
    end

    L["options.name"] = "General"
    L["options.enable.name"] = "Enable this addon"

    L["options.channelName.name"] = "Channel full name"

    L["options.maxRetry.name"] = "Max retry times for joining channel: "

    L["options.retryInterval.name"] = "Time between every joining attempt."

    L["options.joinAt.name"] = "Join channel when in: "
    L["options.joinAt.values.none"] = "World"
    L["options.joinAt.values.pvp"] = "Battleground"
    L["options.joinAt.values.arena"] = "Arena"
    L["options.joinAt.values.party"] = "5-man instance"
    L["options.joinAt.values.raid"] = "Raid instance"
    L["options.joinAt.values.scenario"] = "Scenario"

end