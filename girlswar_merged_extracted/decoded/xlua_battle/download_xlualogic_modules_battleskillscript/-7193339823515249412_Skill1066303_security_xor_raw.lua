local e=require("Modules/Battle/BattleUtil")
local r=require("Modules/Battle/Formula")
local e={}
local m=e
function e.DoAction(a,n)
local t=a:JudgeSkillPreView(n)
local s=t[11]
local c=t[12]
local u={t[13]}
local l=t[14]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eState,1,nil,s)
local e=e[1]
if(e==nil)then
return nil
end
local i=0
local o=e.HeroBattleInfo:GetBuff(s)
if o then
i=o:GetFloors()
end
a:ReduceFury(n.costMp)
local o=t[1]
if i>0 then
o=o*t[13]*MillionCoe*i
end
local h=r:GetInjureData(a)
local h=h.attackFinalInjureRate*OneMillion
local r=r:GetInjureData(e)
local r=r.attackFinalInjureRate*OneMillion
if h>r then
local o=t[4]
if e.HeroBattleInfo:HasControlBuff()then
o=t[5]
end
local e=(h-r)*o*MillionCoe
local o={
attrId=t[6],
value=e,
}
a:AddAttrValueInCurAttack(o)
local e={
attrId=t[7],
value=e,
}
a:AddAttrValueInCurAttack(e)
end
local h=math.floor(a:GetFinalAtk()*t[8]*MillionCoe)
local r=math.floor(a.HeroBattleInfo:GetMaxHP()*t[9]*MillionCoe)
local d=h+r
local h=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fHollow)
if#h>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(h,e)
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
end
local h={
openAddFury=false
}
e:SetDisableDefRage(true)
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,n,o,0,d)
e:SetDisableDefRage(false)
local r=o[1]
local o=o[3]
local h=false
if r>e.HeroBattleInfo:GetMaxHP()*t[10]*MillionCoe then
h=true
end
local o=""
if i>=l then
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
e:AddBuffWithMaxFloor(a,s,c,u,1,l)
elseif o=="removeLock"then
e.HeroBattleInfo:RemoveBuffWithId(s,BuffRemoveType.Expire)
end
local t=t[3]
local t=d+r*t*MillionCoe
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fHollow)
if#e>0 then
for o=1,#e do
local e=e[o]
local o={
openAddFury=false
}
e:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,n,0,0,t,o)
e:SetDisableDefRage(false)
end
end
return nil
end
return m

