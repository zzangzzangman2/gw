local i={
}
local r=i
function i.DoAction(o,n)
local i=o:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o,BattleHeroType.enemyAll)
if a==nil or#a==0 then
return nil
end
local e=nil
local t=nil
local s=#a
for o=1,s do
local o=a[o]
local a=o.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
if a>0 then
if t==nil or a>t then
t=a
e=o
elseif a==t and o.HeroId<e.HeroId then
e=o
end
end
end
if e==nil then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o,BattleHeroType.eFront)
if t~=nil and#t>0 then
local a=RandomMgr:GetBattleRandomWithRange(1,#t)
e=t[a]
end
end
if e==nil then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local t=math.floor((1-e:CurrHPPer())*10000)
local h=i[1]+t
local s=i[2]
local t=i[3]
local a={}
e:AddBuff(nil,s,t,a)
ModulesInit.ProcedureNormalBattle.SkillHurt(o,e,n,h)
return nil
end
function i.DoPassiveAction(e,e)
return nil
end
return r

