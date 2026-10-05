#import "/templates/fuwari.typ": fuwari-base, page-card, friend-list

#show: fuwari-base.with(
  title: "Friends",
  summary: "友情链接",
)

#let friend(name, href, avatar, description) = context {
  if target() == "html" {
    html.elem("a", attrs: (class: "friend-card", href: href, target: "_blank", rel: "noopener"), html.elem("img", attrs: (src: avatar, alt: name, loading: "lazy")) + html.elem("span", attrs: (class: "friend-card-content"), html.elem("strong", name) + html.elem("span", description)) + html.elem("span", attrs: (class: "friend-card-arrow"), "↗"))
  } else {
    [#strong[#name] — #description]
  }
}

#page-card[
  = Friends

  这里是友情链接。

  #friend-list[
    #friend("TheSky233's Blog", "https://thesky233.github.io/", "https://q1.qlogo.cn/g?b=qq&nk=1602458048&s=640", "And in that light...")
    #friend("日落果的 Blog", "https://blog.archlinux.tech/", "https://avatars.githubusercontent.com/u/37149302?v=4", "日落果的 Blog")
    #friend("風雪城", "https://blog.chyk.ink/", "https://q1.qlogo.cn/g?b=qq&nk=3526514925&s=640", "浩繁星空下的一场稚嫩的梦")
    #friend("Onear's Blog", "https://onear.eu.org", "https://q1.qlogo.cn/g?b=qq&nk=122441928&s=640", "Onear's Blog")
    #friend("Y11Han's ICU", "https://blog.y11han.icu", "https://q1.qlogo.cn/g?b=qq&nk=2172029629&s=640", "该病房一切内容不构成投资建议")
    #friend("井枝万事屋", "https://www.yorozumoon.cn/", "https://www.yorozumoon.cn/images/Moonhalf_head.png", "濂珠沉葬，玉碎琉璃")
    #friend("45dino's Blog", "https://blog.45dino.me/", "https://q1.qlogo.cn/g?b=qq&nk=2957283301&s=640", "45 dino's Blog")
  ]
]
