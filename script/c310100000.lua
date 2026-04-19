--Make All Monsters All Types
--Scripted by TheLetterJ, based on the Booster Draft script by edo9300
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.op)
end
function s.op(c)
	--Pre-draw
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end
local c_getrace=Card.GetRace
Card.GetRace=function(c)
	if c:IsMonster() then return 0xffffff end
	return c_getrace(c)
end
local c_getorigrace=Card.GetOriginalRace
Card.GetOriginalRace=function(c)
	if c:IsMonster() then return 0xffffff end
	return c_getorigrace(c)
end
local c_getprevraceonfield=Card.GetPreviousRaceOnField
Card.GetPreviousRaceOnField=function(c)
	if (c:GetPreviousTypeOnField()&TYPE_MONSTER)~=0 then return 0xffffff end
	return c_getprevraceonfield(c)
end
local c_israce=Card.IsRace
Card.IsRace=function(c,r)
	if c:IsMonster() then return true end
	return c_israce(c,r)
end
