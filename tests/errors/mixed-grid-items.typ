// A categorized item cannot be mixed with plain ones.
#import "../../src/lib.typ": item-grid, resume
#show: resume
#item-grid(items: ([Plain], (category: "Cat", text: [Text])))
