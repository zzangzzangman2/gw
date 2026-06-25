local i=require("Modules/Battle/BattleUtil")
local o={
}
local n=o
function o.DoAction(o,t,e)
local t=o:JudgeSkillPreView(t)
local a={}
if e and e.defHeroIds then
for t=1,#e.defHeroIds do
local e=e.defHeroIds[t]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
table.insert(a,e)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for e=1,#a do
local e=a[e]
local n=e:CurrSepsisHPPer()
local a=e.HeroBattleInfo.MaxHP
local a=math.floor(a*t[4]*MillionCoe)
i:ReduceSepsisHp(o,e,a,false,false)
e.HeroBattleInfo:DispelGranBuff(false,t[6])
local a=e:CurrSepsisHPPer()
if(n-a)<t[7]*MillionCoe then
local a=e.HeroBattleInfo.MaxHP
local a=math.floor(a*t[8]*MillionCoe)
e:HpHealthWithBuff(a,EBattleSrcType.Buff,o.HeroId,t[1])
end
end
return nil
end
function o.GetCanTriggerSkill(e)
return false
end
function o.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[3],e[5],0}
t:AddBuff(t,o,i,e)
return nil
end
return n 
