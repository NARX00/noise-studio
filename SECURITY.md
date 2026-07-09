# Noise Studio — Security & Authenticity Guide

This app is designed to be as safe as a web app can be: it is a **single file
that runs entirely on your own device**. It has no server, no account, no
tracking, and it never sends anything over the internet. Once the page has
loaded, you can disconnect from the network and it keeps working.

Because there is no server and no stored user data, the usual ways websites get
"hacked" (database breaches, stolen passwords, server break-ins) **do not apply
here — there is nothing on a server to attack.**

The one realistic risk with a free, shareable file is that a bad actor could
take a copy, secretly modify it (to add ads, tracking, or something harmful),
and pass it off as the real thing. This guide shows how to make sure the copy
you have is the genuine, unmodified one.

---

## For everyone: how to check your copy is authentic

Every official release comes with a **SHA-256 checksum** — a short fingerprint
that changes completely if even one character of the file is altered. If your
file's fingerprint matches the official one, your copy is authentic.

**The official fingerprint for this release is in the file `index.html.sha256`.**

### Verify on Windows
Open PowerShell in the folder with the file and run:
```
Get-FileHash index.html -Algorithm SHA256
```
Compare the printed hash to the official one (case doesn't matter).

### Verify on macOS
Open Terminal in the folder with the file and run:
```
shasum -a 256 index.html
```

### Verify on Linux
```
sha256sum index.html
```

If the value matches the official fingerprint, you have the real file. **If it
does not match, do not trust that copy** — download a fresh one from the
official source.

---

## For people sharing or hosting the app

You are warmly encouraged to share this tool. To keep the people you share it
with safe, please follow these practices.

### 1. Serve it over HTTPS (this is the most important one)
Host it somewhere that provides HTTPS automatically and for free:
- **GitHub Pages**, **Cloudflare Pages**, **Netlify**, or **Codeberg Pages**.

HTTPS stops anyone on the network in between (a hostile Wi-Fi hotspot, for
example) from altering the file on its way to the user and slipping in harmful
code. Serving over plain `http://` leaves that door open. All the hosts above
give HTTPS with no configuration and no cost.

### 2. Publish the checksum next to the download
Put the contents of `index.html.sha256` on your download page so people can
verify their copy (see above). When you release an updated version, publish the
new checksum with it.

### 3. Keep it a single self-contained file
The app's safety comes largely from having **zero external dependencies** — it
loads no outside scripts, fonts, or trackers. Please keep it that way. If you
ever add an external resource (a font, a script, an analytics tag), you:
- reintroduce "supply-chain" risk (that outside thing could be compromised), and
- must pin it with a **Subresource Integrity (SRI)** hash so the browser refuses
  it if it's been tampered with.

The safest change is no external dependency at all.

### 4. Don't add a backend unless you truly need one
The moment you add a server, a database, accounts, comments, or "save to cloud,"
you create real attack surface that has to be secured and maintained. For a tool
like this, you almost certainly don't need any of it. Keeping it static keeps it
safe.

### 5. (Optional, strong) Sign your releases
For the highest assurance, sign the checksum file so the fingerprint itself
can't be forged. Two good, free options:
- **Sigstore / cosign** (modern, keyless): https://www.sigstore.dev/
- **GPG**: `gpg --armor --detach-sign index.html.sha256`

Publish your public key once, and users can confirm the checksum genuinely came
from you.

---

## What's built into the file itself

The app already includes defensive measures so that even in a worst case it
can't be turned into something that attacks its users:

- **A strict Content-Security-Policy (CSP).** The file tells the browser to run
  only its own built-in code, load nothing from the internet, and make no
  network connections at all (`connect-src 'none'`). If anyone managed to inject
  a malicious `<script src=…>` or a hidden "phone home" request, the browser
  blocks it.
- **No `eval`, no `document.write`, no dynamic code execution.** There is no
  mechanism for turning text into running code.
- **No untrusted input reaches the page.** All on-screen content is built from
  fixed, built-in text using safe DOM methods (`textContent`), not raw HTML
  insertion — so there is no place for injected markup to run.
- **No network APIs are used.** No `fetch`, no `XMLHttpRequest`, no WebSocket.
  The audio and graphics are generated locally in your browser.
- **`referrer: no-referrer` and `X-Content-Type-Options: nosniff`** for good
  measure.

---

## Reporting a concern

If you believe you've found a security problem, or you've seen a modified copy
being passed off as the official one, please report it to the project's official
contact channel (add yours here). Because the app holds no user data, there is
nothing to breach — reports are mainly about tampered copies and hosting.

---

*This tool is free to use and share. It is a comfort and focus aid, not a
medical device, and makes no health claims.*
