# Rofi + DuckDuckGo

A minimal **Rofi-based web search launcher** that uses **DuckDuckGo bangs** with optional **local overrides**. It provides a single prompt for fast searches without menus, history, or persistent state.

https://github.com/user-attachments/assets/b7f4870d-5f6f-404c-9ad2-eb1ffa14ca0b

## Features

* DuckDuckGo bang support by default
* Local prefix overrides for custom search engines
* Single-input workflow

## Requirements

* rofi
* jq (optional, for URL encoding)

## Installation

```bash
git clone https://github.com/FlareXes/rofi-ddg.git
cd rofi-ddg
chmod +x rofi-ddg.sh
```

(Optional) Install system-wide:

```bash
sudo cp rofi-ddg.sh /usr/local/bin/rofi-ddg
```

## Usage

```bash
rofi-ddg
```

Enter a search prefix followed by a query.

Examples:

* `g linux kernel` → Google search
* `!y neovim tutorial` → YouTube search

`!` doesn't matter.

## Keybindings

For best experience, bind the script to a key combination according to your desktop environment or window manager. E.g.:

### Hyprland

Add the following to your `hyprland.conf`:

```ini
bind = SUPER, SPACE, exec, rofi-ddg
```

## Configuration

### Browser

By default, the script uses `xdg-open`.

You may edit the script to change browser:

````bash
BROWSER="firefox"
```

### Add custom or override bangs

Edit the `BANGS` associative array in the script:

```bash
declare -A BANGS=(
  ["g"]="https://www.google.com/search?q=%s"
  ["y"]="https://www.youtube.com/results?search_query=%s"
  ["gpt"]="https://chat.openai.com/?q=%s"
)
```

* Keys are prefixes typed in the prompt
* Values are URL templates
* `%s` is replaced with the URL-encoded query

*Local overrides take precedence over DuckDuckGo bangs.*

## License

[MIT License](LICENSE).

## Credits

I would like to thank:
- [FlareXes](https://github.com/flarexes) – for brainstorming, prompting, and crazy idea.
- [ChatGPT](https://chat.com) – for actually writing the script and README.md while I drank coffee. ☕
