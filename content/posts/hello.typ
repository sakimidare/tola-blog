#import "/templates/fuwari.typ": post

#show: post.with(
  title: "Hello",
  date: "2026-10-05",
  tags: ("test",),
  category: "Tests",
  summary: "Tola 主题迁移验证文章。",
  words: 8,
  minutes: 1,
)

This is the article body.

== A small section

This section exists to verify the table of contents.

$ x = 1 $
