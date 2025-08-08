.PHONY: format format-nix format-lua format-json format-yaml switch clean-cache update-all

switch: format
	@echo "Applying nix-darwin configuration..."
	@sudo -E HOME=/Users/dzmitriy nix run --extra-experimental-features 'nix-command flakes' nix-darwin -- switch --flake .
	@echo "Configuration applied successfully!"

update-all: format switch clean-cache
	@echo "Complete update finished successfully!"

format: format-nix format-lua format-json format-yaml format-shell
	@echo "All files formatted successfully!"

format-nix:
	@echo "Formatting Nix files..."
	@if command -v nixpkgs-fmt >/dev/null 2>&1; then \
		find . -name "*.nix" -not -path "./.git/*" -not -path "./node_modules/*" -exec nixpkgs-fmt {} \; >/dev/null 2>&1; \
		echo "Nix files formatted successfully!"; \
	else \
		echo "Warning: nixpkgs-fmt not found. Skipping Nix files."; \
	fi

format-lua:
	@echo "Formatting Lua files..."
	@if command -v stylua >/dev/null 2>&1; then \
		find . -name "*.lua" -not -path "./.git/*" -not -path "./node_modules/*" -exec stylua {} \; >/dev/null 2>&1; \
		echo "Lua files formatted successfully!"; \
	else \
		echo "Warning: stylua not found. Skipping Lua files."; \
	fi

format-json:
	@echo "Formatting JSON files..."
	@if command -v prettier >/dev/null 2>&1; then \
		find . -name "*.json" -not -path "./.git/*" -not -path "./node_modules/*" -exec prettier --write {} \; >/dev/null 2>&1; \
		echo "JSON files formatted successfully!"; \
	else \
		echo "Warning: prettier not found. Skipping JSON files."; \
	fi

format-yaml:
	@echo "Formatting YAML files..."
	@if command -v prettier >/dev/null 2>&1; then \
		find . -name "*.yaml" -not -path "./.git/*" -not -path "./node_modules/*" -exec prettier --write {} \; >/dev/null 2>&1; \
		find . -name "*.yml" -not -path "./.git/*" -not -path "./node_modules/*" -exec prettier --write {} \; >/dev/null 2>&1; \
		echo "YAML files formatted successfully!"; \
	else \
		echo "Warning: prettier not found. Skipping YAML files."; \
	fi

format-shell:
	@echo "Formatting shell scripts..."
	@if command -v shfmt >/dev/null 2>&1; then \
		find . -name "*.sh" -not -path "./.git/*" -not -path "./node_modules/*" -exec shfmt -w {} \; >/dev/null 2>&1; \
		echo "Shell scripts formatted successfully!"; \
	else \
		echo "Warning: shfmt not found. Skipping shell scripts."; \
	fi

clean-cache:
	@echo "Cleaning Nix cache..."
	@nix store gc
	@nix store optimise
	@echo "Nix cache cleaned successfully!"
