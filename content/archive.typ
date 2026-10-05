#import "/templates/fuwari.typ": fuwari-base, archive-panel
#import "@tola/pages:0.0.0": pages

#let posts = pages().filter(p => p.permalink.starts-with("/posts/") and p.at("date", default: none) != none).sorted(key: p => str(p.date)).rev()

#show: fuwari-base.with(
  title: "Archive",
  summary: "文章归档",
)

#archive-panel(posts)
