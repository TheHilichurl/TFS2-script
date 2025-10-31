local RunService, Lighting, Workspace = game:GetService("RunService"), game:GetService("Lighting"), game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass('Terrain')
if Terrain then Terrain.WaterWaveSize, Terrain.WaterWaveSpeed, Terrain.WaterReflectance, Terrain.WaterTransparency = 0,0,0,0 end
Lighting.GlobalShadows, Lighting.FogEnd = false, 9e9
settings().Rendering.QualityLevel = 1
for i,v in pairs(game:GetDescendants()) do
    if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then v.Material, v.Reflectance = "Plastic", 0
    elseif v:IsA("Decal") then v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Fire") or v:IsA("Smoke") then v.Enabled = false end
end
for i,v in pairs(Lighting:GetDescendants()) do
    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") then v.Enabled = false end
end
Workspace.DescendantAdded:Connect(function(child)
    if child:IsA('ForceField') or child:IsA('Sparkles') or child:IsA('Smoke') or child:IsA('Fire') then
        RunService.Heartbeat:Wait() child:Destroy()
    end
end)
