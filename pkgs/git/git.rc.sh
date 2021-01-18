alias g=git

__git::main() {
  # Download gitignore file from below:
  # Download from https://github.com/github/gitignore/tree/master/Global
  # Place at ~/.gitconfig.d with the .gitignore suffix.
  if ls ~/.gitconfig.d/*.gitignore 2>&1 >/dev/null; then
    cat ~/.gitconfig.d/*.gitignore > ~/.gitconfig.d/gitignore_global
  fi
}
__git::main
