# FRead Homebrew tap

```sh
brew install marcelinto/tap/fux fread-now/tap/fread-tools
```

fux is named beside fread-tools because it comes from its own tap, and
Homebrew installs a formula from another tap only when you name it: that
taps it and records that you trust it. Later, `brew upgrade` updates both.

Installs FRead's editor tools, fux and FRead's fux snippet library. See
[fread-tools](https://github.com/FRead-Now/fread-tools) for what they are and
how they are matched to the catalog.

`Formula/fread-tools.rb` is written by each release; hand edits are overwritten.
