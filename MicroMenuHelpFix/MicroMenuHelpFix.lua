-- MicroMenuHelpFix/MicroMenuHelpFix.lua
-- Turns on HelpTip's autoEdgeFlipping for the micro menu's callouts, so
-- they show below the menu when it is at the top of the screen.

local ADDON_NAME = ...

--------------------------------------------------
-- Configuration
--------------------------------------------------

local DEBUG = AlniDev and AlniDev.debug[ADDON_NAME] or false

local function DebugPrint(...)
    if DEBUG then print("|cff33ff99" .. ADDON_NAME .. ":|r", ...) end
end

--------------------------------------------------
-- Callouts
--------------------------------------------------

if not (HelpTip and HelpTip.Show and HelpTip.framePool and HelpTip.PointInfo) then return end

hooksecurefunc(HelpTip, "Show", function(self, parent, info)
    if not (info and info.system == "MicroButtons") or info.autoEdgeFlipping then return end

    for frame in self.framePool:EnumerateActive() do
        if frame.info == info then
            local pointInfo = HelpTip.PointInfo[info.targetPoint]
            if not pointInfo then return end
            info.autoEdgeFlipping = true
            frame.flippedTargetPoint = pointInfo.oppositePoint
            -- flipping happens in OnUpdate
            if not frame:GetScript("OnUpdate") then
                frame:SetScript("OnUpdate", function() frame:OnUpdate() end)
            end
            frame:OnUpdate()
            DebugPrint("micro menu callout can flip:", info.text)
            return
        end
    end
end)
