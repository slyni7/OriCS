--낙홍엽 여백랑

function c81010300.initial_effect(c)

	c:EnableReviveLimit()
	
	--xyz
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c81010300.xyzcn)
	e0:SetOperation(c81010300.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c81010300.sgcn)
	e1:SetTarget(c81010300.sgtg)
	e1:SetOperation(c81010300.sgop)
	c:RegisterEffect(e1)

	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010300,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCost(c81010300.dsco)
	e2:SetTarget(c81010300.dstg)
	e2:SetOperation(c81010300.dsop)
	c:RegisterEffect(e2)
	
	--copy a effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81010300,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81010300)
	e3:SetCost(c81010300.cpco)
	e3:SetTarget(c81010300.cptg)
	e3:SetOperation(c81010300.cpop)
	c:RegisterEffect(e3)
	
end

--xyz
function c81010300.xyzcnfilter1(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and ( c:GetRank()==5 or c:GetRank()==6 )
	   and c:IsCanBeXyzMaterial(xyzc)
	   and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	   and c:IsSetCard(0xca1)
end
function c81010300.xyzcnfilter2(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
	   and c:GetLevel()==7
end
function c81010300.xyzcn(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if 2<=ct then return false end
	if ct<1 and not og 
				and Duel.IsExistingMatchingCard(c81010300.xyzcnfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
				then return true
			end
	return Duel.CheckXyzMaterial(c,c81010300.xyzcnfilter2,7,2,2,og)
end

function c81010300.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct=-ft
		local b1=Duel.CheckXyzMaterial(c,c81010300.xyzcnfilter2,7,2,2,og)
		local b2=ct<1 
		  and Duel.IsExistingMatchingCard(c81010300.xyzcnfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
		   if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(81010300,2))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=Duel.SelectMatchingCard(tp,c81010300.xyzcnfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
			mg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
			local mg2=mg:GetFirst():GetOverlayGroup()
			if mg2:GetCount()~=0 then
				Duel.Overlay(c,mg2)
			end
			c:SetMaterial(mg)
			Duel.Overlay(c,mg)
		else
			local mg=Duel.SelectXyzMaterial(tp,c,c81010300.xyzcnfilter2,7,2,2)
			c:SetMaterial(mg)
			Duel.Overlay(c,mg)
		end
	end
end

--send to grave
function c81010300.sgcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end

function c81010300.sgtgfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xca1)
end
function c81010300.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81010300.sgtgfilter,tp,LOCATION_DECK,0,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c81010300.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81010300.sgtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--destroy
function c81010300.dscofilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xca1)
end
function c81010300.dsco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81010300.dscofilter,tp,LOCATION_GRAVE,0,1,nil)
			end
	local g=Duel.SelectMatchingCard(tp,c81010300.dscofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c81010300.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsOnField()
			and chkc:IsControler(1-tp)
			and chkc:IsDestructable()
			end
	if chk==0 then return
				Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c81010300.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--copy a effect
function c81010300.cpco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				c:CheckRemoveOverlayCard(tp,1,REASON_COST)
			end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c81010300.cptgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
	   and c:CheckActivateEffect(true,true,false)~=nil
	   and ( c:IsSetCard(0xca1) and c:IsType(TYPE_QUICKPLAY) )
end
function c81010300.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(te,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return
				Duel.IsExistingTarget(c81010300.cptgfilter,tp,LOCATION_GRAVE,0,1,nil)
			end
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e:SetCategory(0)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=Duel.SelectTarget(tp,c81010300.cptgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			local te=g:GetFirst():CheckActivateEffect(true,true,false)
			e:SetLabelObject(te)
			Duel.ClearTargetCard()
			g:GetFirst():CreateEffectRelation(e)
			local tg=te:GetTarget()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			local tc=cg:GetFirst()
			while tc do
				tc:CreateEffectRelation(te)
				tc=cg:GetNext()
			end
end

function c81010300.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te:GetHandler():IsRelateToEffect(e) then
		local op=te:GetOperation()
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=cg:GetFirst()
		while tc do
			tc:ReleaseEffectRelation(te)
			tc=cg:GetNext()
			Duel.BreakEffect()
			Duel.SendtoDeck(cg,nil,2,REASON_EFFECT)
		end
	end
end
