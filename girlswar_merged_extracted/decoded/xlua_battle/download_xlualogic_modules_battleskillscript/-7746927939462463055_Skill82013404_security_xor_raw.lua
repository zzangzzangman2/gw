local o={
}
local s=o
function o.DoAction(t,i,e)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eAttrLow,1,HeroAttrId.hp)
if a==nil or#a==0 then
return nil
end
local a=a[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local n=false
local o=t:GetFinalAtk()
local o=math.floor(o*e[4]*MillionCoe)
if a.HeroBattleInfo.CurrHP<o and e[5]>=RandomMgr:GetBattleRandom()then
n=true
local i=e[6]
local n=e[7]
local o={}
for t=8,15 do
table.insert(o,e[t])
end
table.insert(o,0)
table.insert(o,0)
a:AddBuffAfterRemove(t,i,n,o)
else
local n=e[9]
local i=e[10]
local o={}
for t=11,15 do
table.insert(o,e[t])
end
a:AddBuff(t,n,i,o)
end
local e=e[3]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,e)
if n then
local e=82013491
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,e)
end
return nil
end
function o.GetCanTriggerSkill(e)
if e==BuffTriggerTime.smallRoundEndPetHelpSkill then
return true
end
return false
end
function o.DoPassiveAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local t=t[2]
local a={a.id}
e:AddBuff(e,o,t,a)
return nil
end
return s

