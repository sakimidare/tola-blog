#import "/templates/fuwari.typ": fuwari-base, post-card, empty-note
#import "@tola/pages:0.0.0": pages
#import "@tola/site:0.0.0": info

#show: fuwari-base.with(
  title: info.title,
  summary: info.description,
)

#let posts = pages().filter(p => "/posts/" in p.permalink and p.at("date", default: none) != none).sorted(key: p => {
  let date = p.at("date", default: none)
  str(if date == none { "" } else { date })
}).rev()
#context {
  let cards = if posts.len() == 0 {
    empty-note("暂无文章")
  } else {
    for item in posts { post-card(item) }
  }

  if target() == "html" {
    html.elem("section", attrs: (class: "post-list", "aria-label": "文章列表"))[
      #cards
    ]
  } else {
    cards
  }
}
