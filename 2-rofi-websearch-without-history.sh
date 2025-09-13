#!/usr/bin/env bash

BROWSER="xdg-open"

# --- Engine Definitions ---
declare -A ENGINES=(
    # General search
    ["Google"]="https://www.google.com/search?q=%s"
    ["Bing"]="https://www.bing.com/search?q=%s"
    ["DuckDuckGo"]="https://duckduckgo.com/?q=%s"
    ["Startpage"]="https://www.startpage.com/sp/search?q=%s"

    # Video / streaming
    ["YouTube"]="https://www.youtube.com/results?search_query=%s"
    ["Vimeo"]="https://vimeo.com/search?q=%s"

    # AI / Chat
    ["ChatGPT"]="https://chat.openai.com/?q=%s"
    ["Perplexity"]="https://www.perplexity.ai/search?q=%s"
    ["Microsoft Copilot"]="https://copilot.microsoft.com/?q=%s"

    # Code / technical
    ["GitHub"]="https://github.com/search?q=%s"
    ["StackOverflow"]="https://stackoverflow.com/search?q=%s"

    # Shopping
    ["Amazon"]="https://www.amazon.com/s?k=%s"
    ["eBay"]="https://www.ebay.com/sch/i.html?_nkw=%s"
    ["AliExpress"]="https://www.aliexpress.com/wholesale?SearchText=%s"

    # Images / GIFs
    ["Unsplash"]="https://unsplash.com/s/photos/%s"
    ["Google Images"]="https://www.google.com/search?tbm=isch&q=%s"
    ["Giphy"]="https://giphy.com/search/%s"

    # Maps / travel
    ["Google Maps"]="https://www.google.com/maps/search/%s"
)

# Enable engine and maintain ordered list of engines
ENABLE_ENGINE=(
    "YouTube"
    "Google"
    "Bing"
    "DuckDuckGo"
    "Startpage"
    "ChatGPT"
    "Perplexity"
    "Microsoft Copilot"
    "GitHub"
    "Amazon"
    "Unsplash"
    "Google Maps"
)

# --- Embedded Rofi Theme ---
ROFI_THEME='
window {
    width: 40%;
}

listview {
    lines: 8;
    columns: 2;
    spacing: 5;
    cycle: false;
}

element {
    padding: 2px;
}

element-text {
    horizontal-align: 0.25;
}
'

ROFI_THEME_QUERY='
window {
    width: 40%;
}

listview {
    enabled: false;
}
'

# --- Functions ---

choose_engine() {
    printf "%s\n" "${ENABLE_ENGINE[@]}" | rofi -dmenu -i -theme-str "$ROFI_THEME" -p "Search Engine"
}

choose_query() {
    rofi -dmenu -theme-str "$ROFI_THEME_QUERY" -p "Query"
}

urlencode() {
    if command -v jq >/dev/null 2>&1; then
        jq -sRr @uri <<<"$1"
    else
        local s="$1" encoded="" c
        for (( i=0; i<${#s}; i++ )); do
            c=${s:$i:1}
            case "$c" in
                [a-zA-Z0-9.~_-]) encoded+="$c" ;;
                *) encoded+=$(printf '%%%02X' "'$c") ;;
            esac
        done
        echo "$encoded"
    fi
}

open_in_browser() {
    local engine="$1"
    local query=$(urlencode "$2")
    local template="${ENGINES[$engine]}"
    local url="${template//%s/$query}"
    $BROWSER "$url" &
}

# --- Main Flow ---
engine=$(choose_engine)
[ -z "$engine" ] && exit 0

query=$(choose_query)
[ -z "$query" ] && exit 0

open_in_browser "$engine" "$query"
