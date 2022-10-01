--영화원 써니파크
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.con3)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.ofil2(c,tp)
	return c:IsSetCard(0xfa1) and c:IsFaceup() and c:IsControler(tp) and c:IsMonster()
end
function s.rescon(sg,e,tp,mg)
	if #mg==2 then
		return mg:FilterCount(Card.IsControler,nil,tp)==1
			and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg,#mg,#mg)
	else
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,sg,2,2)
	end
end
function s.oocon21(rc,tp)
	local cg=(rc:GetColumnGroup()+rc):Filter(Card.IsMonster,nil)
	local tc=cg:GetFirst()
	local eset={}
	while tc do
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e1)
		table.insert(eset,e1)
		tc=cg:GetNext()
	end
	local res=aux.SelectUnselectGroup(cg,Effect.CreateEffect(rc),tp,2,2,s.rescon,0)
	for i=1,#eset do
		eset[i]:Reset()
	end
	return res
end
function s.ooop21(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetOperation(s.oooop213)
		c:CreateEffectRelation(e3)
		Duel.RegisterEffect(e3,1-tp)
		--Duel.RaiseEvent(c,id,e,0,1-tp,1-tp,0)
	end
end
function s.oooop213(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local cg=(c:GetColumnGroup()+c):Filter(Card.IsMonster,nil)
		local tc=cg:GetFirst()
		local eset={}
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e1)
			tc=cg:GetNext()
		end
		local sg=aux.SelectUnselectGroup(cg,e,tp,2,2,s.rescon,1,tp,HINTMSG_FACEUP,s.rescon,nil,true)
		if #sg==2 then
			local syng=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,sg,#sg,#sg)
			if #syng>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local c=syng:Select(tp,1,1,nil):GetFirst()
				Duel.SynchroSummon(tp,c,nil,sg,#sg,#sg)
			end
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SPSUMMON)
		e2:SetLabelObject(eset)
		e2:SetOperation(s.oooop212)
		Duel.RegisterEffect(e2,tp)
	end
	e:Reset()
end
function s.oooop212(e,tp,eg,ep,ev,re,r,rp)
	local eset=e:GetLabelObject()
	for i=1,#eset do
		eset[i]:Reset()
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=re:GetOperation()
	local rc=re:GetHandler()
	if rp~=tp and rc:IsRelateToEffect(re) and rc:IsOnField() and rc:GetColumnGroup():IsExists(s.ofil2,1,nil,tp)
		and not rc:IsImmuneToEffect(e)
		and s.oocon21(rc,tp) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0)) then
		Duel.HintSelection(Group.FromCards(c))
		local newop=function(te,ttp,teg,tep,tev,tre,tr,trp)
			op(te,ttp,teg,tep,tev,tre,tr,trp)
			s.ooop21(te,ttp,teg,tep,tev,tre,tr,trp)
		end
		Duel.ChangeChainOperation(ev,newop)
	end
end
function s.nfil3(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0xfa1) and c:IsFaceup()
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(s.nfil3,nil,tp)==1
end
function s.filter(c,e,tp)
	return c:IsSetCard(0xfa1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp)) then
			return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) then
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
