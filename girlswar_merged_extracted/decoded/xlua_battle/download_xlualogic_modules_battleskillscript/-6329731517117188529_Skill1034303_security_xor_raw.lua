local e={}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local i=e[1]
local a=e[3]
local n=e[4]
local s={e[5]}
t:AddBuff(t,a,n,s)
local s=e[6]
local n=e[7]
local a={e[8]}
t:AddBuff(t,s,n,a)
local n=e[9]
local h=false
local a=0
if(o.skilltype and o.skilltype==1)then
local e=t.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(e)then
a=e*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
t:HpHealthWithNormalSkill(t,t.HeroBattleInfo.MaxHP*n*MillionCoe*(1+a),false,EBattleSrcType.SkillBig)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
if(a.HeroBattleInfo:GetBuff(e[10]))then
i=i+e[11]
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
h=o[2]
local o=e[13]
local n=e[14]
local i={e[15],e[16]}
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eRandom,e[12])
if(s)then
local e={}
for a,t in ipairs(s)do
if(t.HeroBattleInfo:GetBuff(o)==nil)then
table.add(e,t)
end
end
if#e>0 then
local a=RandomMgr:GetBattleRandomWithRange(1,#e)
local e=e[a]
e:AddBuff(t,o,n,i)
end
end
if(h)then
local s=a.HeroBattleInfo:GetBuff(e[10])
if(s)then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eHollow)
if#e>0 then
local a=RandomMgr:GetBattleRandomWithRange(1,#e)
local e=e[a]
e:AddBuff(t,o,n,i,s:GetFloors())
end
end
else
local i=0
local o=a.HeroBattleInfo:GetBuff(e[10])
if(o)then
i=o.floors
end
local o=e[17]
o=o+i*e[18]
a:CheckAddBuff(o,t,e[19],e[20],0)
end
return nil
end
return r

