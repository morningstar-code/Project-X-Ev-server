Citizen.CreateThread(function()
  exports["ev-polyzone"]:AddBoxZone("gallery_appraisals", vector3(-468.79, 31.6, 46.23), 1.2, 2.2, {
    heading=355,
    minZ=45.03,
    maxZ=47.43,
    data = {
      id = "gallery_appraisals",
    },
  })

  exports["ev-polytarget"]:AddBoxZone("gallery_gemcraft", vector3(-457.81, -47.03, 49.36), 1.4, 0.6, {
    heading=85,
    minZ=48.96,
    maxZ=49.56,
    data = {
      id = "gallery_gemcraft",
    },
  })

  exports['ev-interact']:AddPeekEntryByPolyTarget('gallery_gemcraft', {{
    event = "ev-gallery:gemCraft",
    id = "gallery_gemcraft",
    icon = "fas fa-box-open",
    label = "Gem Crafting"
  }}, { distance = { radius = 3.5 } })

  exports["ev-polytarget"]:AddBoxZone("bar:openFridge", vector3(-491.66, 37.7, 52.41), 1.4, 0.6, {
    heading=357,
    minZ=52.41,
    maxZ=53.41,
    data = {
      id = "gallery_drinks",
    },
  })

  -- Gallery
  exports['ev-polytarget']:AddBoxZone("gallery_jewelry", vector3(-469.01, 36.06, 46.06), 0.7, 2.2, {
    heading=355,
    minZ=46.06,
    maxZ=46.46,
    data = {
      id = 'relics',
    }
  })

  -- Jewelry Store
  exports['ev-polytarget']:AddBoxZone("gallery_jewelry", vector3(-698.09, -904.68, 19.23), 0.7, 1.3, {
    heading=270,
    minZ=19.23,
    maxZ=19.63,
    data = {
      id = 'jewelry',
    }
  })

  exports['ev-interact']:AddPeekEntryByPolyTarget('gallery_jewelry', {{
    event = "ev-gallery:jewelryAction",
    id = "gallery_jewelry",
    icon = "fas fa-ring",
    label = "Jewelry Making"
  }}, {
    distance = { radius = 3.5 },
  })
end)
