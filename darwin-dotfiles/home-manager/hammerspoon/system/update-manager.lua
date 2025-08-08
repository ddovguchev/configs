-- Update Manager for Hammerspoon
-- Handles system updates with progress tracking and error handling

local M = {}

local config = {
  updatePath = "/Users/dzmitriy/Documents/system/configs/darwin-dotfiles",
  updateCommand = "git pull && sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin -- switch --flake .",
  environment = {
    LC_ALL = "C",
    PATH = "/run/current-system/sw/bin:/etc/profiles/per-user/dzmitriy/bin:/usr/local/bin:/usr/bin:/bin",
  },
  timeout = 300,
  retryAttempts = 3,
}

local updateInProgress = false
local currentUpdateId = nil
local updateHistory = {}

local function log (message, level)
  level = level or "INFO"
  print (string.format ("[UPDATE-MANAGER] [%s] %s", level, message))
end

local function sanitizeOutput (output)
  local cleaned = {}
  for _, line in ipairs (output) do
    if line and line:match ("%S") then
      -- Remove sensitive information
      line = line:gsub ("password%s*[:=]%s*[^%s]+", "password: ***")
      line = line:gsub ("token%s*[:=]%s*[^%s]+", "token: ***")
      table.insert (cleaned, line)
    end
  end
  return cleaned
end

local function formatDuration (seconds)
  if seconds < 60 then
    return string.format ("%.1fs", seconds)
  elseif seconds < 3600 then
    return string.format ("%.1fm", seconds / 60)
  else
    return string.format ("%.1fh", seconds / 3600)
  end
end

function M.startUpdate (notificationManager)
  if updateInProgress then
    log ("Update already in progress", "WARNING")
    return false
  end

  updateInProgress = true
  local startTime = hs.timer.secondsSinceEpoch ()

  log ("Starting system update")

  currentUpdateId = notificationManager.showProgress ("info", "🔄 Starting system update...", 30.0)

  local outputLines = {}
  local errorLines = {}
  local alreadyCompleted = false

  local function completeUpdate (exitCode, errorType)
    if alreadyCompleted then
      return
    end
    alreadyCompleted = true

    updateInProgress = false
    local endTime = hs.timer.secondsSinceEpoch ()
    local duration = endTime - startTime

    notificationManager.hide (currentUpdateId)

    local cleanedOutput = sanitizeOutput (outputLines)
    local cleanedErrors = sanitizeOutput (errorLines)
    local output = #cleanedOutput > 0 and table.concat (cleanedOutput, "\n") or "(no output)"
    local errors = #cleanedErrors > 0 and table.concat (cleanedErrors, "\n") or ""

    local updateRecord = {
      timestamp = startTime,
      duration = duration,
      exitCode = exitCode,
      success = exitCode == 0,
      output = output,
      errors = errors,
      errorType = errorType,
    }
    table.insert (updateHistory, updateRecord)

    if #updateHistory > 10 then
      table.remove (updateHistory, 1)
    end

    if exitCode == 0 then
      notificationManager.success (string.format ("✅ Update completed in %s", formatDuration (duration)), 5.0)
      log (string.format ("Update completed successfully in %s", formatDuration (duration)))
    else
      local errorMsg = errorType or "unknown error"
      notificationManager.error (string.format ("❌ Update failed: %s", errorMsg), 10.0)
      log (string.format ("Update failed with exit code %d: %s", exitCode, errorMsg), "ERROR")
    end
  end

  local task = hs.task.new ("/bin/bash", completeUpdate, function (_, line)
    log ("[STDOUT] " .. line)
    table.insert (outputLines, line)
    return true
  end, function (_, line)
    log ("[STDERR] " .. line)
    table.insert (errorLines, line)
    return true
  end, {
    "-c",
    string.format ("cd '%s' && %s 2>&1", config.updatePath, config.updateCommand),
  })

  task:setEnvironment (config.environment)

  local success = task:start ()
  if not success then
    completeUpdate (-1, "task_start_failed")
    return false
  end

  hs.timer.doAfter (config.timeout, function ()
    if updateInProgress then
      task:terminate ()
      completeUpdate (-1, "timeout")
    end
  end)

  return true
end

function M.isUpdateInProgress ()
  return updateInProgress
end

function M.getUpdateHistory ()
  return hs.fnutils.copy (updateHistory)
end

function M.getLastUpdate ()
  if #updateHistory > 0 then
    return updateHistory[#updateHistory]
  end
  return nil
end

function M.getUpdateStats ()
  local total = #updateHistory
  local successful = 0
  local totalDuration = 0

  for _, record in ipairs (updateHistory) do
    if record.success then
      successful = successful + 1
    end
    totalDuration = totalDuration + record.duration
  end

  return {
    total = total,
    successful = successful,
    failed = total - successful,
    successRate = total > 0 and (successful / total) * 100 or 0,
    averageDuration = total > 0 and totalDuration / total or 0,
  }
end

function M.setConfig (newConfig)
  for key, value in pairs (newConfig) do
    if config[key] then
      config[key] = value
    end
  end
end

function M.getConfig ()
  return hs.fnutils.copy (config)
end

function M.cancelUpdate ()
  if updateInProgress and currentUpdateId then
    log ("Update cancellation requested", "WARNING")
    return true
  end
  return false
end

function M.clearHistory ()
  updateHistory = {}
  log ("Update history cleared")
end

return M
