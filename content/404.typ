#import "/templates/fuwari.typ": fuwari-base, page-card

#show: fuwari-base.with(
  title: "404",
  summary: "页面未找到",
)

#page-card[
  #context { if target() == "html" { heading(level: 1)[404] } }

  你访问的页面不存在，或者已经被移动。

  - #link("/")[返回首页]
  - #link("/archive/")[查看归档]
]
