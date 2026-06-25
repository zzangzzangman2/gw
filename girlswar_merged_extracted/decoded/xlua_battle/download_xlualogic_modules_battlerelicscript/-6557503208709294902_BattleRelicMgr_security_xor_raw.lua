local e=1
local t={
BattleRelics={}
}
local e=t
function t.Init()
e.BattleRelics[1]=require('Modules/BattleRelicScript/Relic1')
e.BattleRelics[2]=require('Modules/BattleRelicScript/Relic2')
e.BattleRelics[3]=require('Modules/BattleRelicScript/Relic3')
e.BattleRelics[4]=require('Modules/BattleRelicScript/Relic4')
e.BattleRelics[5]=require('Modules/BattleRelicScript/Relic5')
e.BattleRelics[6]=require('Modules/BattleRelicScript/Relic6')
e.BattleRelics[19]=require('Modules/BattleRelicScript/Relic19')
e.BattleRelics[22]=require('Modules/BattleRelicScript/Relic22')
e.BattleRelics[25]=require('Modules/BattleRelicScript/Relic25')
e.BattleRelics[28]=require('Modules/BattleRelicScript/Relic28')
e.BattleRelics[29]=require('Modules/BattleRelicScript/Relic29')
e.BattleRelics[30]=require('Modules/BattleRelicScript/Relic30')
e.BattleRelics[32]=require('Modules/BattleRelicScript/Relic32')
e.BattleRelics[34]=require('Modules/BattleRelicScript/Relic34')
e.BattleRelics[37]=require('Modules/BattleRelicScript/Relic37')
e.BattleRelics[40]=require('Modules/BattleRelicScript/Relic40')
e.BattleRelics[43]=require('Modules/BattleRelicScript/Relic43')
e.BattleRelics[46]=require('Modules/BattleRelicScript/Relic46')
e.BattleRelics[48]=require('Modules/BattleRelicScript/Relic48')
e.BattleRelics[49]=require('Modules/BattleRelicScript/Relic49')
e.BattleRelics[50]=require('Modules/BattleRelicScript/Relic50')
e.BattleRelics[51]=require('Modules/BattleRelicScript/Relic51')
e.BattleRelics[53]=require('Modules/BattleRelicScript/Relic53')
e.BattleRelics[55]=require('Modules/BattleRelicScript/Relic55')
e.BattleRelics[56]=require('Modules/BattleRelicScript/Relic56')
e.BattleRelics[57]=require('Modules/BattleRelicScript/Relic57')
e.BattleRelics[59]=require('Modules/BattleRelicScript/Relic59')
e.BattleRelics[61]=require('Modules/BattleRelicScript/Relic61')
e.BattleRelics[62]=require('Modules/BattleRelicScript/Relic62')
e.BattleRelics[63]=require('Modules/BattleRelicScript/Relic63')
e.BattleRelics[64]=require('Modules/BattleRelicScript/Relic64')
e.BattleRelics[65]=require('Modules/BattleRelicScript/Relic65')
e.BattleRelics[68]=require('Modules/BattleRelicScript/Relic68')
e.BattleRelics[71]=require('Modules/BattleRelicScript/Relic71')
e.BattleRelics[72]=require('Modules/BattleRelicScript/Relic72')
e.BattleRelics[74]=require('Modules/BattleRelicScript/Relic74')
e.BattleRelics[76]=require('Modules/BattleRelicScript/Relic76')
e.BattleRelics[77]=require('Modules/BattleRelicScript/Relic77')
e.BattleRelics[78]=require('Modules/BattleRelicScript/Relic78')
e.BattleRelics[79]=require('Modules/BattleRelicScript/Relic79')
e.BattleRelics[80]=require('Modules/BattleRelicScript/Relic80')
e.BattleRelics[81]=require('Modules/BattleRelicScript/Relic81')
e.BattleRelics[82]=require('Modules/BattleRelicScript/Relic82')
e.BattleRelics[83]=require('Modules/BattleRelicScript/Relic83')
e.BattleRelics[84]=require('Modules/BattleRelicScript/Relic84')
e.BattleRelics[87]=require('Modules/BattleRelicScript/Relic87')
e.BattleRelics[88]=require('Modules/BattleRelicScript/Relic88')
e.BattleRelics[89]=require('Modules/BattleRelicScript/Relic89')
e.BattleRelics[91]=require('Modules/BattleRelicScript/Relic91')
e.BattleRelics[92]=require('Modules/BattleRelicScript/Relic92')
e.BattleRelics[94]=require('Modules/BattleRelicScript/Relic94')
e.BattleRelics[97]=require('Modules/BattleRelicScript/Relic97')
e.BattleRelics[99]=require('Modules/BattleRelicScript/Relic99')
e.BattleRelics[100]=require('Modules/BattleRelicScript/Relic100')
end
function t.GetRelicScript(t)
local e=e.BattleRelics[t]
if(e==nil)then
return nil
end
return e
end
return t 
