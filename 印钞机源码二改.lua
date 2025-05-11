local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService") -- 新增输入服务引用

-- 交互别动
local INTERACT_KEY = Enum.KeyCode.E
-- 交互延迟    别动
local INTERACT_DELAY = 0.1 

-- 通知功能
StarterGui:SetCore("SendNotification", {
    Title = "冉自动寻找印钞机", --二改即可，这是通知的标题
    Text = "冉正在为您寻找印钞机...",--二改即可，这是通知的内容
    Icon = "rbxassetid://6031302918",
    Duration = 3
})

local foundPrinter = false
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 寻找印钞机逻辑
for _, container in pairs(game:GetService('Workspace').Game.Entities.ItemPickup:GetChildren()) do
    for _, part in pairs(container:GetChildren()) do
        if part:IsA("MeshPart") or part:IsA("Part") then
            local proximityPrompt = part:FindFirstChildWhichIsA("ProximityPrompt")
            if proximityPrompt and proximityPrompt.ObjectText == "Money Printer" then
                -- 移动玩家到印钞机位置（Y轴+1避免穿模）
                humanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 1, 0)
                
                -- 新增E键模拟交互逻辑
                task.wait(INTERACT_DELAY) -- 等待位置同步
                if proximityPrompt.Enabled then -- 检查交互是否可用
                    -- 模拟按键按下
                    UserInputService:FireInputBegin(INTERACT_KEY, false)
                    task.wait(0.1) -- 保持按下状态（根据实际交互需求调整）
                    -- 模拟按键松开
                    UserInputService:FireInputEnd(INTERACT_KEY, false)
                    
                    StarterGui:SetCore("SendNotification", {
                        Title = "印钞机", 
                        Text = "已通过E键自动交互",
                        Icon = "rbxassetid://6031302918",
                        Duration = 3
                    })
                end
                
                foundPrinter = true
                StarterGui:SetCore("SendNotification", {
                    Title = "印钞机", 
                    Text = "请确认拾取",
                    Icon = "rbxassetid://6031302918",
                    Duration = 5
                })
                break
            end
        end
        if foundPrinter then break end
    end
    if foundPrinter then break end
end

-- 未找到时的处理
if not foundPrinter then
    StarterGui:SetCore("SendNotification", {
        Title = "印钞机", 
        Text = "未找到印钞机，3秒后将更换服务器",
        Icon = "rbxassetid://6031302918",
        Duration = 5
    })
    
    wait(3) --换服时间
    local targetPlaceId = 2820580801 
    if TeleportService:IsTeleportEnabled() then
        TeleportService:Teleport(targetPlaceId, player)
    else
        StarterGui:SetCore("SendNotification", {
            Title = "换服失败", 
            Text = "服务器迁移功能未启用",
            Icon = "rbxassetid://6031302918",
            Duration = 5
        })
    end
end

-- 清理 BillboardGui 的逻辑
wait(0.1)
for _, container in pairs(game:GetService('Workspace').Game.Entities.ItemPickup:GetChildren()) do
    for _, child in pairs(container:GetChildren()) do
        for _, gui in pairs(child:GetChildren()) do
            if gui:IsA("BillboardGui") and gui.Parent then
                gui:Destroy()
            end
        end
    end
end
