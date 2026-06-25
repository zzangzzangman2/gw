local e={}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local i=t[1]
local o=t[3]
local n=t[4]
local s={t[5]}
e:AddBuff(e,o,n,s)
local n=t[6]
local s=t[7]
local o={t[8]}
e:AddBuff(e,n,s,o)
local n=t[9]
local o=0
if(a.skilltype and a.skilltype==1)then
local t=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(t)then
o=t*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e:HpHealthWithNormalSkill(e,e.HeroBattleInfo.MaxHP*n*MillionCoe*(1+o),false,EBattleSrcType.SkillBig,EBattleSrcType.SkillBig)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
if(o.HeroBattleInfo:GetBuff(t[10]))then
i=i+t[11]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,a,i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(o)then
local a={}
local i=t[13]
local n=t[14]
local t={t[15],t[16]}
for t,e in ipairs(o)do
if(e.HeroBattleInfo:GetBuff(i)==nil)then
table.add(a,e)
end
end
if#a>0 then
local o=RandomMgr:GetBattleRandomWithRange(1,#a)
local a=a[o]
a:AddBuff(e,i,n,t)
end
end
return nil
end
return s

