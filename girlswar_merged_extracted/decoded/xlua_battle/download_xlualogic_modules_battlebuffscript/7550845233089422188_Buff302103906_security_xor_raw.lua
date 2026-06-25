local s=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionSmallSkill(t,a)
local e=t:GetBuffData()
if e[4]>0 then
local n=e[1]
local i=e[2]
local o=e[3]
local e={e[4]}
a:CheckAddBuff(n,t.CurrHeroCtrl,i,o,e)
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for a=1,#o do
local a=o[a]
local o=e[5]
local i=e[6]
local e={e[7],e[8]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.fMostDebuff,nil,nil,nil,nil,{isExludeSelf=false})
if o~=nil then
o.HeroBattleInfo:DispelAllGranBuff(false)
end
local o=a.HeroBattleInfo.CurrHP
local o=math.floor(o*e[9]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(t.CurrHeroCtrl,AttackType.SmallSkill,o)
ModulesInit.ProcedureNormalBattle.StealFury(t.CurrHeroCtrl,a,e[10],EBattleSrcType.SkillSmall,true)
end
return h

