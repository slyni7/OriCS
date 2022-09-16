--알피스트 로드 보르덴
function c95482119.initial_effect(c)
	--Fusion procedure
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c95482119.ffilter,3,true)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c95482119.sprcon)
	e0:SetOperation(c95482119.sprop)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86361354,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95482119)
	e1:SetCost(c95482119.cost)
	e1:SetTarget(c95482119.target)
	e1:SetOperation(c95482119.operation)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c95482119.splimit)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c95482119.efilter)
	c:RegisterEffect(e3)
end
c95482119.material_setcode=0xd5a
function c95482119.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0xd5a) and c:IsFusionType(TYPE_FUSION) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end

function c95482119.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c95482119.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c95482119.sprfilter1(c,tp,fc)
	return c:IsFusionSetCard(0xd5a) and c:IsFusionType(TYPE_FUSION) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c95482119.sprfilter2,tp,LOCATION_MZONE,0,1,c,tp,fc,c)
end
function c95482119.sprfilter2(c,tp,fc,mc)
	return c:IsFusionSetCard(0xd5a) and c:IsFusionType(TYPE_FUSION) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionAttribute(mc:GetFusionAttribute())
		and Duel.IsExistingMatchingCard(c95482119.sprfilter3,tp,LOCATION_MZONE,0,1,c,tp,fc,mc,c)
end
function c95482119.sprfilter3(c,tp,fc,mc1,mc2)
	local g=Group.FromCards(c,mc1,mc2)
	return c:IsFusionSetCard(0xd5a) and c:IsFusionType(TYPE_FUSION) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) 
		and not c:IsFusionAttribute(mc1:GetFusionAttribute()) and not c:IsFusionAttribute(mc2:GetFusionAttribute()) and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c95482119.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c95482119.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c95482119.sprfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c95482119.sprfilter3,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst(),g2:GetFirst())
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SendtoGrave(g1,REASON_COST)
end

function c95482119.cfilter(c)
	local rc=c:GetAttribute()
	return rc~=0 and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c95482119.dfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,rc)
end
function c95482119.dfilter(c,rc)
	return c:IsFaceup() and c:IsAttribute(rc) and c:IsAbleToDeck()
end
function c95482119.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95482119.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95482119.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c95482119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c95482119.dfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c95482119.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95482119.dfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c95482119.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActivated()
end
function c95482119.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end