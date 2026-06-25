local e={
bases={},
taskOccupyPosId={},
basesOccupyPosId={},
}
function e:GetPosId(t)
local e=1
while true do
e=math.random(20,400)
if t[e]==nil then
t[e]=true
break
end
end
return e
end
function e:InitData()
if self.initData==true then
return
end
self.taskOccupyPosId={}
self.basesOccupyPosId={}
self.curExp=1
self.curLevel=1
self.nextRefreshTime=TimeUtil.GetServerTimeStamp()+1000*60
self.lastTaskNum=10
self.nextTransferTime=TimeUtil.GetServerTimeStamp()
self.bases={}
local t={984001,984002,984003,985001}
for a=1,59 do
local e={}
e.posId=self:GetPosId(self.basesOccupyPosId)
e.skinId=t[math.random(1,#t)]
e.name="player_name_"..a
e.level=math.random(1,100)
e.playerId=math.random(1111111,999999999)
table.insert(self.bases,e)
end
local e={}
e.posId=self:GetPosId(self.basesOccupyPosId)
e.skinId=984003
e.name=PlayerMgr.PlayerInfo.name
e.level=PlayerMgr.PlayerInfo.level
e.playerId=PlayerMgr.PlayerInfo.uid
table.insert(self.bases,e)
local n={taskId=1,taskDid=41905,status=0,posId=self:GetPosId(self.taskOccupyPosId)}
local s={taskId=2,taskDid=21705,status=1,posId=self:GetPosId(self.taskOccupyPosId)}
local i={taskId=3,taskDid=30501,status=1,posId=self:GetPosId(self.taskOccupyPosId)}
local a={taskId=4,taskDid=30502,status=1,posId=self:GetPosId(self.taskOccupyPosId)}
local e={taskId=5,taskDid=30503,status=0,posId=self:GetPosId(self.taskOccupyPosId)}
local t={taskId=6,taskDid=30504,status=0,posId=self:GetPosId(self.taskOccupyPosId)}
local o={taskId=7,taskDid=40804,status=0,posId=self:GetPosId(self.taskOccupyPosId)}
local h={taskId=8,taskDid=41105,status=0,posId=self:GetPosId(self.taskOccupyPosId)}
local r={taskId=9,taskDid=60001,status=0,posId=self:GetPosId(self.taskOccupyPosId)}
self.tasks={n,s,i,a,e,t,o,h,r}
self.otherTasks={}
for t=20,40 do
local e={}
e.taskId=t
e.taskDid=10201
e.taskType=1
e.name="1111"
e.status=math.random(0,1)
e.posId=self:GetPosId(self.taskOccupyPosId)
table.insert(self.otherTasks,e)
end
local e={
win=true,
beginAckHp=100,
endAckHp=10,
beginDefHp=100,
endDefHp=0,
}
local t={result=e,skinId=973001,targetTaskId=1,beginFlyTime=TimeUtil.GetServerTimeStamp()-10,flyAwayOverTime=TimeUtil.GetServerTimeStamp()+5,battleOverTime=TimeUtil.GetServerTimeStamp()+15,flyOffOverTime=TimeUtil.GetServerTimeStamp()+15}
local a={result=e,skinId=977002,targetTaskId=2,beginFlyTime=TimeUtil.GetServerTimeStamp()-10,flyAwayOverTime=TimeUtil.GetServerTimeStamp()+5,battleOverTime=TimeUtil.GetServerTimeStamp()+13,flyOffOverTime=TimeUtil.GetServerTimeStamp()+18}
local a={result=e,skinId=975001,targetTaskId=3,beginFlyTime=TimeUtil.GetServerTimeStamp()-10,flyAwayOverTime=TimeUtil.GetServerTimeStamp()+5,battleOverTime=TimeUtil.GetServerTimeStamp()+15,flyOffOverTime=TimeUtil.GetServerTimeStamp()+20}
local a={result=e,skinId=974001,targetTaskId=4,beginFlyTime=TimeUtil.GetServerTimeStamp()-10,flyAwayOverTime=TimeUtil.GetServerTimeStamp()+5,battleOverTime=TimeUtil.GetServerTimeStamp()+10,flyOffOverTime=TimeUtil.GetServerTimeStamp()+25}
local e={result=e,skinId=976001,targetTaskId=5,beginFlyTime=TimeUtil.GetServerTimeStamp()-10,flyAwayOverTime=TimeUtil.GetServerTimeStamp()+5,battleOverTime=TimeUtil.GetServerTimeStamp()+8,flyOffOverTime=TimeUtil.GetServerTimeStamp()+16}
self.ships={t}
self.tipLogs={}
self.initData=true
end
function e:TestOnReqGuildRadarInfo()
e:InitData()
local t={}
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.001)
e:AppendCallback(function()
local e={
curExp=self.curExp,
curLevel=self.curLevel,
nextRefreshTime=self.nextRefreshTime,
lastTaskNum=self.lastTaskNum,
nextTransferTime=self.nextTransferTime,
}
e.bases=table.deepCopy(self.bases)
e.ships=table.deepCopy(self.ships)
e.tasks=table.deepCopy(self.tasks)
e.tipLogs=table.deepCopy(self.tipLogs)
e.otherTasks=table.deepCopy(self.otherTasks)
ModulesInit.GuildTerritoryMgr:OnRespGuildRadarInfo(e)
if t.onCompleted then
t.onCompleted(nil,e)
end
end)
return t
end
function e:TestOnReqGuildRadarTransfer(o)
local a={}
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.001)
e:AppendCallback(function()
local t=nil
for e=1,#self.bases do
local e=self.bases[e]
if e.playerId==PlayerMgr.PlayerInfo.uid then
t=e
break
end
end
if t then
t.posId=o
end
local e={}
e.base=table.deepCopy(t)
e.nextTransferTime=TimeUtil.GetServerTimeStamp()+20
ModulesInit.GuildTerritoryMgr:OnRespGuildRadarTransfer(e)
if a.onCompleted then
a.onCompleted(nil,e)
end
end)
return a
end
function e:TestOnReqGuildRadarDispatchShip(e,e)
local e={}
local t=CS.DG.Tweening.DOTween.Sequence()
t:AppendInterval(0.001)
t:AppendCallback(function()
local t={}
ModulesInit.GuildTerritoryMgr:OnRespGuildRadarDispatchShip(t)
if e.onCompleted then
e.onCompleted(nil,t)
end
end)
return e
end
function e:TestOnReqGuildRadarDispatchFinish()
local t={}
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.001)
e:AppendCallback(function()
local a={}
for t,e in pairs(self.tasks)do
if e and e.state==1 then
table.insert(a,e.taskId)
end
end
local e={taskIds=a}
ModulesInit.GuildTerritoryMgr:OnRespGuildRadarDispatchFinish(e)
if t.onCompleted then
t.onCompleted(nil,e)
end
end)
return t
end
function e:TestOnReqGuildRadarAllExistAirship()
local e={}
local t=CS.DG.Tweening.DOTween.Sequence()
t:AppendInterval(0.001)
t:AppendCallback(function()
local t={}
for a,e in pairs(self.ships)do
table.insert(t,e.targetTaskId)
end
local t={taskIds=t}
ModulesInit.GuildTerritoryMgr:OnRespGuildRadarAllExistAirship(t)
if e.onCompleted then
e.onCompleted(nil,t)
end
end)
return e
end
function e:TestOnReqGuildRadarGetTaskReward(a)
local t={}
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.001)
e:AppendCallback(function()
local e={}
e.drops={
{
thingDid=1002,
thingCount=10
}
}
for t=#self.tasks,1,-1 do
local e=self.tasks[t]
if e.status==1 and(a==0 or a==e.taskId)then
table.remove(self.tasks,t)
end
end
e.tasks=self.tasks
e.curExp=self.curExp+1
e.curLevel=self.curLevel+1
ModulesInit.GuildTerritoryMgr:OnRespGuildRadarGetTaskReward(e)
if t.onCompleted then
t.onCompleted(nil,e)
end
end)
return t
end
function e:OnGuildRadarAirshipBattleFinish(t)
for a,e in pairs(self.tasks)do
if e and e.taskId==t then
e.state=1
break
end
end
self:TestOnReqGuildRadarDispatchFinish()
end
function e:OnGuildRadarAirshipReturnFinish(t)
for a,e in pairs(self.ships)do
if e and e.targetTaskId==t then
table.remove(self.ships,a)
break
end
end
self:TestOnReqGuildRadarAllExistAirship()
end
return e 
