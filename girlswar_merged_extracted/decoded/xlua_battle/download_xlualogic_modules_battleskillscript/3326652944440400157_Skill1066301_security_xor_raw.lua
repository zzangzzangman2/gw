local e=require("Modules/Battle/BattleUtil")
local h=require("Modules/Battle/Formula")
local e={}
local m=e
function e.DoAction(a,n)
local e=a:JudgeSkillPreView(n)
local s=e[11]
local c=e[12]
local u={e[13]}
local d=e[14]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eState,1,nil,s)
local t=t[1]
if(t==nil)then
return nil
end
local i=0
local o=t.HeroBattleInfo:GetBuff(s)
if o then
i=o:GetFloors()
end
a:ReduceFury(n.costMp)
local o=e[1]
if i>0 then
o=o*e[13]*MillionCoe*i
end
local r=h:GetInjureData(a)
local r=r.attackFinalInjureRate*OneMillion
local h=h:GetInjureData(t)
local h=h.attackFinalInjureRate*OneMillion
if r>h then
local o=e[4]
if t.HeroBattleInfo:HasControlBuff()then
o=e[5]
end
local t=(r-h)*o*MillionCoe
local o={
attrId=e[6],
value=t,
}
a:AddAttrValueInCurAttack(o)
local e={
attrId=e[7],
value=t,
}
a:AddAttrValueInCurAttack(e)
end
local r=math.floor(a:GetFinalAtk()*e[8]*MillionCoe)
local h=math.floor(a.HeroBattleInfo:GetMaxHP()*e[9]*MillionCoe)
local l=r+h
local h=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
if#h>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(h,t)
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,n,o,0,l)
local r=o[1]
local o=o[3]
local h=false
if r>t.HeroBattleInfo:GetMaxHP()*e[10]*MillionCoe then
h=true
end
local o=""
if i>=d then
o="removeLock"
elseif i==0 then
if h==false then
o="addLock"
end
else
if h then
o="removeLock"
else
o="addLock"
end
end
if o=="addLock"then
t:AddBuffWithMaxFloor(a,s,c,u,1,d)
elseif o=="removeLock"then
t.HeroBattleInfo:RemoveBuffWithId(s,BuffRemoveType.Expire)
end
local e=e[3]
local o=l+r*e*MillionCoe
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
if#e>0 then
for t=1,#e do
local e=e[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,n,0,0,o)
end
end
return nil
end
return m 
