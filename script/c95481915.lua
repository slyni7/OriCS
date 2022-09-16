--인챈트릭스 다인
function c95481915.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c95481915.lcheck)
	c:EnableReviveLimit()
	--copy effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43387895,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,95481915)
	e1:SetTarget(c95481915.copytg)
	e1:SetOperation(c95481915.copyop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c95481915.con2)
	e2:SetValue(c95481915.val2)
	c:RegisterEffect(e2)
	--battle indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c95481915.con2)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--remove overlay replace
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(83880087,2))
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c95481915.rcon)
	e5:SetOperation(c95481915.rop)
	c:RegisterEffect(e5)
end
function c95481915.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return r&REASON_COST>0 and re:IsActivated() and c==rc and c:IsCanRemoveCounter(tp,0x1949,ev,REASON_COST)
end
function c95481915.rop(e,tp,eg,ep,ev,re,r,rp)
	local min=ev&0xffff
	local max=(ev>>16)&0xffff
	local c=e:GetHandler()
	return c:RemoveCounter(tp,0x1949,min,max,REASON_COST)
end
function c95481915.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd49)
end

function c95481915.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c95481915.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c95481915.copyfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c95481915.copyfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c95481915.copyfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,c)
end
function c95481915.matfilter(c)
	return c:IsSetCard(0xd49) and c:IsType(TYPE_MONSTER)
end
function c95481915.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and (tc:IsFaceup() or tc:IsLocation(LOCATION_GRAVE)) then
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(43387895,1))
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCountLimit(1)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e3:SetLabelObject(e1)
			e3:SetLabel(cid)
			e3:SetOperation(c95481915.rstop)
			c:RegisterEffect(e3)
		end
		if tc:IsType(TYPE_XYZ) then
			c:AddCounter(0x1949,1)
		end
	end
end
function c95481915.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function c95481915.nfil2(c,tp)
	return c:GetOwner()==1-tp
end
function c95481915.con2(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=c:GetMaterial()
	return g:IsExists(c95481915.nfil2,1,nil,tp) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c95481915.val2(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end