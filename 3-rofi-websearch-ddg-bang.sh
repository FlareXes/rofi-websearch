#!/usr/bin/env bash
#
# 🔎 Search with DuckDuckGo bangs via rofi, with local overrides.
#
# Behavior:
#   - If prefix matches a local mapping → use that.
#   - Else → forward query to DuckDuckGo bangs (!prefix query).
#
# Common prefixes:
#   g      → Google Search
#   ddg    → DuckDuckGo Search
#   yt     → YouTube
#   gh     → GitHub
#   so     → StackOverflow
#   amz    → Amazon
#   ebay   → eBay
#   gm     → Google Maps
#   img    → Google Images
#   sp     → Startpage
#
# Full bang list: https://duckduckgo.com/bang

BROWSER="xdg-open"

ROFI_THEME='
window {
    width: 40%;
}

listview {
    enabled: false;
}
'

# --- Local bang overrides (prefix → URL template with %s) ---
declare -A BANGS=(
    # Custom (not supported by DDG)
    ["gpt"]="https://chat.openai.com/?q=%s"
    ["ppx"]="https://www.perplexity.ai/search?q=%s"
    ["copilot"]="https://copilot.microsoft.com/?q=%s"
)

# --- Dependency check ---
check_dependencies() {
    local deps=("xdg-open")
    local launcher=""

    # Choose launcher dynamically
    if command -v rofi >/dev/null 2>&1; then
        launcher="rofi"
    elif command -v walker >/dev/null 2>&1; then
        launcher="walker"
    fi

    if [[ -z "$launcher" ]]; then
        echo "❌ Error: Neither 'rofi' nor 'walker' found in PATH." >&2
        exit 1
    fi

    # Verify other required binaries
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            echo "❌ Error: Missing dependency '$dep'." >&2
            exit 1
        fi
    done

    echo "$launcher"
}

# --- Query chooser ---
choose_query() {
    local launcher="$1"
    case "$launcher" in
        rofi)
            rofi -dmenu -i -theme-str "$ROFI_THEME" -p "Bang"
            ;;
        walker)
            walker --dmenu -I -p "Bang"
            ;;
    esac
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
    local query="$1"
    local prefix="${query%% *}"
    local rest="${query#* }"

    # If query has no space, treat whole thing as search term
    if [[ "$query" == "$prefix" ]]; then
        rest=""
    fi

    if [[ -n "${BANGS[$prefix]}" ]]; then
        # Local custom mapping
        local encoded=$(urlencode "$rest")
        local url="${BANGS[$prefix]}"
        url="${url//%s/$encoded}"
    else
        # Fallback to DuckDuckGo bangs
        # prepend "!" only if user didn't type one
        if [[ "$query" != "!"* ]]; then
                query="!$query"
        fi
        local encoded=$(urlencode "$query")
        local url="https://duckduckgo.com/?q=${encoded}"
    fi

    $BROWSER "$url" &
}

# --- Main Flow ---
launcher=$(check_dependencies)
query=$(choose_query "$launcher")
[ -z "$query" ] && exit 0

open_in_browser "$query"
