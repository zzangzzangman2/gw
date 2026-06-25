local e={}
local n=e
function e.GetBuffData(e,i,o,t)
local a={}
for t=o,t,3 do
if e[t+2]then
local e={
buffId=e[t],
buffData={e[t+1],e[t+2]}
}
table.insert(a,e)
end
end
local e=RandomTableWithSeed(a,i)
return e
end
return n

