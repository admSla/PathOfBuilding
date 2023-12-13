describe("TestAttacks", function()
    before_each(function()
        newBuild()
    end)

    teardown(function()
        -- newBuild() takes care of resetting everything in setup()
    end)

    it("creates an item and has the correct crit chance", function()
        assert.are.equals(build.calcsTab.mainOutput.CritChance, 0)
        build.itemsTab:CreateDisplayItemFromRaw("New Item\nMaraketh Bow\nCrafted: true\nPrefix: None\nPrefix: None\nPrefix: None\nSuffix: None\nSuffix: None\nSuffix: None\nQuality: 20\nSockets: G-G-G-G-G-G\nLevelReq: 71\nImplicits: 1\n{tags:speed}10% increased Movement Speed")
        build.itemsTab:AddDisplayItem()
        runCallback("OnFrame")
        assert.are.equals(build.calcsTab.mainOutput.CritChance, 5.5 * build.calcsTab.mainOutput.HitChance / 100)
    end)

    it("creates an item and has the correct crit multi", function()
        assert.are.equals(1.5, build.calcsTab.mainOutput.CritMultiplier)
        build.itemsTab:CreateDisplayItemFromRaw("New Item\nAssassin Bow\nCrafted: true\nPrefix: None\nPrefix: None\nPrefix: None\nSuffix: None\nSuffix: None\nSuffix: None\nQuality: 20\nSockets: G-G-G-G-G-G\nLevelReq: 62\nImplicits: 1\n{tags:damage,critical}{range:0.5}+(15-25)% to Global Critical Strike Multiplier")
        build.itemsTab:AddDisplayItem()
        runCallback("OnFrame")
        assert.are.equals(1.5 + 0.2, build.calcsTab.mainOutput.CritMultiplier)
    end)

    it("correctly converts spell damage per stat to attack damage", function()
        assert.are.equals(0, build.calcsTab.mainEnv.player.modDB:Sum("INC", { flags = ModFlag.Attack }, "Damage"))
        build.itemsTab:CreateDisplayItemFromRaw([[
        New Item
        Coral Amulet
        10% increased attack damage
        10% increased spell damage
        1% increased spell damage per 10 intelligence
        ]])
        build.itemsTab:AddDisplayItem()
        runCallback("OnFrame")
        assert.are.equals(10, build.calcsTab.mainEnv.player.modDB:Sum("INC", { flags = ModFlag.Attack }, "Damage"))
        -- Scion starts with 20 Intelligence
        assert.are.equals(12, build.calcsTab.mainEnv.player.modDB:Sum("INC", { flags = ModFlag.Spell }, "Damage"))

        build.itemsTab:CreateDisplayItemFromRaw([[
        New Item
        Coral Ring
        increases and reductions to spell damage also apply to attacks
        ]])
        build.itemsTab:AddDisplayItem()
        runCallback("OnFrame")
        assert.are.equals(22, build.calcsTab.mainEnv.player.mainSkill.skillModList:Sum("INC", { flags = ModFlag.Attack }, "Damage"))

    end)

    local tolerance = 0.1
    it("rounds down a positive number without decimal places", function()
        assert.is.equal(floor(5.678), 5)
    end)
    
    it("rounds down a negative number without decimal places", function()
    assert.is.equal(floor(-3.456), -4)
    end)

    it("rounds down a positive number with decimal places", function()
    assert.is.near(floor(12.345, 1), 12.3, tolerance)
    end)

    it("rounds down a negative number with decimal places", function()
    assert.is.near(floor(-7.891, 2), -7.89, tolerance)
    end)

    it("should stringify a string", function()
        local result = stringify("Hello, World!")
        assert.is_equal("Hello, World!", result)
      end)
    
      it("should stringify a number", function()
        local result = stringify(42)
        assert.is_equal("42", result)
      end)
    
      it("should stringify a table with string and number keys", function()
        local input = { name = "John", age = 30, city = "New York" }
        local result = stringify(input)
        assert.is_equal("{\n\t[\"age\"] = 30, \n\t[\"city\"] = \"New York\", \n\t[\"name\"] = \"John\", \n}", result)
      end)
    
      it("should stringify a table with nested tables", function()
        local input = {
          person = { name = "Alice", age = 25 },
          location = { city = "Paris", country = "France" }
        }
        local result = stringify(input)
        assert.is_equal("{\n\t[\"location\"] = {\n\t\t[\"city\"] = \"Paris\", \n\t\t[\"country\"] = \"France\", \n\t}, \n\t[\"person\"] = {\n\t\t[\"age\"] = 25, \n\t\t[\"name\"] = \"Alice\", \n\t}, \n}", result)
      end)
    
      it("should handle boolean values", function()
        local input = { isTrue = true, isFalse = false }
        local result = stringify(input)
        assert.is_equal("{\n\t[\"isFalse\"] = false, \n\t[\"isTrue\"] = true, \n}", result)
      end)
    
      it("should handle nested tables with boolean values", function()
        local input = { person = { isAdult = true, hasChildren = false } }
        local result = stringify(input)
        assert.is_equal("{\n\t[\"person\"] = {\n\t\t[\"hasChildren\"] = false, \n\t\t[\"isAdult\"] = true, \n\t}, \n}", result)
      end)
end)