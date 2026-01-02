function OnWMDDetonated(iX, iY, playerID, eWMD)
	local x = iX;
	local y = iY;
	local player = playerID;

	print("OnWMDDetonated");

	print("WMD DETONATED AT:", x,y, "By:", Locale.Lookup(PlayerConfigurations[player]:GetLeaderName()));
	
	local Plot = Map.GetPlot(x, y);
	
	if (Plot ~= nil) then
		if Plot:IsCity() then
			local City = CityManager.GetCityAt(x, y)
			local Player = City:GetOwner()
			CityManager.DestroyCity(Player, City);
			print("RAZING CITY");
		end
	end
end

function Initialize()
	print("Initializing WMDs script");

	Events.WMDDetonated.Add(OnWMDDetonated);

	print("OK - Setup Complete");
end
Initialize();