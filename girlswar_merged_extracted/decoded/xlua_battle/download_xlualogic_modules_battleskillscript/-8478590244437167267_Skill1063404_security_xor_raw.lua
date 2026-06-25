local e=require("Modules/Battle/BattleUtil")
local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local i=e[2]
local o={e[3],e[4]}
t:AddBuff(t,a,i,o)
local i=e[5]
local a=e[6]
local o={e[7],e[8]}
t:AddBuff(t,i,a,o)
t.HeroBattleInfo:AddHPAndMaxHPPer(e[9]*MillionCoe)
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function a.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[10]
local n=e[11]
local a={}
for o=12,19 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
if e[12]>=e[13]then
local a=e[17]
local i=e[18]
local o={e[19],e[15]}
t:AddBuff(t,a,i,o)
return{
duration=e[19],
success=true
}
end
return{
duration=0,
success=true
}
end
return s 
