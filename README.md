# melissabica.com — Website Update Guide

This repository is a **Jekyll** site published by **GitHub Pages** at
**https://www.melissabica.com** (custom domain configured in `CNAME`).

## How an update gets published

There are **no GitHub Actions workflow files** in this repository. GitHub Pages
runs its own built-in Jekyll build every time a commit is pushed to the
`master` branch — that build *is* the action that publishes the site.

1. Edit the relevant file (see [Where content lives](#where-content-lives)).
2. Optionally preview locally (see [Preview locally](#preview-locally)).
3. Commit and push to `master` (see [Publish](#publish)).
4. GitHub Pages rebuilds automatically — usually 1–2 minutes.
5. Verify:
   - Build/deploy status: <https://github.com/melissabica/melissabica.github.io/deployments>
   - Live site: <https://www.melissabica.com> (hard-refresh; the CDN caches for up to 10 minutes)

One-command publish after editing:

```bash
cd ~/Documents/melissabica.github.io
./update-site.sh "Update news: short description of the change"
```

The script builds the site locally first (so a broken page never gets pushed),
then stages everything, commits, and pushes to `master`.

## Where content lives

| What you want to change | File to edit |
| --- | --- |
| Homepage bio, headshot, **News** list | `index.md` |
| **CV** shown on the homepage and in the nav: Education, jobs, publications, presentations, press, teaching, awards, service, skills | `_posts/2019-04-09-cv.md` |
| **Projects** page (`/projects/`) | `2-projects.md` |
| **Travel** page (`/travel/`) | `4-travel.md` |
| Downloadable PDFs (CV, papers, posters) | `assets/files/` (reference them as `/assets/files/Name.pdf`) |
| Site title, email, social links, reusable paper links | `_config.yml` |
| Header/navigation, footer | `_includes/header.html`, `_includes/footer.html` |
| Images used on pages | `assets/` (reference them as `/assets/Name.png`) |

**How the nav works:** `_includes/header.html` lists only *posts* that have an
`anchor:` in their front matter — currently just the CV. The Projects
(`/projects/`) and Travel (`/travel/`) pages exist but are not linked in the
header. To add a nav link, copy the pattern of an existing link inside the
`.trigger` div of `_includes/header.html`:

```html
<a class="page-link" href="/projects/">Projects</a>
```

**Maintenance note:** `3-cv.md` is an old, stale copy of the CV (last dated
March 2019) that is still served at `/cv/`. The CV that actually appears on the
homepage (`#cv`) and in the nav comes from `_posts/2019-04-09-cv.md`. Decide
whether to update or delete the old page so the two copies don't drift further.

## Plaintext templates

Copy the matching block, fill it in, and place it at the **top** of the relevant
section (all sections are ordered newest-first). Keep the existing HTML classes
(`bolder`, `proceedings`, `hangingindent`, `alignright`, ...) so the styling
matches the rest of the site.

### News item — `index.md`, directly under `### News`

```markdown
* *Month YYYY:* One or two sentences about the update. Add a link when useful: <a target="_blank" href="https://example.com">link text</a>.
```

### Job / experience — `_posts/2019-04-09-cv.md`, under `Professional & Research Experience`

```html
<p class="alignright">Month YYYY–present</p>
<p class="nospace"><span class="bold">Company</span>, City, State, Country</p>
Job Title

* Achievement or responsibility.
* Another bullet (delete bullets if not needed).
```

### Education — `_posts/2019-04-09-cv.md`, under `Education`

```html
<p class="alignright">Month YYYY</p>
**University Name**  Degree, Field

* Optional detail (dissertation title, honors, etc.)
```

### Conference paper — `_posts/2019-04-09-cv.md`, under `Archival, Peer-Reviewed Conference Papers`

```html
<p class="hangingindent">Author One, Author Two, and Melissa Bica. YYYY. 
	<span class="bolder">Paper Title.</span> 
	In <span class="proceedings">Proceedings of the Conference Name</span> (CONF 'YY, City, Country). 
	(<a href="/assets/files/FILENAME.pdf" target="_blank" class="bolder">PDF</a>, 
	<a href="https://doi.org/..." target="_blank" class="bolder">DOI</a>)
</p>
```

### Journal article — `_posts/2019-04-09-cv.md`, under `Journal Articles`

```html
<p class="hangingindent">Author One, Author Two, and Melissa Bica. YYYY.
	<span class="bolder">Article Title.</span> 
	<span class="proceedings">Journal Name</span> VOL, ISSUE: PAGES.
	(<a href="/assets/files/FILENAME.pdf" target="_blank" class="bolder">PDF</a>, 
	<a href="https://doi.org/..." target="_blank" class="bolder">DOI</a>)
</p>
```

### Presentation or panel — `_posts/2019-04-09-cv.md`, under `Invited Presentations & Panels`

```html
<p>Melissa Bica. YYYY. Talk or panel title. Presented at <span class="italic">Venue.</span> City, State. Month DD, YYYY.</p>
```

Wrap a venue or media link in `<a href="URL" target="_blank">...</a>` when available.

### Press coverage — `_posts/2019-04-09-cv.md`, under `Press Coverage`

```html
<p><a href="URL" target="_blank">“Article title.”</a> Reporter Name. Publication. Month DD, YYYY.</p>
```

### Teaching — `_posts/2019-04-09-cv.md`, under `Teaching Experience`

```html
<p class="alignright">Month YYYY</p>
Guest Lecturer for COURSE CODE: Course Name
```

### Award — `_posts/2019-04-09-cv.md`, under `Awards`

```html
<p class="alignright">Month YYYY</p>
Award Name
```

### Project — `2-projects.md`, under `## Graduate` or `## Undergraduate`

```markdown
### Project Title
<img src="/assets/IMAGE.png" class="image-right fancybox" align="right" title="Short image description"/>

One-paragraph description of the project. Link out with [link text](https://example.com) if relevant.

**Abstract:** Optional abstract paragraph.
```

### Travel map — `4-travel.md`

Replace the `mid=` value in the Google My Maps embed URL with the new map's ID; keep the rest unchanged.

```html
<iframe src="https://www.google.com/maps/d/u/0/embed?mid=YOUR_MAP_ID" width="640" height="480"></iframe>
```

### New page (optional)

Create a file such as `5-talks.md`:

```markdown
---
layout: page
title: Talks
permalink: /talks/
---

Your content here.
```

Then add a nav link in `_includes/header.html` (see [Where content lives](#where-content-lives)).

### Replacing a PDF

Drop the new file into `assets/files/` and either reuse the existing filename
(e.g. `MelissaBicaCV.pdf`, so all links keep working) or update the links in
`_posts/2019-04-09-cv.md` and `3-cv.md`. Avoid spaces and apostrophes in new
filenames.

## Preview locally

```bash
cd ~/Documents/melissabica.github.io

# Quick check that the site builds (output goes to /tmp, nothing is touched)
jekyll build --destination /tmp/site-preview

# Or serve it with live reload at http://127.0.0.1:4000
jekyll serve
```

Messages like `Ignoring commonmarker-... because its extensions are not built`
are harmless warnings from the old Ruby/Jekyll install; the build still works.

## Publish

### With the helper script (recommended)

```bash
cd ~/Documents/melissabica.github.io
./update-site.sh "Update news: short description of the change"

# Or commit only specific files:
./update-site.sh "Add CHI 2026 paper" index.md _posts/2019-04-09-cv.md assets/files/my-paper.pdf
```

### Manually

```bash
cd ~/Documents/melissabica.github.io
git status                 # review what changed
git add -A                 # or: git add index.md _posts/2019-04-09-cv.md
git commit -m "Update news: short description of the change"
git push origin master
```

Then watch the deployment finish at
<https://github.com/melissabica/melissabica.github.io/deployments>.

## Troubleshooting

| Problem | Fix |
| --- | --- |
| `git: Bad CPU type in executable` | An old Intel git used to shadow the working one. It has been replaced by the Homebrew ARM git (`/opt/homebrew/bin/git`). In a *new* terminal it should work; run `eval "$(/opt/homebrew/bin/brew shellenv)"` if needed. |
| `git push` fails with `Permission denied (publickey)` | Your SSH key is not registered on your GitHub account. Add the contents of `~/.ssh/id_ed25519.pub` at <https://github.com/settings/keys> (title it e.g. "MacBook"), then push again. |
| Site not updating after a push | Check <https://github.com/melissabica/melissabica.github.io/deployments> for a failed/queued build. The live CDN can cache for up to 10 minutes; hard-refresh. |
| Local `jekyll` command not found | Jekyll 3.8.7 is installed at `/usr/local/bin/jekyll`. If missing, reinstall with `gem install jekyll -v 3.8.7`. |

## Repo hygiene

`_site/`, `.sass-cache/`, `.DS_Store`, and `.Rhistory` are ignored via
`.gitignore`. Never commit `_site/` — GitHub Pages generates it. When working
with R in this folder, the `.Rhistory` files stay out of git automatically.
