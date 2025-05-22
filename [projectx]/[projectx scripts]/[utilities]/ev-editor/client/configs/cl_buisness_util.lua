local hasPdAuthCode = nil

-- Register the textbox response callback
RegisterUICallback("ev-editor:stash:enteredAuthCode", function(data, cb)
  cb({ data = {}, meta = { ok = true, message = "done" } })
  exports["ev-ui"]:closeApplication("textbox")
  hasPdAuthCode = true
end)

-- Catch when the textbox is closed without input
AddEventHandler("ev-ui:application-closed", function(name)
  if name ~= "textbox" then return end
  hasPdAuthCode = false
end)

-- Function to prompt for PD auth code with timeout
function getPDAuthCode(timeout)
  timeout = timeout or 10000 -- default to 10 seconds
  hasPdAuthCode = nil

  exports["ev-ui"]:openApplication("textbox", {
    callbackUrl = "ev-editor:stash:enteredAuthCode",
    inputKey = "",
    items = {
      { label = "Auth Code", name = "password", type = "password" },
    },
    show = true,
  })

  local elapsed = 0
  while hasPdAuthCode == nil and elapsed < timeout do
    Wait(10)
    elapsed = elapsed + 10
  end

  if hasPdAuthCode == nil then
    print("[ev-editor] ⚠️ Auth code entry timed out.")
    return false
  end

  return hasPdAuthCode
end

-- Determine if the player is in a PD-related role
function isPD()
  local job = exports["ev-base"]:getModule("LocalPlayer"):getVar("job")
  return job == "police" or job == "judge" or job == "district attorney"
end
