#!/usr/bin/env bash

BROWSER="${BROWSER:-librewolf}"   # fallback browser
HIST_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/rofi-websearch-history"
mkdir -p "$(dirname "$HIST_FILE")"
touch "$HIST_FILE"

# --- Engine Definitions ---
# Key = engine name (shown in rofi)
# Value = search URL (with %s placeholder for query)
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

# Enable engine and maintain ordered list of engines (controls display order in rofi)
ENGINE_ORDER=(
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


# --- Functions ---

choose_engine() {
    printf "%s\n" "${ENGINE_ORDER[@]}" | rofi -dmenu -i -p "Search Engine"
}

choose_query() {
    # Show "Clear History" option with search history
    (echo "🗑 Clear History"; tac "$HIST_FILE") | rofi -dmenu -i -p "Query"
}

clear_history() {
    > "$HIST_FILE"
    notify-send "rofi-websearch" "History cleared"
}

save_query() {
    local q="$1"
    # Deduplicate, append, cap to 100 entries
    grep -Fxv "$q" "$HIST_FILE" > "${HIST_FILE}.tmp"
    mv "${HIST_FILE}.tmp" "$HIST_FILE"
    echo "$q" >> "$HIST_FILE"
    tail -n 100 "$HIST_FILE" > "${HIST_FILE}.tmp" && mv "${HIST_FILE}.tmp" "$HIST_FILE"
}

urlencode() {
    if command -v jq >/dev/null 2>&1; then
        jq -sRr @uri <<<"$1"
    else
        # fallback to ASCII-only Bash version
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

if [[ "$query" == "🗑 Clear History" ]]; then
    clear_history
    exit 0
fi

save_query "$query"
open_in_browser "$engine" "$query"
