local function GetText(event)
    if event == "QUEST_PROGRESS" then
        return GetProgressText()
    end

    if event == "QUEST_GREETING" then
        return GetGreetingText()
    end

    if event == "QUEST_COMPLETE" then
        return GetRewardText()
    end

    if event == "QUEST_DETAIL" then
        return GetQuestText()
    end

    if event == "GOSSIP_SHOW" then
        return GetGossipText()
    end

    return ''
end


local function ShowString()
    local text = UIParent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("CENTER")
    text:SetText("Hello World")

    return text
end


local function HideUI(uiElement)
    uiElement:Hide()
end


local function ShowUI(uiElement)
    uiElement:Show()
end


local function CreateSpritzFrame()
    local parent = QuestFrame.NineSlice

    local ultraFrame = CreateFrame("FRAME", nil, parent, "InsetFrameTemplate")
    ultraFrame:SetSize(200, 100)
    ultraFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, -100)

    ultraFrame.text = ultraFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
    ultraFrame.text:SetPoint("CENTER", ultraFrame, "CENTER")
    ultraFrame.text:SetSize(200, 100)
    ultraFrame.text:SetText("LET'S GOOOOOO")

    return ultraFrame
end


local function GetWordTargetTime(word)
    return 60 / 250
end


local function RunText(uiElement, text)
    local started = false

    -- init the text
    local words = {}
    local wordCount = 0
    for word in string.gmatch(text, "%S+") do
        words[wordCount] = word
        wordCount = wordCount + 1
    end

    -- init the processor
    local currentWordIndex = 0
    local currentWordTime = 0

    local word = words[currentWordIndex]
    local targetWordTime = GetWordTargetTime(word)
    uiElement.text:SetText(word)

    -- init update cycle
    uiElement:SetScript(
        "OnUpdate",
        function(self, elapsed)
            if started then
                if currentWordTime >= targetWordTime then
                    if wordCount <= currentWordIndex + 1 then
                        started = false
                    else
                        currentWordIndex = currentWordIndex + 1
                        currentWordTime = 0
                        
                        word = words[currentWordIndex]
                        targetWordTime = GetWordTargetTime(word)
                        uiElement.text:SetText(word)
                    end
                else
                    currentWordTime = currentWordTime + elapsed
                end
            end
        end
    )

    -- init start action
    uiElement:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            started = not started
        elseif button == "RightButton" then
            -- reset the progress
            currentWordIndex = 0
            currentWordTime = 0

            word = words[currentWordIndex]
            targetWordTime = GetWordTargetTime(word)
            uiElement.text:SetText(word)
        end
    end)
end


local function OnEvent(self, event, ...)
    frame = frame or CreateSpritzFrame()

    local eventsStartingDialog = "QUEST_PROGRESS QUEST_GREETING QUEST_COMPLETE QUEST_DETAIL GOSSIP_SHOW"
    if string.find(eventsStartingDialog, event) then
        questText = GetText(event)

        ShowUI(frame)
        RunText(frame, questText)
    end
    
    local eventsEndingDialog = "QUEST_FINISHED GOSSIP_CLOSED"
    if string.find(eventsEndingDialog, event) then
        HideUI(frame)
    end
end





local f = CreateFrame("Frame")
f:RegisterEvent("QUEST_DETAIL")
f:RegisterEvent("QUEST_GREETING")
f:RegisterEvent("QUEST_PROGRESS")
f:RegisterEvent("GOSSIP_CLOSED")
f:RegisterEvent("QUEST_FINISHED")
f:RegisterEvent("QUEST_COMPLETE")
f:RegisterEvent("GOSSIP_SHOW")
-- f:RegisterEvent("GOSSIP_CONFIRM")
-- f:RegisterEvent("GOSSIP_CONFIRM_CANCEL")
-- f:RegisterEvent("GOSSIP_ENTER_CODE")
f:SetScript("OnEvent", OnEvent)

-- init options
local panel = CreateFrame("Frame")
panel.name = "UltraSpritz"
InterfaceOptions_AddCategory(panel)

local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
title:SetPoint("TOPLEFT")
title:SetText("UltraSpritz")
