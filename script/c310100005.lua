--Generic Trap
local s,id=GetID()
function s.initial_effect(c)
	--setcode
	Duel.LoadScript("momirids.lua",false)
	for i,code in ipairs(archtypes) do
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_SETCODE)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e0:SetRange(LOCATION_ALL)
		e0:SetValue(code)
		c:RegisterEffect(e0)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--Return this card to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.retcon)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end

local function has_value(tab, val)
	for index,value in ipairs(tab) do
		if value==val then
			return true
		end
	end
	return false
end
local alltraptypes=(TYPE_TRAP+TYPE_NORMAL+TYPE_CONTINUOUS+TYPE_COUNTER)
local c_iscode=Card.IsCode
Card.IsCode=function(c,id)
	checktype=Duel.GetCardTypeFromCode(id)
	if c:GetOriginalCode()==310100005 and (checktype&TYPE_TRAP)==TYPE_TRAP and has_value(listedcardnames,id) then return true end
	return c_iscode(c,id)
end
local c_isexacttype=Card.IsExactType
Card.IsExactType=function(c,t)
	if c:GetOriginalCode()==310100005 and (t&alltraptypes)==t then return true end
	return c_isexacttype(c,t)
end
local c_isorigcode=Card.IsOriginalCode
Card.IsOriginalCode=function(c,id)
	checktype=Duel.GetCardTypeFromCode(id)
	if c:GetOriginalCode()==310100005 and (checktype&TYPE_TRAP)==TYPE_TRAP and has_value(listedcardnames,id) then return true end
	return c_isorigcode(c,id)
end
local c_isorigtype=Card.IsOriginalType
Card.IsOriginalType=function(c,t)
	if c:GetOriginalCode()==310100005 and (t&alltraptypes)==t then return true end
	return c_isorigtype(c,t)
end
local c_isprevcode=Card.IsPreviousCodeOnField
Card.IsPreviousCodeOnField=function(c,id)
	checktype=Duel.GetCardTypeFromCode(id)
	if c:GetOriginalCode()==310100005 and (checktype&TYPE_TRAP)==TYPE_TRAP and has_value(listedcardnames,id) then return true end
	return c_isprevcode(c,id)
end
local c_istype=Card.IsType
Card.IsType=function(c,t)
	if c:GetOriginalCode()==310100005 and (t&alltraptypes)==t then return true end
	return c_istype(c,t)
end
local c_isnorsptr=Card.IsNormalSpellTrap
Card.IsNormalSpellTrap=function(c)
	if c:GetOriginalCode()==310100005 then return true end
	return c_isnorsptr(c)
end
local c_iscontsptr=Card.IsContinuousSpellTrap
Card.IsContinuousSpellTrap=function(c)
	if c:GetOriginalCode()==310100005 then return true end
	return c_iscontsptr(c)
end
local c_isconttr=Card.IsContinuousTrap
Card.IsContinuousTrap=function(c)
	if c:GetOriginalCode()==310100005 then return true end
	return c_isconttr(c)
end
local c_iscounttr=Card.IsCounterTrap
Card.IsCounterTrap=function(c)
	if c:GetOriginalCode()==310100005 then return true end
	return c_iscounttr(c)
end
local c_isnortr=Card.IsNormalTrap
Card.IsNormalTrap=function(c)
	if c:GetOriginalCode()==310100005 then return true end
	return c_isnortr(c)
end
