// Exercises every component with its defaults, including the optional
// arguments the example resume does not reach.

#import "../src/lib.typ": item-grid, project-entry, resume, resume-header, section-header, timeline-entry

#show: resume

#resume-header(
  name: "Ada Lovelace",
  contacts: (
    "ada@example.com",
    "(555) 123-4567",
    "github.com/ada",
    "London, UK",
    // Content is passed through untouched, so a contact can be styled by hand.
    link("https://example.com")[personal site],
  ),
)

#section-header("Flat Grid")

#item-grid(items: ([One], [Two], [Three]), columns: 3)

#section-header("Single Column")

#item-grid(items: ([Only item],), columns: 1)

#section-header("Categorized Grid", extra: "(2020 – 2024)")

#item-grid(
  items: (
    (category: "Languages", text: [Typst, Rust]),
    (category: "Tools", text: [git, make]),
  ),
)

// An empty grid must render nothing at all rather than an empty row.
#item-grid(items: ())

#section-header("Entries")

// Headings only.
#timeline-entry(heading-left: "Left only")

#timeline-entry(
  heading-left: "Both headings",
  heading-right: "2024",
)

// A single subheading still produces the second row.
#timeline-entry(
  heading-left: "Subheading on one side",
  heading-right: "2023",
  subheading-left: "Title",
)

#timeline-entry(
  heading-left: "Everything",
  heading-right: "2022",
  subheading-left: "Title",
  subheading-right: "Place",
  body: [
    - A bullet, which picks up the square marker.
    - Another one, long enough to wrap onto a second line so that the hanging
      indent under the marker can be checked.
      - A nested bullet.
    + A numbered item, which keeps Typst's own styling.
  ],
)

#section-header("Projects")

// A linked URL, a plain annotation and no annotation at all.
#project-entry(
  name: "Linked",
  url: "https://example.com/project",
  body: [- Body of a project entry.],
)

#project-entry(name: "Unlinked", url: "<closed source>")

#project-entry(name: "No annotation", body: [- Still has a body.])

// Markup headings render exactly like the components, since the styling lives
// in show rules rather than in the components themselves.
== Markup Section

#timeline-entry(heading-left: "After a markup heading", heading-right: "2021")

// The builtin `table` is still reachable: the package no longer shadows it.
#table(columns: 2, [a], [b], [c], [d])
