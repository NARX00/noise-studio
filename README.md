# Noise Studio

**A free, private, offline-friendly noise generator for sleep, focus, and calm — with a built-in sound-science lab.**

Noise Studio plays steady background sound (rain, ocean, fan, and more) that many
people find helpful for sleeping, concentrating, relaxing, or masking distracting
noise. It also includes an optional "Advanced" mode with a full noise generator
and genuine DSP analysis (spectrum, autocorrelation, amplitude statistics, and
more) for the curious and for students.

- **Free forever.** No account, no payment, no ads.
- **Private by design.** Runs entirely in your browser. It sends nothing over the
  internet and stores only your accessibility preferences on your own device.
- **Works offline.** Once the page has loaded, you can disconnect and it keeps working.
- **One file.** The whole app is a single `index.html` you can email, put on a USB
  stick, or host anywhere.
- **Accessible.** Keyboard-navigable, screen-reader friendly, with larger-text and
  reduced-motion options, and it respects your system dark-mode setting.

> This is a comfort and focus tool, **not a medical device**, and it makes no health
> claims. If you're struggling with sleep, focus, anxiety, or tinnitus, please speak
> with a qualified healthcare professional.

---

## Use it now

**Live site:** _add your Cloudflare Pages URL here, e.g._ `https://noise-studio.pages.dev`

Or download `index.html` from this repository and open it in any modern browser.

---

## Is your copy genuine?

Because this file is free to copy, anyone could alter a copy and re-share it. Every
release includes a **SHA-256 fingerprint** so you can confirm your copy is the real,
unmodified one.

**Official fingerprint for the current release:**

```
bba3c6e55713c79f0daa975431c3e602f5ef962d8a282cd5e2446c8ad977f97a  index.html
```

Check your copy:

- **Windows (PowerShell):** `Get-FileHash index.html -Algorithm SHA256`
- **macOS:** `shasum -a 256 index.html`
- **Linux:** `sha256sum index.html`

If the value matches, your copy is authentic. If it doesn't, get a fresh copy from
the official site above. Prefer copies served over a secure `https://` address.

See [`SECURITY.md`](SECURITY.md) for the full security and authenticity guide.

---

## Security posture

This app is about as safe as a web app can be, because there's almost nothing to attack:

- **No server, no database, no accounts** → none of the usual "website got hacked"
  scenarios apply.
- **No external dependencies** → no third-party scripts, fonts, or trackers to be
  compromised.
- **No network calls** → no `fetch`, `XMLHttpRequest`, or WebSocket anywhere.
- **Strict Content-Security-Policy** → the browser is told to run only this file's
  own code and make no network connections (`connect-src 'none'`). Delivered both as
  an in-file `<meta>` tag and, on Cloudflare Pages, as a real HTTP header via
  [`_headers`](_headers).
- **No `eval`, no `document.write`, no untrusted HTML** → on-screen content is built
  with safe DOM methods only.

---

## Host it yourself (free)

You're warmly encouraged to share and self-host. Two good free options:

### Cloudflare Pages (recommended — global CDN, unlimited bandwidth, free HTTPS)
1. Push this repo to your GitHub account.
2. In the Cloudflare dashboard: **Workers & Pages → Create → Pages → Connect to Git**.
3. Pick this repository. Build command: _(leave empty)_. Output directory: `/`.
4. Deploy. Your site is live at `https://<project>.pages.dev` with HTTPS.
   The included [`_headers`](_headers) file adds real security headers automatically.

### GitHub Pages (simplest — free HTTPS for public repos)
1. Repo **Settings → Pages**.
2. Source: **Deploy from a branch**, `main` / root. Save.
3. Live in ~1 minute at `https://<user>.github.io/<repo>/`.
   (Note: GitHub Pages ignores the `_headers` file; the in-file `<meta>` CSP still applies.)

Please keep it a single self-contained file, serve it over HTTPS, and publish the
fingerprint so others can verify their copy.

### Updating a release

Whenever you edit `index.html`, its fingerprint changes — so regenerate and re-sync it
before committing, or the verification instructions will report a (correct) mismatch.
Two helper scripts do this automatically:

- **macOS / Linux:** `./release.sh`
- **Windows (PowerShell):** `.\release.ps1`

Each recomputes the SHA-256, rewrites `index.html.sha256`, and updates the fingerprint
shown in this README. Then just `git add -A && git commit`.

---

## License

Free to use, share, and modify under the [MIT License](LICENSE). Please keep the
copyright/credit line intact.
