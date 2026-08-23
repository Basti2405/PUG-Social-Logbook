# PUG & Social Logbook

**A private notebook about the people you group with.**

*[Deutsche Fassung](README.md)*

> The core add-on is called **PugLog** in your AddOns folder and its slash
> command is `/pug`.

The group finder offers no context about people you have met before. This
add-on remembers who was there — and lets you write down what you want to
remember.

## Status: the logbook works, the UI does not exist yet

Recording, noting, tagging and rating **work and are tested** — 33 logic
tests, all green — but so far only through slash commands. A clickable
interface is the next step, see [`Planung/`](Planung/) (in German).

## The position behind it

This add-on stores notes about **people**. So it starts with four decisions
rather than a feature list:

1. **Everything stays local.** The data never leaves your machine on its own.
2. **Free text is never shared.** A note is written for yourself, in wording
   meant only for yourself. What may be shared — if anything — are tags and
   a rating.
3. **Humans do the rating.** An add-on deriving "good player" from combat
   data really measures gear and daily form.
4. **Only what you saw anyway gets recorded.**

## Commands

| Command | Effect |
|---|---|
| `/pug` | Open the book |
| `/pug note <name> <text>` | Set a note (empty removes it) |
| `/pug tag <name> <tag>` | Toggle a tag |
| `/pug rate <name> 1-5` | Rate (no number removes it) |
| `/pug doctor` | Self-check |

Recording happens at the **end** of a run — a completed keystone, a won boss
fight, or the group breaking up. Recording on entry captures those who leave
right away and misses those who join later.

## Structure

```
PugLog/                     Core
PugLog_LFGHighlighter/      Module – hint in the group finder
PugLog_CommunityShare/      Module – sharing within a fixed group
```

## What it can*not* do

- **Sort or decline applicants automatically.** The group finder is
  protected. The module *displays* a hint; the decision stays with you.
- **Follow renames and transfers.** The key is name-realm, so an entry is
  orphaned afterwards. Not solvable, only bearable.
- **Keep a public list.** There is no way to publish a collection of names
  from this add-on — and there should not be one.
- **Record without limit.** At most 25 encounters per person; the saved file
  is rewritten in full on every logout.

## Development

```bash
tools/junction.cmd
./tools/test.sh
```

## Licence

MIT, see [LICENSE](LICENSE).
