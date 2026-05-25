--Duel Rule: Soft Mulligan
--Scripted by TheLetterJ
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.op)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	-- Both players get to mulligan.
	s.mulligan(0)
	s.mulligan(1)
end
function s.mulligan(tp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #hg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,0,#hg,nil)
	if #g>0 and Duel.SendtoDeck(g,tp,SEQ_DECKBOTTOM,REASON_RULE)>0 and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==#g then
		-- Draw cards equal to the number of cards returned to the deck.
		Duel.BreakEffect()
		Duel.Draw(tp,#g,REASON_RULE)
	end
end
