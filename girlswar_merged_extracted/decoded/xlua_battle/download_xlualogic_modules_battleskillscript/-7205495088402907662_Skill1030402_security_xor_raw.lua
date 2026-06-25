local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
t.HeroBattleInfo:AddHPAndMaxHPPer(e[1]*MillionCoe)
local o=e[2]
local a=e[3]
t:AddBuff(t,o,a)
local i=e[4]
local o=e[5]
local a=e[12]
if t.CurrBattleTeam.MaxHeroCount<e[13]then
a=e[14]
end
local a={e[6],e[7],e[8],e[9],e[10],e[11],a}
t:AddBuff(t,i,o,a)
if t.CurrBattleTeam.MaxHeroCount>1 then
local a=e[15]
local o=e[16]
local e={e[6],e[17],e[18],e[19],e[20],e[21],}
t:AddBuff(t,a,o,e)
end
return nil
end
return n 
