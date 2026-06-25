local e={
warnDids={},
isCheckPopView=true,
isFormEarthRoot=false,
playMainMapId=102002,
playMainSaveId=10200201,
mFlowerServerInfo={},
mFlowerRaceInfo={},
}
function e:Init()
end
function e:setLoginStatus(e)
end
function e:getLoginStatus()
end
function e:setCheckPopView(t)
e.isCheckPopView=t
end
function e:Dispose()
end
function e:synData(e)
end
function e:ReqGuildRankList()
NetManager.Send(ProtoId.PRT_RANK_GUILD_LIST_REQ,{})
end
function e:OnSyncWarnInfo(t)
self.warnDids=t.warnDids
table.sort(self.warnDids,function(t,a)
return e:SortWarnDids(t,a)
end)
EventSystem.SendEvent(CommonEventId.OnSyncWarnInfo)
end
function e:ReqWarnClick(e)
NetManager.Send(ProtoId.PRT_WARN_CLICK_REQ,{warnDid=e})
end
return e 
