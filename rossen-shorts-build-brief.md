# Rossen Shorts: Build Brief

For Claude Code. Read this whole file before starting. It records decisions Kyle has already made, so treat the "Locked decisions" table as settled and check with Kyle before changing any of it. Everything marked **PLACEHOLDER** is a starting value you will measure or verify during the build.

---

## 1. What we're making

A production system, packaged as a Claude Code skill named `rossen-shorts`, that turns a story into a finished vertical short for **Jeff Rossen / Rossen Reports**. Jeff is a consumer-protection journalist; the channel covers scams and money-saving news.

Output volume is **two videos per day**, so every video must be assembled from reusable templates. No per-video custom design work.

Roles:
- **Kyle** sends the story, composites Jeff into the video in Canva, and posts.
- **Claude** writes the script, renders the animation with sound effects and music, and delivers the package.
- **Jeff** records himself on camera while watching the video and reading the script.

The system is part of a business deal with Rossen Reports, so it must be self-contained and handoff-ready (see section 15).

## 2. Locked decisions

| Area | Decision |
|---|---|
| Platforms | YouTube Shorts and Instagram Reels |
| Frame | 1080×1920, 9:16, 30 fps |
| Length | 25–45 seconds, varies by story |
| Order of work | **Video first.** Jeff records against a finished video. Do not propose recording Jeff first. |
| Jeff on screen | Small circle facecam, tucked lower-left, just above the platform caption area |
| Compositing | Kyle does it in Canva |
| Jeff's delivery | Mostly reads the script, with small ad-libs |
| Jeff's setup | Watches the video on a screen while he speaks over it |
| Captions of Jeff's speech | None. On-screen text carries the story. |
| On-screen text | A few big words per screen |
| Headline | Changes every video. No recurring series banner. |
| First second | Hook graphic and Jeff's face both on screen from frame one |
| End card | FOLLOW FOR MORE |
| Topics | Kyle supplies them. Even mix of scams and good news (price cuts, deals, money-savers). |
| Story input | Varies: article link, bullet points, or a finished script from Jeff |
| Music | Changes with the story's mood |
| Sound effects | Keep the density and feel of the reference video |
| Top priority | **Timing.** Visuals must track Jeff's speaking speed with no dead space. |

## 3. Reference video

The base design is a 30-second animated scam explainer made earlier (the "Apple Pay scam" video). If Kyle has put the MP4 in `reference/`, extract frames from it and match its look. Its structure was: a phone receiving a fake Apple Pay charge alert → a DON'T CALL IT stamp → a call screen that glitches to SCAMMER → a THEN THEY ASK FOR list → a yellow DO THIS INSTEAD screen with steps → an end card. It had a yellow-ringed circle slot for Jeff, synthesized sound effects and music, and a timecoded script table.

Changes from that video:
- Move from 4:5 to 9:16.
- Kyle did not notice the facecam slot at all. The placeholder blended into the background. Fix that (section 5).
- Timing gets the full treatment in sections 6 and 7.

A second reference, a 60-second FBI scam alert video, may also be in `reference/`. Take the ROSSEN REPORTS corner tag treatment from it.

## 4. Per-video workflow

1. Kyle sends a story (link, bullets, or script).
2. Claude researches if needed, then writes the script sized to Jeff's measured pace.
3. Claude builds a shot list and renders the **clean** video, then the **read-along** video.
4. Automated QA runs, then Claude reviews the contact sheet.
5. The package goes to Kyle, who sends the read-along video and script to Jeff.
6. Jeff records with earbuds in, claps on the flash, and starts talking on GO.
7. Kyle gives Jeff's raw clip to Claude. `prep_jeff` trims it, levels the audio, and reports timing drift.
8. Kyle drops the prepped clip into Canva over the clean video, trims the end card, and posts.

## 5. Frame layout

**Safe zones (PLACEHOLDER; verify against current Meta and YouTube guidance, then check on a real phone with a private or unlisted upload).** Starting margins on the 1080×1920 frame: top 250 px, bottom 450 px, right 200 px (the like, comment, and share buttons), left 60 px. All text and all key visuals stay inside. Log every text bounding box during render so QA can check it.

**Jeff's circle (PLACEHOLDER until checked on a phone):**
- Diameter 260 px, top-left corner at x 60, y 1200 (center 190, 1330). Bottom edge sits at y 1460, just above the bottom margin.
- Ring: 8 px, drawn fully *outside* the circle so it stays visible when Kyle's clip covers the circle. Same yellow in both moods. The ring is a brand anchor.
- The circle area stays clear of all other content for the entire video. Nothing animates through it.
- **Clean video:** empty circle with a flat dark fill inside the ring.
- **Read-along video:** circle filled with a high-contrast placeholder labeled JEFF so nobody misses it.

**Canva numbers** delivered with every video (these follow from the circle spec; update both together if the spec changes): design size 1080×1920 px; circle frame W 260, H 260, X 60, Y 1200; Jeff's clip starts at 0:00.

**Corner tag:** ROSSEN REPORTS, small, fixed position at the top of the safe area, on screen for the whole video, same position in every video.

## 6. Timing rules

This section is the core of the project.

**Pace.** Measure Jeff's real speaking rate from 3–5 of his Shorts or Reels where he talks to camera. Kyle will supply links. Download with `yt-dlp`, transcribe with word timestamps (faster-whisper or whisper), and compute:
- words per second over speech only (exclude music-only stretches and other speakers)
- typical pause length at sentence breaks and at ellipses

Store the results in `references/pace.json`. **PLACEHOLDER until measured:** the reference video's script ran about 100 words in 30 seconds, roughly 3.3 words per second. That number was an estimate.

**Word budget.** Target words = measured words per second × (runtime − end card). Time every line individually from its word count plus measured pauses, not just the total.

**Sync points.** One to three per video, where a visual hit must land on a specific word (in the reference video, "it's a scammer" landed on the glitch). Mark them in the script and in the shot list.

**Motion.** No span longer than about 1 second without visible change, except the end card. Every scene carries secondary motion: slow push-in, pulse, drift, a ticking counter. If Jeff lags a beat, it reads as a natural pause.

**Text rhythm.** A few big words per screen, changing every 1–2 seconds. Text entrances finish within about 0.3 seconds.

**Frame one.** The hook card is fully on screen at frame 0. No fade from black. Jeff's first line is the hook, and he starts speaking at 0:00.

**Elastic end card.** FOLLOW FOR MORE with the logo. Render it with 4 seconds of extra hold past the planned end. Kyle trims it in Canva to wherever Jeff stops, so ad-libs never leave dead air at the end.

## 7. Read-along video

Jeff watches this while recording. It is never posted.

**Lead-in (3 seconds, prepended):**
- −3.0 s: "3"
- −2.0 s: "2"
- −1.0 s: full white flash with "CLAP" for 3 frames. Jeff claps on it. Then show "GET READY" and the first line until 0.0.
- 0.0 s: the clean video begins and Jeff starts talking.

**Overlay** (drawn on top of the clean video):
- A dark band across the top of the frame. Keeping it near the top puts Jeff's eyes close to the camera lens.
- Current line large, next line smaller and dimmed below it.
- The current line fills left to right at the planned pace, like karaoke, so Jeff can see instantly whether he's ahead or behind.
- The sync word in each sync point shows in yellow, with a short fill bar leading into it.
- The JEFF placeholder in the circle.

Render it as an overlay pass on the finished clean MP4 plus the lead-in, so the animation itself only renders once.

## 8. Script writing: Jeff's voice

Measured from 141,477 spoken words across 19 aired transcripts of his live show.

**He reaches for:** "right now" (347 uses, his single most characteristic phrase; write urgency into the copy), "you guys" (187), "crazy" (65), "watch this" (34), "insane" (32), "exploding" (28), "brand new" (25), "pause" (24), "protect yourself" (22). "GENIUS" is his word for a cleverly built scam and shows up in his best-performing titles. He says "you" constantly, about one word in thirty, and "buy" rather than "purchase."

**He almost never says:** folks, consumers, however, allegedly, reportedly, alleged, utilize, individuals, the bottom line, here's the thing, furthermore, moreover, in conclusion. No hedging, no formal register, no anchor-style connecting phrases.

**First person:** sparing, one line at most, usually in the hook. Example from his material: "I HATE SCAMMERS, BUT I LOVE IT WHEN THEY GET BUSTED."

**Leave to him:** "by the way" asides and "Welcome to Rossen Reports." Don't script either. Shorts open on the hook.

**Good-news register:** his show's closing stories open with "GOOD NEWS!!!" and then say what's getting cheaper, how much you save, and how to get it.

**What performs:** his top videos take something the viewer does every day (a debit card, phone apps, self-checkout, the mail, Walmart, a tipping screen) and show it being used against them. Lead with the everyday object.

**Line rules for this format:**
- Jeff mostly reads as written, so lines can be crafted, but each line must still survive a paraphrase.
- Short lines, one idea each.
- Write phone numbers and short codes the way he'd say them ("seven-seven-two-six").
- His last line lands on the end card, usually a share or follow push.

**Script file format:** a timecoded table with columns for time, on screen, and Jeff's line. Sync points in bold. Show the word count and estimated runtime at the top.

## 9. Facts and research

- **Link or bullets:** research before writing. Use primary sources: FTC, FBI IC3, BBB Scam Tracker, state attorneys general, CFPB, court filings, company statements. Use exact figures with source and date. Confirm the story is current.
- **Finished script from Jeff:** keep his facts and his claims. Only tighten it for timing. If it runs over the word budget, flag it and propose specific cuts rather than cutting silently.
- **Never invent** a quote, statistic, victim, price, or source. Flag anything single-sourced.
- Sources go in the script file under a short section for Kyle. They never appear on screen.
- For good-news stories, prices change. Note the date each price was checked.

## 10. Visual system

**Two moods, one brand.**

| | Alarm (scams) | Good news (deals, price cuts) |
|---|---|---|
| Background | Dark (near-black or deep navy) | Bright |
| Accents | Warning yellow, alert red | Green, gold |
| Motion flavor | Stamps, glitches, shakes, alerts | Price strikes, count-ups, pops, sparkles |
| Music | Tense | Upbeat |

**Constant across both moods:** fonts, the ROSSEN REPORTS corner tag, the yellow ring, the circle position, and the safe zones.

**Fonts** (Google Fonts, OFL license; bundle them in `assets/fonts/` with their license files):
- Anton for headlines
- Archivo for secondary text
- Inter for text inside mockups

**Colors:** extract exact values from the reference MP4s if present. Otherwise propose a palette for each mood, render one style frame per mood, and get Kyle's sign-off. Store the result in `assets/brand.json`.

**Logo:** use Kyle's full-resolution Rossen Reports file at `assets/logo.png`. Never recreate it.

**Details live in mockups.** Anything too long for big text (the actual scam message, a price tag, a fake website) goes inside a mockup, where it reads as part of the picture.

## 11. Scene templates

Build each template as a reusable module. Each takes parameters (text, mood, any values) plus a duration, and must look right at any duration from about 1 second up, because durations come from the script timing. Each has a fast entrance and continuous secondary motion.

**Alarm mood:**
- Hook card
- Phone with incoming text or notification
- Incoming call screen that glitches to reveal SCAMMER
- Email or fake website mockup
- THEY'LL ASK FOR list
- Warning stamp (DON'T CALL, DON'T CLICK)
- Money-draining counter
- DO THIS INSTEAD steps
- End card

**Good-news mood:**
- Hook card
- Price tag with the old price struck through and the new price dropping in
- Savings counter
- Store or brand name card (plain type)
- Items-getting-cheaper list
- HOW TO GET IT steps
- End card

**Mockups are generic:** a generic messages app, a generic call screen. Company names can appear as plain text. No real company logos and no pixel copies of a real company's app or site.

After building, render a **template gallery** video showing every template in both moods, for Kyle to review before the pipeline work starts.

## 12. Audio

Everything is synthesized from scratch with numpy, so there is nothing to license.

- **Music:** three families (tense, upbeat, neutral), each with several variants (different key, tempo, and seed). At two videos a day, a single track per mood would get repetitive fast. Generation must be deterministic from its seed.
- **Sound effects, alarm:** whoosh, pop, glitch, alarm hit, stamp thud, notification ding, phone buzz.
- **Sound effects, good news:** ding, cash-register chime, coin, sparkle, riser.
- **Placement:** effects sit on text entrances and scene changes. Every sync point gets a hit.
- **Mix:** music and effects together at about −22.5 LUFS integrated, true peak at or below −1 dBTP, so Jeff's voice sits clearly on top.
- Save the generated effects as WAVs in `assets/sfx/`, so they're reused rather than regenerated each time.

## 13. Jeff's recording and `prep_jeff`

**One-time `jeff_notes.md`** for Kyle to send Jeff:
- Earbuds in. The video's audio must stay out of the room so it doesn't bleed into his mic.
- Clap on the white flash, then start talking on GO.
- Frame chest-up with his head in the upper half, since a circle crop cuts off shoulders fast.
- Look straight into the lens.
- Voice and camera in one take.

**`scripts/prep_jeff.py`**, run on Jeff's raw clip:
1. Find the clap: the sharp transient before his first word.
2. Trim the start to the clap plus exactly 1.000 second, so his clip begins at video 0:00.
3. Normalize his voice to about −14 LUFS (two-pass loudnorm) without re-cutting the picture.
4. Output `<slug>_jeff_ready.mp4`, ready to drop into the Canva circle at 0:00.
5. **Drift report:** transcribe his take with word timestamps and compare each line's actual start against the plan. Print a table and append the results to `references/pace_log.csv`. Once several videos are logged, propose updated numbers for `pace.json`. This is the calibration loop that gets the timing right over time.

## 14. Render pipeline and QA

**Stack:** Python draws the frames (Pillow and numpy, with pycairo where smoother vector shapes help) and pipes them to ffmpeg. Render in parallel chunks across CPU cores, then concatenate and add the audio.

**Shot list:** each job gets `jobs/<date>-<slug>/shotlist.json`, generated from the script and `pace.json`. It holds:
- the mood and music variant
- each line with its words, start, end, and any sync word
- each scene with its template, start, end, and parameters
- each sound effect with its name and time
- the end card hold

**Encoding:** H.264, CRF about 18, yuv420p, 30 fps, `+faststart`, AAC audio at 48 kHz.

**Automated QA,** run on every render:
- Specs: 1080×1920, 30 fps, expected duration.
- Loudness and true peak within target.
- No black frames.
- Every logged text box sits inside the safe zones, and nothing enters the circle area.
- No span over 1.0 second with near-zero frame change outside the end card (a frame-difference check).
- Every line's planned time is at least its word count divided by words per second.
- A contact sheet at 1 frame per second. Claude looks at it before handing anything off.

**Handoff is part of the job.** An earlier render finished and then never reached Kyle. A job is complete only when every deliverable is in the job folder and Kyle has been told where it is.

## 15. Skill structure and handoff-readiness

```
rossen-shorts/
├── SKILL.md              workflow, locked decisions, when to use what
├── README.md             setup and usage for a person, not Claude
├── setup.sh              one command to install everything on a fresh Mac
├── scripts/              render, shot list, QA, prep_jeff, audio generators, pace measurement
├── templates/            scene template modules, both moods
├── references/           voice.md, pace.json, pace_log.csv, safe_zones.md
├── assets/               fonts (with licenses), logo, brand.json, sfx/
└── jobs/                 one folder per video (keep this out of the packaged skill)
```

- Install it as a Claude Code skill (`~/.claude/skills/rossen-shorts/` or the project's `.claude/skills/`).
- Keep SKILL.md under about 500 lines and move detail into `references/`.
- Write a "pushy" description so it triggers reliably. For example: produce Rossen Reports Shorts and Reels; use whenever Kyle sends a story, link, bullet points, or script for a short, asks for a vertical video, a read-along, Canva numbers, or anything about prepping Jeff's recording.
- **Handoff-ready:** it runs on a fresh Mac from `setup.sh`, depends on no personal accounts or API keys, bundles every asset with its license, and includes a README a stranger could follow.

## 16. Build order

Check in with Kyle at each ★.

1. Scaffold the folder, write `setup.sh`, install ffmpeg, Python dependencies, fonts, and the logo.
2. ★ Extract the look from the reference MP4s if they're present. Render one style frame per mood for sign-off.
3. ★ Measure Jeff's pace from the Shorts links. Report words per second and pause lengths.
4. ★ Build the scene templates and render the template gallery.
5. Build the audio generators and the effects library.
6. Build the pipeline end to end: script → shot list → clean render → read-along → QA → deliverables, plus `prep_jeff`.
7. ★ Test run on the first real story. Deliver the full package.
8. ★ After Jeff records it, run `prep_jeff`, review the drift report with Kyle, and adjust `pace.json`.
9. Write SKILL.md and the references last, so they document what actually works. Package the skill.

## 17. Deliverables per video

In `jobs/<date>-<slug>/`:
- `<slug>_clean.mp4`: the posting base, with the ring, empty circle, and extended end card.
- `<slug>_readalong.mp4`: the lead-in, karaoke lines, and JEFF placeholder.
- `<slug>_script.md`: the timecoded table, sync points, word count, estimated runtime, and a sources section for Kyle.
- `canva.txt`: design size, circle frame W, H, X, Y, and the note to place Jeff's clip at 0:00 and trim the end card where he stops.
- After Jeff records: `<slug>_jeff_ready.mp4` and the drift report.

## 18. Don'ts

- No third-party footage or clips.
- No real company logos or pixel copies of real app and site designs.
- No captions of Jeff's speech.
- No text or key visuals in the right-side button column, the bottom caption area, or the circle.
- No invented facts, quotes, prices, or sources.
- No static holds over about 1 second outside the end card.
- No finished render left unreported.

## 19. Inputs from Kyle

- Links to 3–5 of Jeff's Shorts or Reels where he talks to camera
- The full-resolution Rossen Reports logo
- The Apple Pay and FBI reference MP4s, if he has them downloaded
- The first story
