--아르스 게티아 - 가미긴
function c95481109.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,95481109+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c95481109.sprcon)
	e2:SetOperation(c95481109.sprop)
	c:RegisterEffect(e2)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95481109,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1)
	e4:SetTarget(c95481109.destg)
	e4:SetOperation(c95481109.desop)
	c:RegisterEffect(e4)
	--dump
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c95481109.op5)
	c:RegisterEffect(e5)
end

function c95481109.nfil11(c,sc,tp)
	return ((c:IsReleasable() and c:IsLocation(LOCATION_HAND+LOCATION_MZONE))
		or (c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_GRAVE)
			and c:IsSetCard(0xd5c) and sc:IsHasEffect(95481113,tp))) and c:IsLevelAbove(1) and c:IsSummonableCard()
end
function c95481109.nfil12(c,tp,g,sg,sc)
	sg:AddCard(c)
	local res=false
	if sg:CheckWithSumGreater(Card.GetLevel,sc:GetLevel()) then
		res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or sg:IsExists(c95481109.nfil13,1,nil,tp)
	else
		res=g:IsExists(c95481109.nfil12,1,sg,tp,g,sg,sc)
	end
	sg:RemoveCard(c)
	return res
end
function c95481109.nfil13(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c95481109.sprcon(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c95481109.nfil11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c,c,tp)
	local sg=Group.CreateGroup()
	return g:IsExists(c95481109.nfil12,1,nil,tp,g,sg,c)
end
function c95481109.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c95481109.nfil11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c,c,tp)
	local sg=Group.CreateGroup()
	while not sg:CheckWithSumGreater(Card.GetLevel,c:GetLevel()) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mg=g:FilterSelect(tp,c95481109.nfil12,1,1,sg,tp,g,sg,c)
		sg:Merge(mg)
	end
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	sg:Sub(rg)
	if #rg>0 then
	local te=c:IsHasEffect(95481113,tp)
	te:UseCountLimit(tp)
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.Release(sg,REASON_COST)
end

function c95481109.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==c and d end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c95481109.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d and d:IsRelateToBattle() then
	local atk=d:GetTextAttack()
		if atk<0 then atk=0 end
		if Duel.Destroy(d,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end

function c95481109.ofil5(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0xd5c)
end
function c95481109.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	if not g:IsExists(c95481109.ofil5,1,nil,tp) then
		return
	end
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,aux.Stringid(95481109,0))
		and Duel.NegateEffect(ev) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_EFFECT)
	end
end