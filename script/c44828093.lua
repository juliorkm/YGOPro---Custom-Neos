--Neos, the Neo Space Warrior
function c44828093.initial_effect(c)
	--fusion material
	aux.AddFusionProcCode2(c,c44828093.mfilter1,c44828093.mfilter2,false, false)
	c:EnableReviveLimit()
	--spsummon condition
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c44828093.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,44828093)
	e2:SetCondition(c44828093.spcon)
	e2:SetOperation(c44828093.spop)
	c:RegisterEffect(e2)
	--name
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(89943723)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44828093,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,89943723)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c44828093.setg)
	e4:SetOperation(c44828093.seop)
	c:RegisterEffect(e4)
	--return
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44828093,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c44828093.rettg)
	e5:SetOperation(c44828093.retop)
	c:RegisterEffect(e5)
end
function c44828093.mfilter1(c)
	return c:IsFusionSetCard(0x9) and c:GetLevel()<=7 and c:GetLevel()>0 and not c:IsFusionType(TYPE_XYZ)
end
function c44828093.mfilter2(c)
	return c:IsFusionSetCard(0x1f)
end
function c44828093.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c44828093.spfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c44828093.spfilter1(c,mg,ft)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	local ct=ft
	if c:IsLocation(LOCATION_MZONE) then ct=ct+1 end
	return c:IsSetCard(0x9) and c:GetLevel()<=7 and c:GetLevel()>0 and not c:IsFusionType(TYPE_XYZ) and mg2:IsExists(c44828093.spfilter2,1,nil,ct)
end
function c44828093.spfilter2(c,ft)
	local ct=ft
	if c:IsLocation(LOCATION_MZONE) then ct=ct+1 end
	return c:IsSetCard(0x1f) and ct>0 
end
function c44828093.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-2 then return false end
	local mg=Duel.GetMatchingGroup(c44828093.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return mg:IsExists(c44828093.spfilter1,1,nil,mg,ft)
end
function c44828093.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=Duel.GetMatchingGroup(c44828093.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=mg:FilterSelect(tp,c44828093.spfilter1,1,1,nil,mg,ft)
	local tc1=g1:GetFirst()
	mg:RemoveCard(tc1)
	if tc1:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=mg:FilterSelect(tp,c44828093.spfilter2,1,1,nil,ft)
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c44828093.sefilter(c)
	return c:IsAbleToHand() and (c:IsSetCard(0x1f) or c:IsCode(16616620) or c:IsCode(82639107) or c:IsCode(69270537) or c:IsCode(35255456))
end
function c44828093.setg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil)
			and Duel.IsExistingMatchingCard(c44828093.sefilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c44828093.seop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c44828093.sefilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c44828093.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c44828093.filter(c,e,tp)
	return c:IsSetCard(0x9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44828093.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(c44828093.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(44828093,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c44828093.filter),tp,0x13,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				Duel.SpecialSummonComplete()
			end
		end
	end
end