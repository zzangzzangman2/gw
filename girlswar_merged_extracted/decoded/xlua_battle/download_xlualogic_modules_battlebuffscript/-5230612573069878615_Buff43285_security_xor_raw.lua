local n=require("Modules/Battle/BattleUtil")
local a={}
local r=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[6]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return
end
t[6]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local i=0
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local a=nil
if#o>0 then
local e,t=n:FindMostBigAtk(o)
i=t
a=e
end
if a then
local o=t[1]
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43280)
if n then
o=t[2]
ModulesInit.ProcedureNormalBattle.StealFury(e.CurrHeroCtrl,a,t[3],EBattleSrcType.Buff)
end
local n=math.floor(i*o*MillionCoe)
local i=e:GetRound()
local o=t[4]
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
local h=i
local s={HeroAttrId.atkAdd,n}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,h,s)
local t=t[5]
a.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
local o=i
local i={HeroAttrId.atkAdd,-n}
a:AddBuff(e.CurrHeroCtrl,t,o,i)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.ResetData(e,e,e)
end
return r

