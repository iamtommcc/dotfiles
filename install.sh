#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/iamtommcc/dotfiles.git"

echo "==> Checking Xcode Command Line Tools..."
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install 2>/dev/null || true
  echo "Please install the Xcode command line tools and re-run this script."
  exit 1
fi

echo "==> Checking Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "==> Checking chezmoi..."
if ! command -v chezmoi >/dev/null 2>&1; then
  echo "Installing chezmoi..."
  brew install chezmoi
fi

echo "==> Initializing chezmoi and applying dotfiles..."
chezmoi init --apply "$REPO_URL"

# Now that chezmoi has placed Brewfile and mise config into $HOME, run the rest:
echo "==> Installing Homebrew packages from Brewfile..."
if [ -f "$HOME/Brewfile" ]; then
  brew bundle --file="$HOME/Brewfile"
else
  echo "No Brewfile found at \$HOME/Brewfile"
fi

echo "==> Setting fish to default shell..."
sudo sh -c 'echo /opt/homebrew/bin/fish >> /etc/shells'
chsh -s /opt/homebrew/bin/fish

echo "==> Checking mise..."
if ! command -v mise >/dev/null 2>&1; then
  echo "Installing mise..."
  brew install mise
fi

echo "==> Installing dev tools via mise..."
if [ -f "$HOME/.config/mise/config.toml" ]; then
  mise install
else
  echo "No mise config found in \$HOME"
fi

echo "==> Running mac-setup.sh (if it exists)..."
if [ -x "$HOME/mac-setup.sh" ]; then
  "$HOME/mac-setup.sh"
elif [ -f "$HOME/mac-setup.sh" ]; then
  bash "$HOME/mac-setup.sh"
else
  echo "No mac-setup.sh found in \$HOME; skipping."
fi

echo "==> All done! You may want to restart your terminal."