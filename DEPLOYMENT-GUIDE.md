# Deployment Guide — Getting Noise Studio Online

A complete walkthrough from zero to a live, secure, free website. No prior
experience with GitHub or Cloudflare needed. **No command line required** for the
main path — everything can be done in a web browser.

**Total time:** about 20 minutes.
**Total cost:** nothing, ever. No credit card at any point.

---

## What you'll end up with

- Your code publicly hosted on **GitHub** (so anyone can inspect and trust it).
- Your site served worldwide by **Cloudflare Pages** over HTTPS, with unlimited
  bandwidth and real security headers.
- Automatic redeployment every time you make a change.
- An automatic daily check that your live site hasn't been tampered with.

---

## Before you start: the files

You should have these 11 files. Keep them together in one folder on your computer.

| File | What it's for |
|---|---|
| `index.html` | **The app itself.** This is the whole thing. |
| `index.html.sha256` | The fingerprint that proves a copy is genuine. |
| `README.md` | The front page of your GitHub repo. |
| `SECURITY.md` | Security & authenticity guide. |
| `SHARING.md` | Ready-made descriptions for sharing the tool. |
| `LICENSE` | The MIT license. |
| `_headers` | Tells Cloudflare to send security headers. |
| `release.sh` | Updates the fingerprint after you edit the app (Mac/Linux). |
| `release.ps1` | Same, for Windows. |
| `check-site.sh` | Checks the live site is up and unmodified. |
| `site-check.yml` | Runs that check automatically, daily. |

### Two placeholders to fill in first

Open these in any text editor and edit them **before** uploading:

1. **`LICENSE`** — replace `[YOUR NAME OR PROJECT NAME]` with your name or project name.
2. **`README.md`** — find the line that says
   `**Live site:** _add your Cloudflare Pages URL here…_`
   You don't know the URL yet — that's fine. We'll come back and fill it in at Step 12.

---

# Part 1 — Put the code on GitHub

## Step 1. Create a GitHub account

Go to **https://github.com** and click **Sign up**. It's free. Verify your email.

> **Why GitHub?** It stores the code publicly so anyone can read it and confirm the
> tool does what it claims. That openness *is* the security model — there are no
> secrets in this app, and nothing to hide.

## Step 2. Create a new repository

1. Click the **+** icon in the top-right → **New repository**.
2. **Repository name:** `noise-studio` (or any name you like).
3. **Description:** *A free, private noise generator for sleep, focus, and calm.*
4. Select **Public**. ← Important. Free hosting requires this, and it costs you
   nothing since the app's source is visible in any browser anyway.
5. **Do not** tick "Add a README file" — you already have one.
6. Click **Create repository**.

## Step 3. Upload your files

On the empty repository page, look for the link **"uploading an existing file"**
(or go to **Add file → Upload files**).

1. Drag **all 11 files** into the browser window.
   - On Mac, `_headers` may be hidden. Press `Cmd + Shift + .` in Finder to show
     hidden files, or drag the whole folder in.
2. Scroll down. In the **Commit changes** box, type: `Initial release`
3. Click **Commit changes**.

Your files are now on GitHub. 🎉

## Step 4. Move the workflow file into place

The automatic checker needs to live in a specific folder. This is the one slightly
fiddly step.

1. In your repository, click **Add file → Create new file**.
2. In the filename box, type exactly:
   ```
   .github/workflows/site-check.yml
   ```
   *(Typing the `/` characters automatically creates the folders.)*
3. Open your local `site-check.yml` in a text editor, copy **all** of its contents,
   and paste them into the big editing box.
4. Scroll down, click **Commit new file**.
5. Back in the file list, delete the loose `site-check.yml` from the root: click it,
   then the **trash-can icon**, then **Commit changes**.

---

# Part 2 — Publish it with Cloudflare Pages

## Step 5. Create a Cloudflare account

Go to **https://dash.cloudflare.com/sign-up**. Sign up with an email and password.
**No credit card is required** for Pages. Verify your email.

## Step 6. Create a Pages project

1. In the Cloudflare dashboard sidebar, click **Compute (Workers & Pages)**.
   *(In some versions this is just "Workers & Pages".)*
2. Click **Create** → select the **Pages** tab → **Connect to Git**.
3. Click **Connect GitHub**. A GitHub window opens asking for permission.
4. Choose **Only select repositories**, pick `noise-studio`, and click
   **Install & Authorize**.

> Granting access to only this one repository is the safer choice — Cloudflare
> never sees your other projects.

## Step 7. Configure the build (the important bit)

Cloudflare will show a setup screen. Because your app is a plain HTML file with no
build step, you must leave the build fields **empty**:

| Field | What to enter |
|---|---|
| **Project name** | `noise-studio` (this becomes your URL) |
| **Production branch** | `main` |
| **Framework preset** | **None** |
| **Build command** | *(leave completely empty)* |
| **Build output directory** | `/` |

> If you put anything in "Build command", the deploy will fail. There is nothing to
> build — the file is already finished.

## Step 8. Deploy

Click **Save and Deploy**.

Wait about 30–60 seconds. When it finishes, you'll see a URL like:

```
https://noise-studio.pages.dev
```

**Click it.** Your app should load. 🎉

---

# Part 3 — Verify everything works

## Step 9. Test the app itself

Open your live URL and check:

- [ ] A sound card is selected and the waveform draws.
- [ ] Press **play** — you hear noise. (Browsers require a click before audio; that's normal.)
- [ ] Adjust the **volume**.
- [ ] Set a **sleep timer**, press **Start**, watch it count down. Press **Cancel**.
- [ ] Switch to **Advanced** — change the noise type and confirm the analysis plots change.
- [ ] Press **Download WAV** — a file downloads.
- [ ] Click the **?** and **☼** buttons — Help and Accessibility panels open.

## Step 10. Confirm the security headers are live

1. On your live site, press **F12** (or right-click → **Inspect**) to open developer tools.
2. Click the **Network** tab, then **reload the page**.
3. Click the first entry in the list (`noise-studio.pages.dev` or `index.html`).
4. Look under **Response Headers**. You should see:
   - `content-security-policy: default-src 'none'; …`
   - `strict-transport-security: max-age=31536000; …`
   - `x-frame-options: DENY`

If those appear, your `_headers` file is working.

5. Now click the **Console** tab. It should be **empty of red errors**. If you see a
   message mentioning "Content Security Policy", something is being blocked — copy
   the message and check the `_headers` file was uploaded correctly.

## Step 11. Confirm the fingerprint matches

This proves the site is serving exactly the file you published.

**On any computer, in a terminal:**

```
curl -sL https://noise-studio.pages.dev -o live.html
sha256sum live.html          # Mac: shasum -a 256 live.html
```

Compare the result to the value in `index.html.sha256`:

```
bba3c6e55713c79f0daa975431c3e602f5ef962d8a282cd5e2446c8ad977f97a
```

They should be identical.

> **If they differ**, the most likely cause is harmless: Cloudflare may have
> minified or slightly altered whitespace. If you want a byte-exact match, go to
> your Pages project → **Settings → Build** and ensure no auto-minification is
> enabled. (Cloudflare Pages does not minify by default.)

---

# Part 4 — Turn on automatic monitoring

## Step 12. Tell the checker your URL

1. In your **GitHub** repository, go to **Settings** (top tab).
2. In the left sidebar: **Secrets and variables → Actions**.
3. Click the **Variables** tab (not "Secrets").
4. Click **New repository variable**.
   - **Name:** `SITE_URL`
   - **Value:** `https://noise-studio.pages.dev` *(your actual URL)*
5. Click **Add variable**.

> We use a *variable*, not a *secret*, because your URL is public information.

## Step 13. Run the check once, manually

1. Go to the **Actions** tab of your repository.
2. If prompted, click **"I understand my workflows, go ahead and enable them"**.
3. Click **Site integrity check** in the left sidebar.
4. Click **Run workflow → Run workflow**.
5. Wait ~30 seconds, refresh. A **green tick ✓** means the site is up and the file
   matches your published fingerprint.

From now on this runs automatically every day and after every change. If it ever
fails, GitHub emails you.

## Step 14. Finish the README

1. Go back to your repository, click `README.md`, then the **pencil ✏️** icon.
2. Replace `_add your Cloudflare Pages URL here…_` with your real URL.
3. Click **Commit changes**.

Cloudflare will automatically redeploy. You're done. ✅

---

# Part 5 — Living with it

## How to update the app

Whenever you change `index.html`, its fingerprint changes — so you must regenerate it,
or the verification instructions you gave people will (correctly) report a mismatch.

**On your computer, in the folder with the files:**

```
# Mac / Linux
./release.sh

# Windows PowerShell
.\release.ps1
```

This recomputes the hash, rewrites `index.html.sha256`, and updates the fingerprint in
`README.md` automatically.

Then upload the three changed files (`index.html`, `index.html.sha256`, `README.md`)
back to GitHub via **Add file → Upload files** (it will overwrite them). Cloudflare
redeploys within a minute.

> Forget this step and the daily check will catch it for you — it'll fail with
> "MISMATCH" and tell you exactly what happened.

## Check the live site yourself, any time

```
./check-site.sh https://noise-studio.pages.dev
```

- Exit `0` — up and unmodified.
- Exit `1` — site unreachable.
- Exit `2` — **serving a different file than you published.** Investigate.

## Sharing it

Open `SHARING.md`. It has ready-to-paste descriptions in several lengths, including
one written specifically for shelters, clinics, libraries, and support groups.

---

# Troubleshooting

**"Build failed" on Cloudflare.**
You almost certainly entered something in *Build command*. Go to your project →
**Settings → Build & deployments → Edit configuration** and clear it completely.
Set output directory to `/`. Retry deployment.

**The page loads but there's no sound.**
Browsers block audio until you interact with the page. Click the play button. If it's
still silent, check your system volume and that the tab isn't muted (right-click the
tab → Unmute).

**The site shows a 404.**
Your file must be named exactly `index.html` (lowercase). Rename it if needed and
re-upload.

**The `_headers` file didn't upload.**
Files starting with `_` are sometimes hidden. On Mac, press `Cmd + Shift + .` in
Finder to reveal hidden files. Confirm it appears in the repo's file list. Without it
the app still works — the in-file CSP still protects users — but you lose the stronger
HTTP-level headers.

**The Actions check fails with "SITE_URL is not set".**
Revisit Step 12. Make sure you created a **Variable**, not a Secret, and named it
exactly `SITE_URL` (all caps).

**The Actions check fails with "MISMATCH".**
You edited `index.html` without running `release.sh`. Run it, re-upload the changed
files, and the check will pass on the next run. This is the system working as intended.
