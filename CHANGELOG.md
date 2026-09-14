# Changelog

## 0.2.0

### Breaking

- **`table` is now `item-grid`.** The old name shadowed Typst's built-in `table`
  element for anyone importing the package, which broke `#table(..)` and
  `show table:` rules in their own document. The parameters are unchanged, so
  the migration is a rename:

  ```diff
  -#import "@preview/ttq-classic-resume:0.1.0": .., table, ..
  +#import "@preview/ttq-classic-resume:0.2.0": .., item-grid, ..

  -#table(items: (..), columns: 2)
  +#item-grid(items: (..), columns: 2)
  ```

- **`config` is no longer exported.** It was a module-level constant, so
  assigning to it had no effect on the output. Settings are now passed to the
  show rule and reach the components from there:

  ```diff
  -#show: resume
  +#show: resume.with(size: 11pt, margin: 0.75in)
  ```

  The defaults are still readable, as `default-config`. An unknown option is now
  an error instead of being ignored.

- `section-header`'s `extra` is uppercased along with the title, so that a
  section title reads consistently.

### Fixed

- **Bullets are back on the baseline.** The square marker was offset half an em
  *below* the baseline, which left it hanging between lines and inflated the
  descent of every first line, adding a gap between list items that the design
  never had. The example resume now takes 2 pages instead of 3 with no content
  removed.

- **The template no longer depends on fonts that may not exist.** Project URLs
  asked for Courier New, which is absent on most Linux machines and in CI, so
  every compile emitted an `unknown font family` warning and silently fell back.
  The body font is now a fallback chain ending in faces Typst ships with, and
  the URL annotation follows the body font unless `annotation-font` says
  otherwise.

### Added

- **Accessible PDF output.** The name and the section titles are real headings
  now, so the PDF has a structure tree and an outline instead of bold text that
  only looks like a heading. The example resume passes `--pdf-standard ua-1`.
  Because the styling lives in show rules, `=` and `==` markup renders exactly
  like `resume-header` and `section-header`.

- **PDF metadata.** `resume-header` sets the document title and author from the
  name; both can be overridden or suppressed with its `title` and `author`
  parameters.

- **Linked contacts.** Contacts that look like an email address, a web address
  or a phone number become links in the PDF. Pass `link-contacts: false` to turn
  this off, or pass content instead of a string to opt a single contact out.

- A test suite (`scripts/test.sh`) covering every component, every configuration
  key and the error cases, run by CI against the oldest and newest supported
  Typst releases. Warnings are treated as failures.

### Changed

- `src/` is split into `config.typ`, `layout.typ`, `components.typ` and
  `util.typ`; `timeline-entry` and `project-entry` now share one implementation.
- The gap between a section rule and the first entry below it grew by 2pt: it
  used to be produced by an undocumented negative spacer that no configuration
  could reach.
- `scripts/build.sh` also refreshes `thumbnail.png`, and the two release-branch
  workflows were merged into one matrix job.

## 0.1.0

- Initial release.
