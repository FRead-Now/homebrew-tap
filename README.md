# FRead Homebrew tap

```sh
brew tap marcelinto/tap
brew install fread-now/tap/fread-tools
```

The first line, once per machine, adds fux's own tap: Homebrew installs a
dependency from another tap only once you have tapped it.

Installs FRead's editor tools, fux and FRead's fux snippet library. See
[fread-tools](https://github.com/FRead-Now/fread-tools) for what they are and
how they are matched to the catalog.

`Formula/fread-tools.rb` is written by each release; hand edits are overwritten.
