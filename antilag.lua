local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Xử lý Terrain
local Terrain = Workspace:FindFirstChildOfClass('Terrain')
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
end

-- Thiết lập Lighting
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
settings().Rendering.QualityLevel = 1

-- Tối ưu hóa các đối tượng hiện có
for i,v in pairs(Workspace:GetDescendants()) do
    if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Fire") or v:IsA("Smoke") then
        v.Enabled = false
    end
end

-- Tắt hiệu ứng trong Lighting
for i,v in pairs(Lighting:GetDescendants()) do
    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") then
        v.Enabled = false
    end
end

-- Xử lý đối tượng mới
Workspace.DescendantAdded:Connect(function(child)
    if child:IsA('ForceField') then
        RunService.Heartbeat:Wait()
        child:Destroy()
    elseif child:IsA('Sparkles') or child:IsA('Smoke') or child:IsA('Fire') then
        child.Enabled = false
    elseif child:IsA("Part") or child:IsA("UnionOperation") or child:IsA("MeshPart") then
        child.Material = "Plastic"
        child.Reflectance = 0
    elseif child:IsA("Decal") then
        child.Transparency = 1
    elseif child:IsA("ParticleEmitter") or child:IsA("Trail") then
        child.Lifetime = NumberRange.new(0)
    end
end)
