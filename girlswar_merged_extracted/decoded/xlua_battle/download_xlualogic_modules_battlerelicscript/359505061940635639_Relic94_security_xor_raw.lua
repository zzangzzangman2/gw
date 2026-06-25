local a={
}
local i=a
function a.DoAction(e,t)
local a=t.attr[1]
local i=t.attr[2]
local o={t.attr[3]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeam(e,BattleHeroType.ourAll)
if(e)then
for n,e in ipairs(e)do
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:AddBuff(e,a,i,o)
end
end
return nil
end
function a.GetTriggerTime()
return RelicTriggerTime.now
end
return i 
