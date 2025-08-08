local M = {}

function M.setup ()
  hs.hotkey.bind ({ "cmd", "ctrl" }, 40, function ()
    local path = "/Users/dzmitriy/Documents/system/configs/darwin-dotfiles"

    local notifyId = _G.progressUI.showProgress ("info", "🔁 Running nix-darwin update", 30.0, function () end)

    local outputLines = {}
    local alreadyDone = false

    local function finish (exitCode)
      if alreadyDone then
        return
      end
      alreadyDone = true

      _G.progressUI.hide (notifyId)

      local cleaned = {}
      for _, line in ipairs (outputLines) do
        if line and line:match ("%S") then
          table.insert (cleaned, line)
        end
      end

      local output = #cleaned > 0 and table.concat (cleaned, "n") or "(no output)"

      if exitCode == 0 then
        _G.progressUI.success ("SYSTEM", "✅ Update completed")
      else
        _G.progressUI.error ("SYSTEM", "❌ Update failed")
      end
    end

    local task = hs.task.new ("/bin/bash", function (exitCode)
      finish (exitCode)
      return true
    end, function (_, line)
      print ("[UPDATE]", line)
      table.insert (outputLines, line)
      return true
    end, {
      "-c",
      string.format (
        "cd '%s' && git pull && sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin -- switch --flake . 2>&1",
        path
      ),
    })

    task:setEnvironment ({
      LC_ALL = "C",
      PATH = "/run/current-system/sw/bin:/etc/profiles/per-user/dzmitriy/bin:/usr/local/bin:/usr/bin:/bin",
    })

    task:start ()
  end)
end

return M
