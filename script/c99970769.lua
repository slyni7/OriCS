--[ Nosferatu ]
local m=99970769
local cm=_G["c"..m]
function cm.initial_effect(c)

	--링크 소환
	RevLim(c)
	aux.AddLinkProcedure(c,cm.matfilter,1,1)

	--어드밴스 소환
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	--e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ZOMBIE))
	e3:SetValue(POS_FACEUP)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e4:SetCondition(cm.con4)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	
	--일반 소환
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--불멸화
	local e2=MakeEff(c,"FTo","G")
	e2:SetD(m,2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+YuL.dif)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
	--데미지 체크
	aux.GlobalCheck(cm,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end

--데미지 체크
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT~=0 or r&REASON_BATTLE~=0 then
		Duel.RegisterFlagEffect(ep,m,RESET_PHASE+PHASE_END,0,1)
	end
end

--링크 소환
function cm.matfilter(c)
	return c:IsLevelAbove(6) and c:IsLinkRace(RACE_ZOMBIE)
end

--어드밴스 소환
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)~=0
end

--일반 소환
function cm.cost1fil(c,g,e)
	return g:IsContains(c) or c==e:GetHandler()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,cm.cost1fil,1,false,nil,nil,lg,e)
		or not c:IsRace(RACE_SPELLCASTER) end
	if not c:IsRace(RACE_SPELLCASTER) and 
		(not Duel.CheckReleaseGroupCost(tp,cm.cost1fil,1,false,nil,nil,lg,e) or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_SPELLCASTER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	elseif Duel.CheckReleaseGroupCost(tp,cm.cost1fil,1,false,nil,nil,lg,e) then
		local g=Duel.SelectReleaseGroupCost(tp,cm.cost1fil,1,1,false,nil,nil,lg,e)
		Duel.Release(g,REASON_COST)
	else return false
	end
end
function cm.tar1fil(c)
	return c:IsAttribute(ATT_D) and c:IsSummonable(true,nil)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tar1fil,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end

--불멸화
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=2000
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
