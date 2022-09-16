--구세의 이상세계 - 레메게톤
function c95481113.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95481113,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c95481113.con2)
	e2:SetTarget(c95481113.tar2)
	e2:SetOperation(c95481113.op2)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0)
	e3:SetTarget(c95481113.efftg)
	e3:SetCountLimit(1,95481113)
	e3:SetCode(95481113)
	c:RegisterEffect(e3)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90351981,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c95481113.thcost)
	e3:SetTarget(c95481113.thtg)
	e3:SetOperation(c95481113.thop)
	c:RegisterEffect(e3)
end
function c95481113.nfil21(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0xd5c)
end
function c95481113.nfil22(c,g,sc)
	if not c:IsReleasable() or g:IsContains(c) or c:IsHasEffect(EFFECT_EXTRA_RELEASE) then
		return false
	end
	local re=c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
	if re then
		local r,ct,f=rele:GetCountLimit()
		if r<1 then
			return false
		end
	else
		return false
	end
	local se={c:IsHasEffect(EFFECT_UNRELEASABLE_SUM)}
	for _,te in ipairs(se) do
		if type(te:GetValue())=='function' then
			if te:GetValue(te,sc) then
				return false
			end
		else
			return false
		end
	end
	return true
end
function c95481113.nval2(c,sc,ma)
	local e3={c:IsHasEffect(EFFECT_TRIPLE_TRIBUTE)}
	if ma>2 then
		for _,te in ipairs(e3) do
			if type(te:GetValue())~='function' or te:GetValue(te,sc) then
				return 0x30001
			end
		end
	end
	local e2={c:IsHasEffect(EFFECT_DOUBLE_TRIBUTE)}
	for _,te in ipairs(e2) do
		if type(te:GetValue())~='function' or te:GetValue(te,sc) then
			return 0x20001
		end
	end
	return 1
end
function c95481113.nfil23(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function c95481113.nfil24(c,tp)
	return c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
end
function c95481113.nfun2(sg,c,tp)
	local mi,ma=c:GetTributeRequirement()
	if c.arsget_tribute then
		mi,ma=c.arsget_tribute,c.arsget_tribute
	end
	if mi<1 then
		mi=ma
	end
	if Duel.GetMZoneCount(tp,sg,tp)<1
		or sg:FilterCount(c95481113.nfil24,nil,tp)>1 then
		return false
	end
	local ct=sg:GetCount()
	return sg:CheckWithSumEqual(c95481113.nval2,mi,ct,ct,c,ma) or sg:CheckWithSumEqual(c95481113.nval2,ma,ct,ct,c,ma)
end
function c95481113.con2(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c95481113.nfil21,tp,LOCATION_GRAVE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c95481113.nfil22,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if c.arsget_tribute then
		mi,ma=c.arsget_tribute,c.arsget_tribute
	end
	if mi<minc then
		mi=minc
	end
	if ma<mi then
		return false
	end
	local res=g:CheckSubGroup(c95481113.nfun2,1,ma,c,tp)
	return ma>0 and res
end
function c95481113.tar2(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi>0 and c:IsSetCard(0xd5c)
end
function c95481113.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c95481113.nfil21,tp,LOCATION_GRAVE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c95481113.nfil22,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if c.arsget_tribute then
		mi,ma=c.arsget_tribute,c.arsget_tribute
	end
	if mi<1 then
		mi=1
	end
	local sg=g:SelectSubGroup(tp,c95481113.nfun2,tp,1,ma,c,tp)
	local remc=sg:Filter(c95481113.nfil24,nil,tp):GetFirst()
	if remc then
		local rele=remc:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
		rele:Reset()
	end
	c:SetMaterial(sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	sg:Sub(rg)
	Duel.Remove(rg,POS_FACEUP,REASON_SUMMON+REASON_MATERIAL)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c95481113.efftg(e,c)
	return c:IsSetCard(0xd5c)
end

function c95481113.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c95481113.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c95481113.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
