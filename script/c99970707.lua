--[ Nosferatu ]
local m=99970707
local cm=_G["c"..m]
function cm.initial_effect(c)

	YuL.Activate(c)
	
	--소생
	local e1=MakeEff(c,"FTo","S")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(spinel.delay)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)

	--공수 증가
	local e2=MakeEff(c,"F","S")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe1e))
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)

	--Nosferatu
	local e66=MakeEff(c,"STf")
	e66:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e66:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e66:SetCode(EVENT_TO_GRAVE)
	WriteEff(e66,66,"TO")
	c:RegisterEffect(e66)
	
	--데미지 체크
	aux.GlobalCheck(cm,function()
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			cm[0]=0
			cm[1]=0
		end)
	end)

end

--데미지 체크
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT~=0 or r&REASON_BATTLE~=0 then
		cm[ep]=cm[ep]+ev
	end
end

--소생
function cm.confilter(c,tp)
	return c:IsPreviousControler(tp) and (c:IsSetCard(0xe1e) or c:IsPreviousSetCard(0xe1e))
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.confilter,1,nil,tp)
end
function cm.tar1fil(c,e,tp)
	return c:IsSetCard(0xe1e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tar1fil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local g2=Duel.GetMatchingGroup(cm.tar1fil,tp,LOCATION_GRAVE,0,g:GetFirst(),e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and #g2>0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cm[tp]>=4000
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g2:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

--공수 증가
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe1e)
end
function cm.atkval(e,c)
	local ct=Duel.GetMatchingGroupCount(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	if ct>0 then
		return ct*300
	else
		return 0
	end
end

--Nosferatu
function cm.tar66(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function cm.op66(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,1000,REASON_EFFECT)
	Duel.Recover(p,1500,REASON_EFFECT)
end
