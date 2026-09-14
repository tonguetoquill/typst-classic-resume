// A categorized grid needs both `category` and `text` on every item.
#import "../../src/lib.typ": item-grid, resume
#show: resume
#item-grid(items: ((category: "Cat", text: [Text]), (category: "No text",)))
