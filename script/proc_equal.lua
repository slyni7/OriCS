CUSTOMTYPE_EQUAL=0x10
CUSTOMREASON_EQUAL=0x2

EFFECT_MUST_BE_EQUAL_MATERIAL=27182799
EFFECT_EQUAL_CHART=27182798
EFFECT_EQUAL_NOTE=27182797
EFFECT_UPDATE_NOTE=27182796

function Card.GetChart(c)
	local mt=getmetatable(c)
	local ch=mt.EqualChart
	return ch
end
function Card.GetNote(c)
	local mt=getmetatable(c)
	local nt=mt.EqualNote
	local eset1={c:IsHasEffect(EFFECT_UPDATE_NOTE)}
	for _,te in pairs(eset1) do
		local f=te:GetValue()
		if type(f)=="number" then
			nt=nt+f
		else
			nt=nt+f(te,c)
		end
	end
	if nt and nt<0 then
		nt=0
	end
	return nt
end
function Card.IsChart(c,ch)
	return c:GetChart()==ch
end
function Card.IsNote(c,nt)
	return c:GetNote()==nt
end

function Auxiliary.AddEqualProcedure(c,chart,note,f1,f2,min,max,gf)
	local mt=getmetatable(c)
	mt.CardType_Equal=true
	mt.EqualChart=chart
	mt.EqualNote=note
	mt.custom_type=CUSTOMTYPE_EQUAL
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(27182800,0))
	e1:SetCondition(Auxiliary.EqualCondition(f1,f2,min,max,gf))
	e1:SetTarget(Auxiliary.EqualTarget(f1,f2,min,max,gf))
	e1:SetOperation(Auxiliary.EqualOperation(f1,f2,min,max,gf))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(Auxiliary.EqualChartAndNoteOperation)
	Duel.RegisterEffect(e2,0)
	c:SetStatus(STATUS_NO_LEVEL,true)
	return e1
end

function Auxiliary.EqualChartString(chart)
	local id=27182801
	local str=math.min(15,chart)
	return aux.Stringid(id,str)
end
function Auxiliary.EqualNoteString(note)
	local id=27182811
	local str=math.min(15,note)
	return aux.Stringid(id,str)
end

function Auxiliary.EqualChartAndNoteOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cheff=c:IsHasEffect(EFFECT_EQUAL_CHART)
	local nteff=c:IsHasEffect(EFFECT_EQUAL_NOTE)
	local rewrite=false
	if cheff==nil or nteff==nil then
		rewrite=true
	else
		local chval=cheff:GetValue()
		local ntval=nteff:GetValue()
		if chval~=c:GetChart() or ntval~=c:GetNote() then
			cheff:Reset()
			nteff:Reset()
			rewrite=true
		end
	end
	if not rewrite then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUAL_CHART)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(Auxiliary.EqualChartString(c:GetChart()))
	e1:SetValue(c:GetChart())
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUAL_NOTE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetDescription(Auxiliary.EqualNoteString(c:GetNote()))
	e2:SetValue(c:GetNote())
	c:RegisterEffect(e2)
end

function Auxiliary.EqualConditionFilter(c,eqc)
	return c:IsFaceup() --and c:IsCanBeEqualMaterial(eqc)
end

function Auxiliary.EqualCheckGoal(sg,tp,eqc,f1,f2,gf)
	return sg:IsExists(Auxiliary.EqualCheckChartFilter,1,nil,eqc,f1,f2,gf,sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,eqc)>0
end

function Auxiliary.EqualCheckChartFilter(c,eqc,f1,f2,gf,sg)
	if f1 and not f1(c) then
		return false
	end
	if c:GetLevel()~=eqc:GetChart() then
		return false
	end
	local ng=sg:Clone()
	ng:Sub(c)
	if #ng==0 then
		return eqc:GetNote()==0 and (not gf or gf(sg,Group.CreateGroup()))
	end
	local f=f2 or aux.TRUE
	return ng:GetSum(Card.GetLevel)==eqc:GetNote() and ng:FilterCount(f,nil)==#ng and (not gf or gf(Group.CreateGroup(c),ng))
end

function Auxiliary.EqualCondition(f1,f2,min,max,gf)
	return
		function(e,c)
			if c==nil then
				return true
			end
			if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then
				return false
			end
			local tp=c:GetControler()
			local mg=Duel.GetMatchingGroup(Auxiliary.EqualConditionFilter,tp,LOCATION_MZONE,0,nil,c)
			local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_EQUAL_MATERIAL)
			if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then
				return false
			end
			Duel.SetSelectedCard(fg)
			return mg:CheckSubGroup(Auxiliary.EqualCheckGoal,1+min,1+max,tp,c,f1,f2,gf)
		end
end
function Auxiliary.EqualTarget(f1,f2,min,max,gf)
	return
		function(e,tp,eg,ep,ev,re,r,rp,chk,c)
			local mg=Duel.GetMatchingGroup(Auxiliary.EqualConditionFilter,tp,LOCATION_MZONE,0,nil,c)
			local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_EQUAL_MATERIAL)
			Duel.SetSelectedCard(fg)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27182800,1))
			local cancel=Duel.IsSummonCancelable()
			local sg=mg:SelectSubGroup(tp,Auxiliary.EqualCheckGoal,cancel,1+min,1+max,tp,c,f1,f2,gf)
			if sg then
				sg:KeepAlive()
				e:SetLabelObject(sg)
				return true
			else
				return false
			end
		end
end
function Auxiliary.EqualOperation(f1,f2,min,max,gf)
	return
		function(e,tp,eg,ep,ev,re,r,rp,c)
			local g=e:GetLabelObject()
			c:SetMaterial(g)
			Duel.SendtoGrave(g,REASON_MATERIAL)
			local tc=g:GetFirst()
			while tc do
				Duel.RaiseSingleEvent(tc,EVENT_BE_CUSTOM_MATERIAL,e,CUSTOMREASON_EQUAL,tp,tp,0)
				tc=g:GetNext()
			end
			Duel.RaiseEvent(g,EVENT_BE_CUSTOM_MATERIAL,e,CUSTOMREASON_EQUAL,tp,tp,0)
			g:DeleteGroup()
		end
end

--융합 타입 삭제

	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_Equal then
		return bit.bor(type(c),TYPE_FUSION)-TYPE_FUSION
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_Equal then
		return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_Equal then
		return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_Equal then
		return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_Equal then
		if t==TYPE_FUSION then
			return false
		end
		return itype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_Equal then
		if t==TYPE_FUSION then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return iftype(c,t)
end