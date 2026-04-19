-- Mormir
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.wrappercon,s.effectwrapper)
	--flip at start of the duel
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.flipop2)
	c:RegisterEffect(e1)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	if Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.RegisterFlagEffect(tp,id,0,0,0)
		Duel.LoadScript("momirids.lua",false)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
		Duel.RegisterFlagEffect(tp,id+100,0,0,0)
		Duel.LoadScript("momirids.lua",false)
	end
end

function s.wrappercon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp) and
		(s.flipconcounter(e,tp,eg,ep,ev,re,r,rp) or s.flipconmd(e,tp,eg,ep,ev,re,r,rp) or s.flipconed(e,tp,eg,ep,ev,re,r,rp))
end
function s.effectwrapper(e,tp,eg,ep,ev,re,r,rp)
	local bcounter=s.flipconcounter(e,tp,eg,ep,ev,re,r,rp)
	local bmd=s.flipconmd(e,tp,eg,ep,ev,re,r,rp)
	local bed=s.flipconed(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectEffect(tp,
		{bcounter,aux.Stringid(id,7)},
		{bmd,aux.Stringid(id,8)},
		{bed,aux.Stringid(id,9)})
	if not (bcounter or bmd or bed) then return false end
	if (bcounter and op==1) then
		s.flipopcounter(e,tp,eg,ep,ev,re,r,rp)
	elseif (bmd and op==2) then
		s.flipopmd(e,tp,eg,ep,ev,re,r,rp)
	elseif (bed and op==3) then
		s.flipoped(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.flipconcounter(e,tp,eg,ep,ev,re,r,rp)
	--opt check
	if Duel.GetFlagEffect(tp,id+101)>0 then return end
	--condition
	return Duel.GetFlagEffect(tp,id+100)>0 and aux.CanActivateSkill(tp)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,tp)
		and Duel.GetFlagEffect(tp,id+110)<=12
end
function s.cfilter(c)
	return c:IsDiscardable()
end
function s.flipopcounter(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	--1 flag = 1 counter
	Duel.RegisterFlagEffect(tp,id+110,0,0,0)
	Duel.RegisterFlagEffect(tp,id+101,RESET_PHASE+PHASE_END,0,0)
end
function s.flipconmd(e,tp,eg,ep,ev,re,r,rp)
	--opt check
	if Duel.GetFlagEffect(tp,id+102)>0 then return end
	--condition
	return Duel.GetFlagEffect(tp,id+110)>0 and aux.CanActivateSkill(tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummon(tp)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,tp)
end
function s.flipopmd(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local lev,index=Duel.AnnounceLevel(tp,1,Duel.GetFlagEffect(tp,id+110))
	local ids=mdlevs[lev]
	if not ids then
		Duel.SelectOption(tp,false,aux.Stringid(id,4))
		return
	end
	local n=Duel.GetRandomNumber(1,#ids)
	local sc=Duel.CreateToken(tp,ids[n])
	local startIndex=n
	while not (sc:IsCanBeSpecialSummoned(e,0,tp,true,false) or sc:IsSpecialSummonable()) do
		-- The card cannot be summoned for a reason other than its summoning condition.
		n=n+1
		if n>#ids then n=1 end
		if n==startIndex then
			Duel.SelectOption(tp,false,aux.Stringid(id,4))
			Duel.SendtoDeck(sc,tp,-2,REASON_RULE,nil)
			return
		end
		sc:Recreate(ids[n], nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	if Duel.SpecialSummon(sc,SUMMON_TYPE_SPECIAL,tp,tp,true,false,POS_FACEUP)>0 then
		Duel.RegisterFlagEffect(tp,id+102,RESET_PHASE+PHASE_END,0,0)
	end
end
function s.flipconed(e,tp,eg,ep,ev,re,r,rp)
	--condition
	local fg=Duel.GetMatchingGroup(s.fusfilter,tp,LOCATION_MZONE,0,nil)
	local sg=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil)
	local xg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetFlagEffect(tp,id)>0 and aux.CanActivateSkill(tp)
		and ((sg:IsExists(s.sprfilter1,1,nil,tp,sg,c) and s.canSynchroSummon(tp))
		or (xg:IsExists(s.xyzfilter1,1,nil,tp,xg,c) and s.canXyzSummon(tp)))
end
function s.canSynchroSummon(tp)
	for i,lev in ipairs(slevs) do
		for i2,id in ipairs(lev) do
			if Duel.IsPlayerCanSpecialSummonMonster(tp,id,nil,nil,nil,nil,nil,nil,nil,nil,tp,SUMMON_TYPE_SYNCHRO) then
				return true
			end
		end
	end
	return false
end
function s.canXyzSummon(tp)
	for i,lev in ipairs(xlevs) do
		for i2,id in ipairs(lev) do
			if Duel.IsPlayerCanSpecialSummonMonster(tp,id,nil,nil,nil,nil,nil,nil,nil,nil,tp,SUMMON_TYPE_XYZ) then
				return true
			end
		end
	end
	return false
end
function s.flipoped(e,tp,eg,ep,ev,re,r,rp)
	local syng=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE,0,nil)
	local b1=syng:IsExists(s.sprfilter1,1,nil,tp,syng,c) and s.canSynchroSummon(tp)
	local b2=xyzg:IsExists(s.xyzfilter1,1,nil,tp,xyzg,c) and s.canXyzSummon(tp)
	local op=Duel.SelectEffect(tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)})
	if not (b1 or b2) then return false end
	if (b1 and op==1) then
		local tg=Duel.GetMatchingGroup(s.sprfilter4,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		local tunlev=tc:GetLevel()
		local ntg=Duel.GetMatchingGroup(s.sprfilter3,tp,LOCATION_MZONE,0,nil,tunlev)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local ntc=ntg:Select(tp,1,1,nil):GetFirst()
		local lvsum=tunlev+ntc:GetLevel()
		local sg=Group.FromCards(tc,ntc)
		local ids=slevs[lvsum]
		if not ids then
			Duel.SelectOption(tp,false,aux.Stringid(id,4))
			return
		end
		local n=Duel.GetRandomNumber(1,#ids)
		local sc=Duel.CreateToken(tp,ids[n])
		Duel.SendtoDeck(sc,tp,0,REASON_RULE)
		if not sc:IsSynchroSummonable(sg) then
			Synchro.AddProcedure(sc,nil,1,1,Synchro.NonTuner(nil),1,1)
		end
		local startIndex=n
		while not sc:IsSynchroSummonable(sg) do
			-- The card cannot be summoned for a reason other than its material requirements.
			n=n+1
			if n>#ids then n=1 end
			if n==startIndex then
				Duel.SelectOption(tp,false,aux.Stringid(id,4))
				Duel.SendtoDeck(sc,tp,-2,REASON_RULE,nil)
				return
			end
			sc:Recreate(ids[n], nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
		end
		sc:SetMaterial(sg)
		Duel.SynchroSummon(tp,sc,sg)
	elseif (b2 and op==2) then
		local tg=Duel.GetMatchingGroup(s.xyzfilter1,tp,LOCATION_MZONE,0,nil,tp,xyzg,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		local lev=tc:GetLevel()
		local ntg=Duel.GetMatchingGroup(s.xyzfilter3,tp,LOCATION_MZONE,0,tc,lev)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local ntc=ntg:Select(tp,1,1,nil):GetFirst()
		local sg=Group.FromCards(tc,ntc)
		local ids=xlevs[lev]
		if not ids then
			Duel.SelectOption(tp,false,aux.Stringid(id,4))
			return
		end
		local n=Duel.GetRandomNumber(1,#ids)
		local sc=Duel.CreateToken(tp,ids[n])
		Duel.SendtoDeck(sc,tp,0,REASON_RULE)
		if not sc:IsXyzSummonable(sg) then
			Xyz.AddProcedure(sc,nil,lev,2)
		end
		local startIndex=n
		while not sc:IsXyzSummonable(sg) do
			-- The card cannot be summoned for a reason other than its material requirements.
			n=n+1
			if n>#ids then n=1 end
			if n==startIndex then
				Duel.SelectOption(tp,false,aux.Stringid(id,4))
				Duel.SendtoDeck(sc,tp,-2,REASON_RULE,nil)
				return
			end
			sc:Recreate(ids[n], nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
		end
		sc:SetMaterial(sg)
		Duel.XyzSummon(tp,sc,sg)
	end
end
function s.sprfilter(c)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial() and c:HasLevel()
end
function s.sprfilter1(c,tp,g,sc)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil)
	return s.sprfilter(c) and c:IsType(TYPE_TUNER) and g:IsExists(s.sprfilter2,1,c,tp,c,sc)
end
function s.sprfilter2(c,tp,mc,sc)
	local sg=Group.FromCards(c,mc)
	local lvsum=c:GetLevel()+mc:GetLevel()
	return s.sprfilter(c) and lvsum>=1 and lvsum <=12 and not c:IsType(TYPE_TUNER) and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function s.sprfilter3(c,tunlev)
	local lvsum=tunlev+c:GetLevel()
	return s.sprfilter(c) and lvsum>=1 and lvsum <=12 and not c:IsType(TYPE_TUNER)
end
function s.sprfilter4(c)
	return c:IsType(TYPE_TUNER) and s.sprfilter(c)
end
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsCanBeXyzMaterial() and c:HasLevel() and not c:IsType(TYPE_TOKEN)
end
function s.xyzfilter1(c,tp,g,sc)
	local g=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE,0,nil)
	return s.xyzfilter(c) and g:IsExists(s.xyzfilter2,1,c,tp,c,sc)
end
function s.xyzfilter2(c,tp,mc,sc)
	local sg=Group.FromCards(c,mc)
	local lv=c:GetLevel()
	return s.xyzfilter(c) and lv==mc:GetLevel() and lv>=1 and lv<=13 and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function s.xyzfilter3(c,lv)
	return c:GetLevel()==lv and s.xyzfilter(c)
end

