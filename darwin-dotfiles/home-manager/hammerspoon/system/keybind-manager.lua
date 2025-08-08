local M = {}

local config = {
  debug = false,
  enableLogging = true,
}

local activeBindings = {}
local bindingGroups = {}

local function log (message, level)
  if not config.enableLogging then
    return
  end
  level = level or "INFO"
  print (string.format ("[KEYBIND-MANAGER] [%s] %s", level, message))
end

local function validateModifiers (modifiers)
  local validModifiers = {
    "cmd",
    "alt",
    "ctrl",
    "shift",
    "fn",
    "hyper",
  }

  for _, modifier in ipairs (modifiers) do
    local found = false
    for _, valid in ipairs (validModifiers) do
      if modifier == valid then
        found = true
        break
      end
    end
    if not found then
      log (string.format ("Invalid modifier: %s", modifier), "WARNING")
      return false
    end
  end
  return true
end

-- Core binding functions
function M.bind (modifiers, key, callback, description, group)
  if not validateModifiers (modifiers) then
    return false
  end

  local bindingId = string.format ("%s+%s", table.concat (modifiers, "+"), key)

  if activeBindings[bindingId] then
    log (string.format ("Binding already exists: %s", bindingId), "WARNING")
    return false
  end

  local hotkey = hs.hotkey.bind (modifiers, key, function ()
    if config.debug then
      log (string.format ("Executing binding: %s", bindingId))
    end

    local success, result = pcall (callback)
    if not success then
      log (string.format ("Error executing binding %s: %s", bindingId, result), "ERROR")
    end

    return result
  end)

  -- Store binding information
  activeBindings[bindingId] = {
    hotkey = hotkey,
    modifiers = modifiers,
    key = key,
    callback = callback,
    description = description or "No description",
    group = group or "default",
    enabled = true,
  }

  -- Add to group
  if not bindingGroups[group or "default"] then
    bindingGroups[group or "default"] = {}
  end
  table.insert (bindingGroups[group or "default"], bindingId)

  log (string.format ("Registered binding: %s (%s)", bindingId, description or "No description"))
  return true
end

function M.unbind (modifiers, key)
  local bindingId = string.format ("%s+%s", table.concat (modifiers, "+"), key)

  if not activeBindings[bindingId] then
    log (string.format ("Binding not found: %s", bindingId), "WARNING")
    return false
  end

  local binding = activeBindings[bindingId]
  binding.hotkey:disable ()

  -- Remove from group
  local group = binding.group
  if bindingGroups[group] then
    for i, id in ipairs (bindingGroups[group]) do
      if id == bindingId then
        table.remove (bindingGroups[group], i)
        break
      end
    end
  end

  activeBindings[bindingId] = nil
  log (string.format ("Unregistered binding: %s", bindingId))
  return true
end

function M.enableBinding (modifiers, key)
  local bindingId = string.format ("%s+%s", table.concat (modifiers, "+"), key)

  if not activeBindings[bindingId] then
    return false
  end

  activeBindings[bindingId].hotkey:enable ()
  activeBindings[bindingId].enabled = true
  log (string.format ("Enabled binding: %s", bindingId))
  return true
end

function M.disableBinding (modifiers, key)
  local bindingId = string.format ("%s+%s", table.concat (modifiers, "+"), key)

  if not activeBindings[bindingId] then
    return false
  end

  activeBindings[bindingId].hotkey:disable ()
  activeBindings[bindingId].enabled = false
  log (string.format ("Disabled binding: %s", bindingId))
  return true
end

-- Group management
function M.enableGroup (groupName)
  if not bindingGroups[groupName] then
    log (string.format ("Group not found: %s", groupName), "WARNING")
    return false
  end

  for _, bindingId in ipairs (bindingGroups[groupName]) do
    local binding = activeBindings[bindingId]
    if binding then
      binding.hotkey:enable ()
      binding.enabled = true
    end
  end

  log (string.format ("Enabled group: %s", groupName))
  return true
end

function M.disableGroup (groupName)
  if not bindingGroups[groupName] then
    log (string.format ("Group not found: %s", groupName), "WARNING")
    return false
  end

  for _, bindingId in ipairs (bindingGroups[groupName]) do
    local binding = activeBindings[bindingId]
    if binding then
      binding.hotkey:disable ()
      binding.enabled = false
    end
  end

  log (string.format ("Disabled group: %s", groupName))
  return true
end

function M.getBindings ()
  local result = {}
  for bindingId, binding in pairs (activeBindings) do
    result[bindingId] = {
      modifiers = binding.modifiers,
      key = binding.key,
      description = binding.description,
      group = binding.group,
      enabled = binding.enabled,
    }
  end
  return result
end

function M.getGroups ()
  local result = {}
  for groupName, bindings in pairs (bindingGroups) do
    result[groupName] = {
      count = #bindings,
      bindings = hs.fnutils.copy (bindings),
    }
  end
  return result
end

function M.getBindingInfo (modifiers, key)
  local bindingId = string.format ("%s+%s", table.concat (modifiers, "+"), key)
  local binding = activeBindings[bindingId]

  if not binding then
    return nil
  end

  return {
    modifiers = binding.modifiers,
    key = binding.key,
    description = binding.description,
    group = binding.group,
    enabled = binding.enabled,
  }
end

function M.enableAll ()
  for bindingId, binding in pairs (activeBindings) do
    binding.hotkey:enable ()
    binding.enabled = true
  end
  log ("Enabled all bindings")
end

function M.disableAll ()
  for bindingId, binding in pairs (activeBindings) do
    binding.hotkey:disable ()
    binding.enabled = false
  end
  log ("Disabled all bindings")
end

function M.clearAll ()
  for bindingId, binding in pairs (activeBindings) do
    binding.hotkey:disable ()
  end
  activeBindings = {}
  bindingGroups = {}
  log ("Cleared all bindings")
end

-- Configuration management
function M.setConfig (newConfig)
  for key, value in pairs (newConfig) do
    if config[key] ~= nil then
      config[key] = value
    end
  end
end

function M.getConfig ()
  return hs.fnutils.copy (config)
end

return M
