# Fork Customizations

This is a fork of [karlomikus/vue-salt-rim](https://github.com/karlomikus/vue-salt-rim), customized for self-hosting at `bar-api.streeter.cc`.

**Last synced with upstream:** v4.14.1 / develop @ `de350b19` (2026-03-17)

---

## What's Different From Upstream

### Theming
- **Dark mode only** — light mode toggle removed. The app always uses the dark purple palette.
- **Custom background** — `public/bg.png` replaces the upstream default.
- **Custom logo/favicon** — `public/favicon.png`, `public/logo-black.png`.

### Infrastructure
- **Docker config** — `Dockerfile`, `docker/default.conf`, `docker/entrypoint.sh` are tuned for self-hosted deployment. Do not take upstream versions of these blindly.

### Runtime Config
- **`public/config.js`** — gitignored (intentional). Contains hardcoded API/search URLs for production. Not committed. The template is `docker/config.js`.

---

## Files You Own — Always Take Yours in a Conflict

During any upstream merge, if these files conflict, **keep your version** for the theming properties:

| File | What you changed |
|---|---|
| `src/assets/base.css` | CSS custom properties — entire dark color palette, shadow tokens |
| `src/assets/main.css` | Global layout styles, toast fix |
| `src/assets/blocks.css` | Block container styles |
| `src/assets/buttons.css` | Button variants |
| `src/assets/chips.css` | Chip/tag styles |
| `src/assets/dialog.css` | Dialog overlay styles |
| `src/assets/dropdown.css` | Dropdown styles |
| `src/assets/forms.css` | Form input styles |
| `src/assets/search.css` | Search UI styles |
| `src/assets/table.css` | Table styles |
| `src/assets/tags.css` | Tag styles |
| `src/assets/typography.css` | Typography scale |
| `src/components/Layout/SiteHeader.vue` | Custom navigation layout |
| `public/bg.png` | Custom background image |
| `public/favicon.png` | Custom favicon |
| `public/logo-black.png` | Custom logo |
| `Dockerfile` | Custom build/deploy config |
| `docker/default.conf` | Custom nginx config |
| `docker/entrypoint.sh` | Custom container startup |

**Files to take upstream unconditionally** (no custom changes):
- All `src/locales/messages/*.json` — always take upstream for new translation keys
- `src/api/api.d.ts` — auto-generated from server OpenAPI spec, always take upstream
- `src/api/BarAssistantClient.ts` — take upstream unless you've added custom endpoints

---

## AI Support

AI is **server-side** as of v4.14.0. Configure it in your Bar Assistant server environment, not here.

The client reads `is_ai_enabled` from the server info response and shows/hides the AI generate button accordingly. No client-side config needed.

Server env vars (set in your Bar Assistant server, not this repo):
```
AI_PROVIDER=openai          # or: anthropic, ollama, etc.
AI_HOST=https://...         # API base URL
AI_MODEL=gpt-4o             # model name
AI_API_KEY=sk-...           # API key
```

---

## How to Sync With Upstream

Run this whenever a new upstream version is tagged:

```bash
# 1. Fetch latest upstream
git fetch upstream

# 2. Create a sync branch off your develop
git checkout develop
git checkout -b upstream-sync-vX.X.X

# 3. Merge the upstream production branch
git merge upstream/master
# (or upstream/develop for bleeding-edge pre-release)

# 4. Resolve conflicts — for CSS/theming files, keep yours
#    For locale JSON and api.d.ts, take upstream

# 5. Verify the build passes
npm install
npm run build

# 6. Merge back to develop
git checkout develop
git merge upstream-sync-vX.X.X
```

### Conflict Quick Reference

| Conflict in... | Take... |
|---|---|
| `src/assets/*.css` | **Yours** (theming) |
| `src/components/Layout/SiteHeader.vue` | **Yours** (custom nav) |
| `docker/*`, `Dockerfile` | **Yours** (infra) |
| `src/locales/messages/*.json` | **Upstream** (new keys) |
| `src/api/api.d.ts` | **Upstream** (server spec) |
| `package.json` | **Upstream** (take dep updates, check for removed features) |
| Component `<script>` logic | **Upstream** (features) |
| Component `<style scoped>` | **Case by case** — check if upstream changed theming or just added new styles |

---

## Restore Points

| Tag | Description |
|---|---|
| `backup/pre-upstream-sync-2026-03-17` | State before first upstream sync (your original customizations) |
