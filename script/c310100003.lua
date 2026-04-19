--Generic Monster
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
	c:EnableUnsummonable()
	--Must be Special Summoned by a card effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(_,se) return se:IsHasType(EFFECT_TYPE_ACTIONS) end)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_ALL)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
	--pendulum summon
	Pendulum.AddProcedure(c,false)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1160)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,{id,1})
	e4:SetTarget(s.target)
	e4:SetOperation(s.handop)
	c:RegisterEffect(e4)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.handop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
	c:ResetFlagEffect(id)
end

local function has_value(tab, val)
	for index,value in ipairs(tab) do
		if value==val then
			return true
		end
	end
	return false
end
local allmdmontypes=(TYPE_MONSTER+TYPE_NORMAL+TYPE_EFFECT+TYPE_RITUAL+TYPE_SPIRIT+TYPE_UNION+TYPE_GEMINI+TYPE_TUNER+TYPE_FLIP+TYPE_TOON+TYPE_PENDULUM+TYPE_SPSUMMON)
local c_getrace=Card.GetRace
Card.GetRace=function(c)
	if c:IsMonster() and c:GetOriginalCode()==310100003 then return 0xffffff end
	return c_getrace(c)
end
local c_getorigrace=Card.GetOriginalRace
Card.GetOriginalRace=function(c)
	if c:IsMonster() and c:GetOriginalCode()==310100003 then return 0xffffff end
	return c_getorigrace(c)
end
local c_getprevraceonfield=Card.GetPreviousRaceOnField
Card.GetPreviousRaceOnField=function(c)
	if (c:GetPreviousTypeOnField()&TYPE_MONSTER)~=0 and c:GetOriginalCode()==310100003 then return 0xffffff end
	return c_getprevraceonfield(c)
end
local c_israce=Card.IsRace
Card.IsRace=function(c,r)
	if c:IsMonster() and c:GetOriginalCode()==310100003 then return true end
	return c_israce(c,r)
end
local c_isattribute=Card.IsAttribute
Card.IsAttribute=function(c,attr)
	if c:IsMonster() and c:GetOriginalCode()==310100003 then return true end
	return c_isattribute(c,attr)
end
local c_getattribute=Card.GetAttribute
Card.GetAttribute=function(c)
	if c:IsMonster() and c:GetOriginalCode()==310100003 then return 0x7f end
	return c_getattribute(c)
end
local c_getorigattribute=Card.GetOriginalAttribute
Card.GetOriginalAttribute=function(c)
	if c:IsMonster() and c:GetOriginalCode()==310100003 then return 0xffffff end
	return c_getorigattribute(c)
end
local c_attributeexcept=Card.IsAttributeExcept
Card.IsAttributeExcept=function(c,attr)
	if c:IsMonster() and c:GetOriginalCode()==310100003 then return (attr&0x7f)~=0x7f end
	return c_attributeexcept(c)
end
local c_attributeonfield=Card.IsPreviousAttributeOnField
Card.IsPreviousAttributeOnField=function(c,attr)
	if c:IsMonster() and c:GetOriginalCode()==310100003 then return true end
	return c_attributeonfield(c,attr)
end
local c_isattack=Card.IsAttack
Card.IsAttack=function(c,a)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isattack(c,a)
end
local c_isattackabv=Card.IsAttackAbove
Card.IsAttackAbove=function(c,a)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isattackabv(c,a)
end
local c_isattackblw=Card.IsAttackBelow
Card.IsAttackBelow=function(c,a)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isattackblw(c,a)
end
local c_isbaseattack=Card.IsBaseAttack
Card.IsBaseAttack=function(c,a)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isbaseattack(c,a)
end
local c_isbasedefense=Card.IsBaseDefense
Card.IsBaseDefense=function(c,d)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isbasedefense(c,d)
end
local c_iscode=Card.IsCode
Card.IsCode=function(c,id)
	checktype=Duel.GetCardTypeFromCode(id)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and (checktype&TYPE_MONSTER)==TYPE_MONSTER and (checktype&TYPE_EXTRA)==0 and has_value(listedcardnames,id) then return true end
	return c_iscode(c,id)
end
local c_isdef=Card.IsDefense
Card.IsDefense=function(c,d)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isdef(c,d)
end
local c_isdefabv=Card.IsDefenseAbove
Card.IsDefenseAbove=function(c,d)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isdefabv(c,d)
end
local c_isdefblw=Card.IsDefenseBelow
Card.IsDefenseBelow=function(c,d)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isdefblw(c,d)
end
local c_isescale=Card.IsEvenScale
Card.IsEvenScale=function(c)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isescale(c)
end
local c_isexacttype=Card.IsExactType
Card.IsExactType=function(c,t)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and (t&allmdmontypes)==t then return true end
	return c_isexacttype(c,t)
end
local c_islev=Card.IsLevel
Card.IsLevel=function(c,l)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_islev(c,l)
end
local c_islevabv=Card.IsLevelAbove
Card.IsLevelAbove=function(c,l)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_islevabv(c,l)
end
local c_islevblw=Card.IsLevelBelow
Card.IsLevelBelow=function(c,l)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_islevblw(c,l)
end
local c_islevbtwn=Card.IsLevelBetween
Card.IsLevelBetween=function(c,fst,snd)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_islevbtwn(c,fst,snd)
end
local c_isnoneff=Card.IsNonEffectMonster
Card.IsNonEffectMonster=function(c)
	if c:IsMonster() and c:GetOriginalCode()==310100003 then return true end
	return c_isnoneff(c)
end
local c_isoddsc=Card.IsOddScale
Card.IsOddScale=function(c)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isoddsc(c)
end
local c_isorigcode=Card.IsOriginalCode
Card.IsOriginalCode=function(c,id)
	checktype=Duel.GetCardTypeFromCode(id)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and (checktype&TYPE_MONSTER)==TYPE_MONSTER and (checktype&TYPE_EXTRA)==0 and has_value(listedcardnames,id) then return true end
	return c_isorigcode(c,id)
end
local c_isoriglv=Card.IsOriginalLevel
Card.IsOriginalLevel=function(c,l)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isoriglv(c,l)
end
local c_isorigtype=Card.IsOriginalType
Card.IsOriginalType=function(c,t)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and (t&allmdmontypes)==t then return true end
	return c_isorigtype(c,t)
end
local c_isprevcode=Card.IsPreviousCodeOnField
Card.IsPreviousCodeOnField=function(c,id)
	checktype=Duel.GetCardTypeFromCode(id)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and (checktype&TYPE_MONSTER)==TYPE_MONSTER and (checktype&TYPE_EXTRA)==0 and has_value(listedcardnames,id) then return true end
	return c_isprevcode(c,id)
end
local c_isprevtype=Card.IsPreviousTypeOnField
Card.IsPreviousTypeOnField=function(c,t)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and (t&allmdmontypes)==t then return true end
	return c_isprevtype(c,t)
end
local c_isscale=Card.IsScale
Card.IsScale=function(c,sc)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_isscale(c,sc)
end
local c_istxtatk=Card.IsTextAttack
Card.IsTextAttack=function(c,a)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_istxtatk(c,a)
end
local c_istxtdef=Card.IsTextDefense
Card.IsTextDefense=function(c,d)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and c:GetLocation()~=LOCATION_ONFIELD then return true end
	return c_istxtdef(c,d)
end
local c_istype=Card.IsType
Card.IsType=function(c,t)
	if c:IsMonster() and c:GetOriginalCode()==310100003 and (t&allmdmontypes)==t then return true end
	return c_istype(c,t)
end
local c_isnottuner=Card.IsNotTuner
Card.IsNotTuner=function(c,scard,player)
	if c:IsMonster() and c:GetOriginalCode()==310100003 then return true end
	-- Error handling because Card.IsNotTuner is unstable and may be deleted without notice in the future.
	if pcall(c_isnottuner,c,scard,player) then
		return c_isnottuner(c,scard,player)
	else
		return false
	end
end
