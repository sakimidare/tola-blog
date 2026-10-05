#import "/templates/fuwari.typ": fuwari-base, page-card, card-list, link-card

#show: fuwari-base.with(
  title: "Friends",
  summary: "友情链接",
)

#page-card[
  #context { if target() == "html" { heading(level: 1)[Friends] } }

  这里是友情链接。

  #card-list[
    #link-card("https://thesky233.github.io/", "TheSky233's Blog", avatar: "http://q1.qlogo.cn/g?b=qq&nk=1602458048&s=640", description: "And in that light...")
    #link-card("https://blog.archlinux.tech/", "日落果的 Blog", avatar: "https://avatars.githubusercontent.com/u/37149302?v=4", description: "日落果的 Blog")
    #link-card("https://blog.chyk.ink/", "風雪城", avatar: "https://q1.qlogo.cn/g?b=qq&nk=3526514925&s=640", description: "浩繁星空下的一场稚嫩的梦")
    #link-card("https://onear.eu.org", "Onear's Blog", avatar: "https://q1.qlogo.cn/g?b=qq&nk=122441928&s=640", description: "Onear's Blog")
    #link-card("https://blog.y11han.icu", "Y11Han's ICU", avatar: "https://q1.qlogo.cn/g?b=qq&nk=2172029629&s=640", description: "该病房一切内容不构成投资建议")
    #link-card("https://www.yorozumoon.cn/", "井枝万事屋", avatar: "https://www.yorozumoon.cn/images/Moonhalf_head.png", description: "濂珠沉葬，玉碎琉璃")
    #link-card("https://blog.45dino.me/", "45dino's Blog", avatar: "https://q1.qlogo.cn/g?b=qq&nk=2957283301&s=640", description: "45 dino's Blog")
  ]
]
