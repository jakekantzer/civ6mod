include "TerrainGenerator"

-- Marks Coastal Lowlands for Civ VI XP2
--    These are areas that are susceptible to coastal flooding from XP2 environmental effects

function IsValidCoastalLowland(plot)
	if (plot:IsCoastalLand() == true) then
		if (not plot:IsHills()) then
			if (not plot:IsMountain()) then
				if (not plot:IsNaturalWonder()) then
					return true;
				end
			end
		end
	end
	return false;
end

function IsValidInlandLowland(plot)
	-- For inland chaining: any land tile that isn't a hill, mountain, or natural wonder
	if (not plot:IsWater()) then
		if (not plot:IsHills()) then
			if (not plot:IsMountain()) then
				if (not plot:IsNaturalWonder()) then
					return true;
				end
			end
		end
	end
	return false;
end

function ScoreCoastalLowlandTiles()

	aaScoredTiles = {};
	local iW, iH = Map.GetGridSize();
	for i = 0, (iW * iH) - 1, 1 do
		plot = Map.GetPlotByIndex(i);
		if (plot) then
			if (IsValidCoastalLowland(plot)) then
				local featureType = plot:GetFeatureType();

				local iScore = 0;

			    -- An adjacent volcano or lake is also bad news
				if (GetNumberAdjacentVolcanoes(plot:GetX(), plot:GetY()) > 0) then
					iScore = 0;

				elseif (GetNumberAdjacentLakes(plot:GetX(), plot:GetY()) > 0) then
					iScore = 0;

				-- Marsh is top-priority
				elseif (featureType == g_FEATURE_MARSH) then
					iScore = 1000;

				-- Floodplains are already dangerous, don't include them here
				elseif (featureType == g_FEATURE_FLOODPLAINS or featureType == g_FEATURE_FLOODPLAINS_GRASSLAND or featureType == g_FEATURE_FLOODPLAINS_PLAINS) then
					iScore = 0;

				-- All other tiles are chosen based on the weightings in this section:
				else
					-- Start with a mid-range base Score
					iScore = 500;

					-- Tiles near a River are prioritized heavily (to balance with the up-to-six occurrences of the factors below)
					if (plot:IsRiver()) then
						iScore = iScore + 200;
					end

					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
						if (adjacentPlot ~= nil) then

							local adjFeatureType = adjacentPlot:GetFeatureType();

							-- Tiles near Marsh or Floodplain are prioritized
							if (adjFeatureType == g_FEATURE_MARSH or adjFeatureType == g_FEATURE_FLOODPLAINS or adjFeatureType == g_FEATURE_FLOODPLAINS_GRASSLAND or adjFeatureType == g_FEATURE_FLOODPLAINS_PLAINS) then
								iScore = iScore + 50;
							end

							-- Tiles near Hills or Mountains are deprioritized
							if (adjacentPlot:IsHills() or adjacentPlot:IsMountain()) then
								iScore = iScore - 50;
							end

							-- Tiles with more adjacent Coast tiles are prioritized
							if (adjacentPlot:IsWater()) then

								-- If a Natural Wonder (Dead Sea?) don't allow it
								if (adjacentPlot:IsNaturalWonder()) then
									iScore = 0;
									break;
								else
									iScore = iScore + 50;
								end
							end
						end
					end
				end

				if (iScore > 0) then
					row = {};
					row.MapIndex = i;
					row.Score = iScore;
					table.insert(aaScoredTiles, row);
				end
			end
		end
	end

	return aaScoredTiles;
end

function ScoreFloodableTiles(markedTiles)
	-- Score land tiles for flooding vulnerability
	-- Only includes tiles that are EITHER coastal OR adjacent to already-marked lowlands

	local scoredTiles = {};
	local iW, iH = Map.GetGridSize();

	for i = 0, (iW * iH) - 1, 1 do
		local plot = Map.GetPlotByIndex(i);

		-- Check if this is a valid floodable tile and not already marked
		if (plot and IsValidInlandLowland(plot) and not markedTiles[i]) then
			-- Check if tile is coastal OR adjacent to a marked lowland
			local isCoastal = plot:IsCoastalLand();
			local isAdjacentToLowland = false;

			for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
				local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
				if (adjacentPlot ~= nil) then
					local adjIndex = adjacentPlot:GetIndex();
					if (markedTiles[adjIndex] ~= nil) then
						isAdjacentToLowland = true;
						break;
					end
				end
			end

			-- Only continue if coastal OR adjacent to lowland
			if (isCoastal or isAdjacentToLowland) then
				local featureType = plot:GetFeatureType();
				local iScore = 0;

				-- Exclude tiles near volcanoes or lakes
				if (GetNumberAdjacentVolcanoes(plot:GetX(), plot:GetY()) > 0) then
					iScore = 0;
				elseif (GetNumberAdjacentLakes(plot:GetX(), plot:GetY()) > 0) then
					iScore = 0;
				-- Marsh is highest priority
				elseif (featureType == g_FEATURE_MARSH) then
					iScore = 1000;
				-- Floodplains already flood, exclude them
				elseif (featureType == g_FEATURE_FLOODPLAINS or featureType == g_FEATURE_FLOODPLAINS_GRASSLAND or featureType == g_FEATURE_FLOODPLAINS_PLAINS) then
					iScore = 0;
				-- Score everything else
				else
					-- Base score
					iScore = 500;

					-- Coastal tiles get a bonus (makes them more likely to flood first)
					if (isCoastal) then
						iScore = iScore + 50;
					end

					-- River tiles are vulnerable
					if (plot:IsRiver()) then
						iScore = iScore + 200;
					end

					-- Check adjacencies
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
						if (adjacentPlot ~= nil) then
							local adjIndex = adjacentPlot:GetIndex();
							local adjFeatureType = adjacentPlot:GetFeatureType();

							-- Adjacent to already-marked lowland = more vulnerable
							if (markedTiles[adjIndex] ~= nil) then
								iScore = iScore + 50;
							end

							-- Adjacent marsh/floodplain
							if (adjFeatureType == g_FEATURE_MARSH or adjFeatureType == g_FEATURE_FLOODPLAINS or adjFeatureType == g_FEATURE_FLOODPLAINS_GRASSLAND or adjFeatureType == g_FEATURE_FLOODPLAINS_PLAINS) then
								iScore = iScore + 50;
							end

							-- Adjacent hills/mountains = less vulnerable
							if (adjacentPlot:IsHills() or adjacentPlot:IsMountain()) then
								iScore = iScore - 50;
							end

							-- Adjacent water (ocean/lake)
							if (adjacentPlot:IsWater()) then
								if (adjacentPlot:IsNaturalWonder()) then
									iScore = 0;
									break;
								else
									iScore = iScore + 50;
								end
							end
						end
					end
				end

				if (iScore > 0) then
					local row = {};
					row.MapIndex = i;
					row.Score = iScore;
					table.insert(scoredTiles, row);
				end
			end
		end
	end

	return scoredTiles;
end

function FindTilesAdjacentToLowlands(elevationLevel, markedTiles)
	local adjacentTiles = {};
	local iW, iH = Map.GetGridSize();

	-- Loop through all plots
	for i = 0, (iW * iH) - 1, 1 do
		local plot = Map.GetPlotByIndex(i);
		-- Check if this plot is eligible and not already marked
		-- Use IsValidInlandLowland to allow non-coastal tiles to be marked in rounds 2 and 3
		if (plot and IsValidInlandLowland(plot) and not markedTiles[i]) then
			-- Check all 6 adjacent plots
			for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
				local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
				if (adjacentPlot ~= nil) then
					local adjIndex = adjacentPlot:GetIndex();
					-- Check if adjacent plot was marked at the specified elevation level
					if (markedTiles[adjIndex] == elevationLevel) then
						-- Adjacent to a lowland of the specified elevation!
						table.insert(adjacentTiles, {plot = plot, index = i});
						break; -- Found one, don't need to check other directions
					end
				end
			end
		end
	end

	return adjacentTiles;
end

function MarkCoastalLowlands()
	print("Map Generation - Marking Coastal Lowlands (Fixed-Target Wave Method)");

	-- Get percentage setting
	local numDesiredCoastalLowlandsPercentage = GlobalParameters.CLIMATE_CHANGE_PERCENT_COASTAL_LOWLANDS or 60;

	-- Track which tiles have been marked at which elevation
	local markedTiles = {};

	-- Score coastal tiles to establish base count
	print("Counting coastal tiles for percentage base...");
	local coastalTiles = ScoreCoastalLowlandTiles();
	print("  Found "..tostring(#coastalTiles).." eligible coastal tiles");

	-- Calculate total target based on percentage of coastal tiles
	local totalTarget = math.floor((#coastalTiles * numDesiredCoastalLowlandsPercentage) / 100);
	local target1M = math.floor(totalTarget / 3);
	local target2M = math.floor(totalTarget / 3);
	local target3M = totalTarget - target1M - target2M;  -- Remainder goes to 3M

	print("Target lowlands to mark: "..tostring(totalTarget).." ("..tostring(numDesiredCoastalLowlandsPercentage).."% of "..tostring(#coastalTiles).." coastal)");
	print("  Target per wave: 1M="..tostring(target1M)..", 2M="..tostring(target2M)..", 3M="..tostring(target3M));

	-- WAVE 1: Score coastal tiles and mark best until we hit 1M target
	print("Wave 1: Marking 1M lowlands from coastal tiles...");
	table.sort(coastalTiles, function(a, b) return a.Score > b.Score; end);

	local marked1M = 0;
	for i = 1, math.min(target1M, #coastalTiles), 1 do
		local index = coastalTiles[i].MapIndex;
		TerrainBuilder.AddCoastalLowland(index, 0);
		markedTiles[index] = 0;
		marked1M = marked1M + 1;
	end
	print("  Marked "..tostring(marked1M).." tiles as 1M lowlands");

	-- WAVE 2: Re-score all eligible tiles and mark best until we hit cumulative target (1M + 2M)
	print("Wave 2: Marking 2M lowlands (coastal + adjacent to 1M)...");
	local wave2Tiles = ScoreFloodableTiles(markedTiles);

	if #wave2Tiles > 0 then
		table.sort(wave2Tiles, function(a, b) return a.Score > b.Score; end);

		local marked2M = 0;
		for i = 1, math.min(target2M, #wave2Tiles), 1 do
			local index = wave2Tiles[i].MapIndex;
			TerrainBuilder.AddCoastalLowland(index, 1);
			markedTiles[index] = 1;
			marked2M = marked2M + 1;
		end
		print("  Marked "..tostring(marked2M).." tiles as 2M lowlands");
	else
		print("  No eligible tiles found for 2M");
	end

	-- WAVE 3: Re-score all eligible tiles and mark best until we hit total target
	print("Wave 3: Marking 3M lowlands (coastal + adjacent to 1M or 2M)...");
	local wave3Tiles = ScoreFloodableTiles(markedTiles);

	if #wave3Tiles > 0 then
		table.sort(wave3Tiles, function(a, b) return a.Score > b.Score; end);

		local marked3M = 0;
		for i = 1, math.min(target3M, #wave3Tiles), 1 do
			local index = wave3Tiles[i].MapIndex;
			TerrainBuilder.AddCoastalLowland(index, 2);
			markedTiles[index] = 2;
			marked3M = marked3M + 1;
		end
		print("  Marked "..tostring(marked3M).." tiles as 3M lowlands");
	else
		print("  No eligible tiles found for 3M");
	end

	-- Count totals
	local total1M = 0;
	local total2M = 0;
	local total3M = 0;
	for _, elevation in pairs(markedTiles) do
		if elevation == 0 then
			total1M = total1M + 1;
		elseif elevation == 1 then
			total2M = total2M + 1;
		elseif elevation == 2 then
			total3M = total3M + 1;
		end
	end

	local totalMarked = total1M + total2M + total3M;
	print("Total lowlands marked: "..tostring(totalMarked).."/"..tostring(totalTarget).." (1M: "..tostring(total1M)..", 2M: "..tostring(total2M)..", 3M: "..tostring(total3M)..")");
end
