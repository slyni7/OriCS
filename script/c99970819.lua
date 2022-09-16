--Aranea Scarlet Joker
local s,id=GetID()
function s.initial_effect(c)

    --패 특수 소환 + 효과 복사
    local e1=MakeEff(c,"Qo","H")
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCL(1,id)
    WriteEff(e1,1,"NTO")
    c:RegisterEffect(e1)
    
    --묘지 / 제외 존 특수 소환
    local e2=MakeEff(c,"STo")
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e2:SetCode(EVENT_REMOVE)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCL(1,{id,1})
    WriteEff(e2,2,"TO")
    c:RegisterEffect(e2)
    local e21=e2:Clone()
    e21:SetCode(EVENT_TO_GRAVE)
    e21:SetCondition(s.con2)
    c:RegisterEffect(e21)
    
    --몬스터 효과 내성
    local e3=MakeEff(c,"S","M")
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(s.efilter)
    c:RegisterEffect(e3)
    
    --공수 증감
    YuL.AraneaMainEffect(c)
    
end

--패 특수 소환 + 효과 복사
function s.op1fil(c)
    return c:IsSetCard(0xe14) and c:IsAbleToRemove()
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsMainPhase() and
        not Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_TUNER),tp,LOCATION_MZONE,0,1,nil)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cg=Duel.GetMatchingGroup(s.op1fil,tp,LOCATION_EXTRA,0,nil)
    if c:IsRelateToEffect(e) then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
        and #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            local tc=cg:Select(tp,1,1,nil):GetFirst()
            if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
                tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                e1:SetCode(EVENT_PHASE+PHASE_END)
                e1:SetCL(1)
                e1:SetReset(RESET_PHASE+PHASE_END)
                e1:SetLabelObject(tc)
                e1:SetOperation(s.retop)
                Duel.RegisterEffect(e1,tp)
                --Copy Effect                
                local code=tc:GetOriginalCodeRule()
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e2:SetCode(EFFECT_CHANGE_CODE)
                e2:SetValue(code)
                e2:SetReset(RESET_EVENT+RESETS_STANDARD)
                c:RegisterEffect(e2)
                c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
            end
        end
    end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoDeck(e:GetLabelObject(),tp,2,REASON_EFFECT+REASON_RETURN)
end

--묘지 / 제외 존 특수 소환
function s.con2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    aux.ToHandOrElse(c,tp,
        function(sc) return sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end,
        function(sc) Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end,
        aux.Stringid(id,1)
    )
end

--몬스터 효과 내성
function s.efilter(e,te)
    local tc=te:GetHandler()
    local def=e:GetHandler():GetDefense()
    return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
        and (def>tc:GetAttack() or def>tc:GetDefense())
end

