local n={
}
local h=n
function n.DoAction(a,n)
local t=a:JudgeSkillPreView(n)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if i==nil or#i==0 then
return nil
end
local e=nil
local o=nil
local s=#i
for t=1,s do
local t=i[t]
local a=t.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
if a>0 then
if o==nil or a>o then
o=a
e=t
elseif a==o and t.HeroId<e.HeroId then
e=t
end
end
end
if e==nil then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eFront)
if t~=nil and#t>0 then
local a=RandomMgr:GetBattleRandomWithRange(1,#t)
e=t[a]
end
end
if e==nil then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local o=math.floor((1-e:CurrHPPer())*10000)
local r=t[1]+o
local s=e.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)>0
local h=t[2]
local i=t[3]
local o={}
e:AddBuff(nil,h,i,o)
local h=t[4]
local i=t[5]
local o={}
for e=6,14 do
table.insert(o,t[e])
end
o[2]=math.floor(a:GetFinalAtk()*t[7]*MillionCoe)
table.insert(o,0)
table.insert(o,0)
e:AddBuff(a,h,i,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,n,r)
if t[19]==1 then
local t=t[15]
local o=a.HeroBattleInfo:GetBuff(t)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddAttackTask(o,a,e.HeroId,s)
end
end
return nil
end
function n.DoPassiveAction(t,e)
local a=t:JudgeSkillPreView(e)
local o=a[15]
local i=a[16]
local e={}
for t=17,19 do
table.insert(e,a[t])
end
table.insert(e,0)
table.insert(e,0)
t:AddBuff(t,o,i,e)
return nil
end
return h

