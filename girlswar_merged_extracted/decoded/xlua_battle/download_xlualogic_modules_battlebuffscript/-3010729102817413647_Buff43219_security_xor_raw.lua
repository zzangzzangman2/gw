local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e[1]
local n=e[2]
local i={}
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local t=o:GetBuffData()
t[6]=e[5]
t[7]=e[6]
t[8]=e[7]
t[9]=e[8]
t[10]=e[9]
t[11]=e[10]
t[12]=e[11]
else
i={e[3],e[4],nil,nil,nil}
buffData1[6]=e[5]
buffData1[7]=e[6]
buffData1[8]=e[7]
buffData1[9]=e[8]
buffData1[10]=e[9]
buffData1[11]=e[10]
buffData1[12]=e[11]
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,n,i)
end
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.SearchAndAddTargetBuffLoveMusice(e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

