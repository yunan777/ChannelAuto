local L = LibStub("AceLocale-3.0"):NewLocale("ChannelAuto", "zhCN")

if L then
    L["tryJoin"] = function(channelName, tryTime)
        return format("第%d次尝试加入频道【%s】", tryTime, channelName)
    end

    L["successJoin"] = function(channelName)
        return format("成功加入频道【%s】", channelName)
    end

    L["faildJoinMaxTry"] = function(channelName, maxTry)
        return format("无法加入频道【%s】，已超过最大尝试次数%d。", channelName, maxTry)
    end

    L["leaveChannel"] = function(channelName)
        return format("已离开频道【%s】", channelName)
    end

    L["options.name"] = "通用设置"
    L["options.enable.name"] = "启用此插件"

    L["options.channelName.name"] = "完整频道名"

    L["options.maxRetry.name"] = "加入频道最大尝试次数："

    L["options.retryInterval.name"] = "加入频道尝试间隔时间："

    L["options.joinAt.name"] = "在以下场合(保持)加入频道："
    L["options.joinAt.values.none"] = "世界"
    L["options.joinAt.values.pvp"] = "战场"
    L["options.joinAt.values.arena"] = "竞技场"
    L["options.joinAt.values.party"] = "5人副本"
    L["options.joinAt.values.raid"] = "团队副本"
    L["options.joinAt.values.scenario"] = "场景战役"

end