--Final Draw
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCondition(s.searchcon)
	e1:SetOperation(s.searchop)
	Duel.RegisterEffect(e1,tp)
end
function s.searchcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
		and Duel.GetDrawCount(tp)>0
		and (Duel.IsDuelType(DUEL_1ST_TURN_DRAW) or Duel.GetTurnCount()>1)
end
function s.searchfilter(c)
	return c:IsAbleToHand()
end
function s.searchop(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetDrawCount(tp)
	local lpcards=(Duel.GetLP(tp)-1)//1000+1
	if not dt or dt==0 or dt*lpcards>=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local g=Duel.SelectMatchingCard(tp,s.searchfilter,tp,LOCATION_DECK,0,dt*lpcards,dt*lpcards,nil)
		local tg=g:RandomSelect(1-tp,dt)
		Duel.ShuffleDeck(tp)
		Duel.MoveToDeckTop(tg)
	end
end
--draw overwrite, credit to Edo and AlphaKretin
local ddr=Duel.Draw
Duel.Draw = function(...)
	local tb={...}
	local tp=tb[1]
	local count=tb[2]
	local lpcards=(Duel.GetLP(tp)-1)//1000+1
	if count*lpcards<Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local g=Duel.SelectMatchingCard(tp,s.searchfilter,tp,LOCATION_DECK,0,count*lpcards,count*lpcards,nil)
			local tg=g:RandomSelect(1-tp,count)
			Duel.ShuffleDeck(tp)
			Duel.MoveToDeckTop(tg)
		end
	end
	return ddr(...)
end
