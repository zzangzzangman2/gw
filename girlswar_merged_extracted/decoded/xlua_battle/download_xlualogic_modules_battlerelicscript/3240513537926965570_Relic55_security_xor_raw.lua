local t={
}
local a=t
function t.DoAction(a,e)
local o=e.attr[1]
local t=e.attr[2]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeam(a,BattleHeroType.eAttrHigh,1,HeroAttrId.atk)
if(e)then
for a,e in ipairs(e)do
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:AddBuff(e,o,t,nil)
end
end
return nil
end
function t.GetTriggerTime()
return RelicTriggerTime.now
end
return a 
