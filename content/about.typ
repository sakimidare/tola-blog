#import "/templates/fuwari.typ": fuwari-base, page-card, github-card

#show: fuwari-base.with(
  title: "About",
  summary: "关于这个博客",
)

#page-card[
  #context { if target() == "html" { heading(level: 1)[About] } }

  有人也许会以为，关于代码的书有点儿落后于时代——代码不再是问题；我们应当关注模型和需求。确实，有人说过我们正在临近代码的终结点。

  #quote[扯淡！我们永远抛不掉代码，因为代码呈现了需求的细节。将需求明确到机器可以执行的细节程度，就是编程要做的事，而这种规约正是代码。]

  我期待语言的抽象程度继续提升，也期待领域特定语言的数量继续增长。但这不会消除代码：只要仍然需要精确表达需求，代码就会存在。

  #github-card("sakimidare/sakimidare.github.io")

  == Sources

  - #link("https://x.com/Haru57928031/status/1553704618634670081/")[散々でいる - イラスト]
  - #link("https://x.com/Haru57928031/status/1738146268092672672/")[晴れのちラムネ]
  - #link("https://github.com/sakimidare")[SakiMidare on GitHub]
]
