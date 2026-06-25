local e=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(o==nil)then
return nil
end
t:ReduceFury(n.costMp)
local h=e[1]
local a=e[3]
local s=e[4]
local i={e[5]}
o:AddBuff(t,a,s,i)
local i=t.HeroBattleInfo:GetBuff(30105804)
if i then
local a=i:GetFloors()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local n=e[6]
local s=e[7]
local o={e[8],e[9]*a}
t:AddBuff(t,n,s,o)
local s=e[10]
local o=e[11]
local n={e[12],e[13]*a}
t:AddBuff(t,s,o,n)
local o=e[14]
local n=e[15]
local e={e[16],e[17]*a}
t:AddBuff(t,o,n,e)
t.HeroBattleInfo:RemoveBuffWithId(i.buffId,BuffRemoveType.Expire)
end
local a=t.HeroBattleInfo:GetBuff(30105810)
if a==nil and t:CurrHPPer()<e[18]*MillionCoe then
local a=e[19]
local o=e[20]
local e={e[21]}
t:AddBuff(t,a,o,e)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,n,h)
return nil
end
return r

