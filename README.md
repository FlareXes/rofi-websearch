# rofi-websearch 

A tiny **Rofi-powered web search launcher** for people too cool to open a browser first. Pick your search engine, type (or reuse) your query, and boom — results in your browser.

---

## ✨ Features
- 🔍 **Multi-engine**: Google, DuckDuckGo, YouTube, Perplexity, GitHub, and more.  
- 📝 **Search history**: remembers your last 100 queries (because muscle memory is faster than typing).  
- 🗑️ **Clear history option**: because sometimes you just don’t want “how to fix rm -rf /” saved forever.  
	- History lives in `$HOME/.cache/rofi-websearch-history` —  in case you want to feel extra smart and nuke it manually.

- 🦆 Case-insensitive (no more typing “youtube” instead of “YouTube”).  
- ⚡ Lightweight: it’s a Bash script, not an electron app.  

---

## 🔧 Requirements
- rofi
- bash
- jq (optional, but makes URL encoding less of a hack)  

---

## 🚀 Installation
Clone it, make it executable, and you’re good:

```bash
git clone https://github.com/flarexes/rofi-websearch.git
cd rofi-websearch
chmod +x rofi-websearch.sh
````

(Optional) yeet it into your `$PATH`:

```bash
sudo cp rofi-websearch.sh /usr/local/bin/rofi-websearch
```

---

## 💻 Usage

Launch with:

```bash
rofi-websearch
```

1. Pick a search engine.
2. Enter your query (or pick from history if you’re lazy).
3. Browser opens → you pretend you’re a productivity wizard.

**To clear history:** select `🗑 Clear History`. (Don’t worry, it won’t clear your actual browser history — that’s still on *you*.)

---

## ⚙️ Customization

Want to use Firefox instead of Librewolf? Easy:

```bash
export BROWSER=firefox
```

Want to hide some engines? Just comment them out:

```bash
["Google"]="https://www.google.com/search?q=%s"
# ["Vimeo"]="https://vimeo.com/search?q=%s"   # (goodbye Vimeo, nobody will miss you)
```

---

## 📜 License

[MIT License](LICENSE).

Basically: steal it, fork it, improve it. Just don’t sell it as “AI-powered web launcher 3000™”.

---
## 🙌 Credits

I would like to thank:
- [FlareXes](https://github.com/flarexes) – for brainstorming, prompting, and crazy ideas.
- [ChatGPT](https://chat.com) – for actually writing the script and README.md while I drank coffee. ☕
