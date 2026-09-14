// Checks that every key of `default-config` can be overridden through
// `resume.with(..)` and that the overrides reach the components.

#import "../src/lib.typ": default-config, item-grid, project-entry, resume, resume-header, section-header, timeline-entry

#show: resume.with(
  font: ("Libertinus Serif",),
  size: 10pt,
  paper: "a4",
  margin: 1in,
  leading: 0.8em,
  section-spacing: 12pt,
  entry-spacing: 10pt,
  name-size: 24pt,
  contact-separator: "|",
  contact-separator-size: 10pt,
  rule-stroke: 2pt + gray,
  marker-size: 6pt,
  marker-baseline: -0.15em,
  marker-indent: 1.5em,
  annotation-font: ("DejaVu Sans Mono",),
  annotation-size: 7pt,
)

// Every key must be accepted, or `resume` would have panicked above.
#assert(
  default-config.keys().len() == 16,
  message: "update this test when a configuration key is added or removed",
)

#resume-header(
  name: "Configured",
  contacts: ("one@example.com", "two"),
  // Metadata can be steered independently of the displayed name.
  title: "Configured — Resume",
  author: "Someone Else",
  link-contacts: false,
)

#section-header("Overrides")

#item-grid(items: ([Wider markers], [Larger gutters]))

#timeline-entry(
  heading-left: "Entry",
  heading-right: "2024",
  subheading-left: "Role",
  subheading-right: "Place",
  body: [- The marker and its indent both follow the configuration.],
)

#project-entry(name: "Monospaced annotation", url: "https://example.com")
