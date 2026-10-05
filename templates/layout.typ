// Layout, site chrome and page frame.
#import "/templates/tola.typ": tola-page
#import "@tola/site:0.0.0": info
#import "@tola/pages:0.0.0": pages

#let stats-data = json("stats.json")
#let stats-of(permalink) = if permalink == none { (:) } else { stats-data.at(permalink, default: (:)) }

#let icon(name, class: "icon") = html.elem("iconify-icon", attrs: (icon: name, class: class, "aria-hidden": "true"))

#let _posts() = pages().filter(p => p.permalink.starts-with("/posts/") and p.at("date", default: none) != none).sorted(key: p => str(p.date)).rev()

#let _date(value) = if value == none { "" } else if type(value) == datetime { value.display("[year]-[month]-[day]") } else { str(value) }

#let _tag-url(tag) = "/archive/?tag=" + str(tag)

#let _category-url(category) = if category == none or category == "" { "/archive/?uncategorized=1" } else { "/archive/?category=" + str(category) }

#let _head(title: none, summary: none, image: none, article: false, date: none, update: none, tags: ()) = context {
  if target() != "html" { return [] }
  let page-title = if title == none or title == info.title { info.title + " - A personal blog site." } else { str(title) + " - " + info.title }
  let description = if summary == none or summary == "" { page-title } else { summary }
  html.elem("meta", attrs: (charset: "utf-8"))
  html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
  html.elem("title")[#page-title]
  html.meta(name: "description", content: description)
  html.meta(name: "author", content: info.author)
  html.elem("meta", attrs: (property: "og:type", content: if article { "article" } else { "website" }))
  html.elem("meta", attrs: (property: "og:site_name", content: info.title))
  html.elem("meta", attrs: (property: "og:title", content: page-title))
  html.elem("meta", attrs: (property: "og:description", content: description))
  if image != none and image != "" { html.elem("meta", attrs: (property: "og:image", content: image)) }
  html.meta(name: "twitter:card", content: if image == none or image == "" { "summary" } else { "summary_large_image" })
  if article and date != none { html.elem("meta", attrs: (property: "article:published_time", content: _date(date))) }
  if article and update != none { html.elem("meta", attrs: (property: "article:modified_time", content: _date(update))) }
  for tag in tags { html.elem("meta", attrs: (property: "article:tag", content: str(tag))) }
}

#let _nav-link(href, label, external: false) = {
  let attrs = (href: href)
  let extra = html.elem("span", attrs: (class: "nav-label"), label)
  if external {
    attrs.insert("target", "_blank")
    attrs.insert("rel", "noopener")
    extra = extra + icon("fa6-solid:arrow-up-right-from-square", class: "external-icon")
  }
  html.elem("a", attrs: attrs, extra)
}

#let _navbar() = html.elem("div", attrs: (id: "top-row", class: "top-row"))[
  #html.elem("div", attrs: (id: "navbar-wrapper", class: "navbar-wrapper"))[
    #html.elem("header", attrs: (id: "navbar", class: "navbar card-base onload-animation"))[
      #html.elem("a", attrs: (class: "brand btn-plain", href: "/", "aria-label": "主页"), icon("material-symbols:home-outline-rounded") + html.elem("span", attrs: (class: "brand-name"), info.title))
      #html.elem("nav", attrs: (class: "nav-links", "aria-label": "主导航"))[
        #_nav-link("/", "主页")
        #_nav-link("/archive/", "归档")
        #_nav-link("/about/", "关于")
        #_nav-link("/friends/", "友链")
        #_nav-link("https://c.sakimidare.top", "C Programming", external: true)
      ]
      #html.elem("div", attrs: (class: "nav-actions"))[
        #html.elem("label", attrs: (id: "desktop-search", class: "desktop-search"))[#icon("material-symbols:search-rounded") #html.elem("input", attrs: (id: "desktop-search-input", type: "search", placeholder: "你好", autocomplete: "off", "aria-label": "搜索文章"))]
        #html.elem("button", attrs: (id: "search-switch", class: "nav-button search-switch btn-plain", type: "button", "aria-label": "搜索", "aria-expanded": "false"), icon("material-symbols:search-rounded"))
        #html.elem("button", attrs: (id: "display-settings-switch", class: "nav-button btn-plain", type: "button", "aria-label": "显示设置", "aria-expanded": "false"), icon("material-symbols:palette-outline"))
        #html.elem("button", attrs: (id: "theme-toggle", class: "nav-button theme-toggle btn-plain", type: "button", "aria-label": "切换主题"), icon("material-symbols:wb-sunny-outline-rounded", class: "theme-icon theme-icon-light") + icon("material-symbols:dark-mode-outline-rounded", class: "theme-icon theme-icon-dark") + icon("material-symbols:radio-button-partial-outline", class: "theme-icon theme-icon-auto"))
        #html.elem("button", attrs: (id: "nav-menu-switch", class: "nav-button menu-switch btn-plain", type: "button", "aria-label": "菜单", "aria-expanded": "false"), icon("material-symbols:menu-rounded"))
      ]
      #html.elem("div", attrs: (id: "search-panel", class: "float-panel search-panel is-closed"))[
        #html.elem("label", attrs: (class: "search-field"), icon("material-symbols:search-rounded") + html.elem("input", attrs: (id: "search-input", type: "search", placeholder: "搜索文章", autocomplete: "off")))
        #html.elem("div", attrs: (id: "search-results", class: "search-results"))
      ]
      #html.elem("div", attrs: (id: "display-setting", class: "float-panel display-setting is-closed"))[
        #html.elem("strong", "主题色")
        #html.elem("input", attrs: (id: "color-slider", type: "range", min: "0", max: "360", step: "5", "aria-label": "主题色"))
      ]
      #html.elem("nav", attrs: (id: "nav-menu-panel", class: "float-panel mobile-menu is-closed", "aria-label": "移动端导航"))[
        #_nav-link("/", "主页") #_nav-link("/archive/", "归档") #_nav-link("/about/", "关于") #_nav-link("/friends/", "友链") #_nav-link("https://c.sakimidare.top", "C Programming", external: true)
      ]
    ]
  ]
]

#let _profile() = html.elem("section", attrs: (class: "profile card-base"))[
  #html.elem("a", attrs: (href: "/about/", class: "avatar-link", "aria-label": "关于作者"), html.elem("span", attrs: (class: "avatar-overlay"), icon("fa6-regular:address-card")) + html.elem("img", attrs: (class: "avatar", src: "/assets/images/avatar.jpeg", alt: "SakiMidare")))
  #html.elem("div", attrs: (class: "profile-body"))[
    #html.elem("strong", attrs: (class: "profile-name"), info.author)
    #html.elem("span", attrs: (class: "profile-accent"))
    #html.elem("p", attrs: (class: "profile-bio"), "心臓は点滅するかしら……")
    #html.elem("div", attrs: (class: "profile-links"))[
      #html.elem("a", attrs: (href: "mailto:sakimidare@outlook.com", rel: "me", "aria-label": "Email"), icon("material-symbols:mail-rounded"))
      #html.elem("a", attrs: (href: "https://space.bilibili.com/285741399", target: "_blank", rel: "me noopener", "aria-label": "Bilibili"), icon("fa6-brands:bilibili"))
      #html.elem("a", attrs: (href: "https://github.com/sakimidare", target: "_blank", rel: "me noopener", "aria-label": "GitHub"), icon("fa6-brands:github"))
    ]
  ]
]

#let _widget(title, id, body) = html.elem("section", attrs: (id: id, class: "sidebar-widget card-base onload-animation"))[
  #html.elem("h2", attrs: (class: "widget-title"), title)
  #html.elem("div", attrs: (class: "widget-content"), body)
]

#let _sidebar() = context {
  let posts = _posts()
  let categories = (:)
  let tags = ()
  for item in posts {
    let category = item.at("category", default: none)
    let key = if category == none or category == "" { "未分类" } else { str(category) }
    categories.insert(key, categories.at(key, default: 0) + 1)
    for tag in item.at("tags", default: ()) { if tag not in tags { tags.push(tag) } }
  }
  let category-links = {
    for category in categories.keys().sorted() {
      html.elem("a", attrs: (class: "widget-link", href: "/archive", "data-href": _category-url(if category == "未分类" { none } else { category })), html.elem("span", category) + html.elem("span", attrs: (class: "count-badge"), str(categories.at(category))))
    }
  }
  let tag-links = { for tag in tags.sorted() { html.elem("a", attrs: (class: "tag-button", href: "/archive", "data-href": _tag-url(tag)), str(tag)) } }
  html.elem("aside", attrs: (id: "sidebar", class: "sidebar onload-animation"))[
    #_profile()
    #html.elem("div", attrs: (id: "sidebar-sticky", class: "sidebar-sticky"))[
      #if categories.len() > 0 { _widget("分类", "categories", category-links) }
      #if tags.len() > 0 { _widget("标签", "tags", tag-links) }
    ]
  ]
}

#let _banner() = html.elem("div", attrs: (id: "banner-wrapper", class: "banner-wrapper"))[
  #html.elem("img", attrs: (id: "banner", src: "/assets/images/banner1.jpeg", alt: "博客横幅", class: "banner-image"))
]

#let _footer() = html.elem("footer", attrs: (class: "footer onload-animation"), html.elem("span", "© " + info.author) + html.elem("span", attrs: ("aria-hidden": "true"), "·") + html.elem("a", attrs: (href: "/feed.xml"), "RSS"))

#let _toc() = {
  html.elem("aside", attrs: (id: "toc", class: "toc-wrapper"))[
    #html.elem("nav", attrs: (class: "toc", "aria-label": "文章目录"))[
      #html.elem("div", attrs: (id: "toc-list", class: "toc-list"))
    ]
  ]
}

#let pdf-fonts = ("Source Han Serif", "Noto Serif SC", "Noto Serif CJK SC")

#let pdf-heading-fonts = ("Source Han Serif", "Noto Serif SC", "Noto Serif CJK SC")

#let pdf-mono-fonts = ("JetBrains Mono", "Noto Sans Mono CJK SC", "Noto Serif SC")

#let _join-strings(list) = list.fold("", (acc, item) => acc + (if acc == "" { "" } else { ", " }) + str(item))

#let paged-doc(title: none, date: none, update: none, tags: (), category: none, summary: none, article: false, body) = {
  set page(
    paper: "a4",
    margin: (x: 2.2cm, top: 2.3cm, bottom: 2.4cm),
    numbering: none,
    footer: context [
      #set text(size: 8pt, fill: luma(130))
      #line(length: 100%, stroke: .4pt + luma(210))
      #v(3pt)
      #grid(
        columns: (1fr, 1fr),
        align: (left + horizon, right + horizon),
        [#info.title],
        [第 #counter(page).display() 页],
      )
    ],
  )
  set text(font: pdf-fonts, size: 10.5pt, lang: "zh", region: "cn")
  set par(justify: true, leading: .85em, first-line-indent: 0em, spacing: 1.1em)
  show heading: set block(above: 1.4em, below: .7em)
  show heading: set text(font: pdf-heading-fonts)
  show heading.where(level: 1): set text(size: 18pt, weight: "bold")
  show heading.where(level: 2): set text(size: 14pt, weight: "bold")
  show heading.where(level: 3): set text(size: 12pt, weight: "bold")
  show link: set text(fill: rgb("#2563eb"))
  show raw.where(block: true): set block(fill: none, inset: (x: 0pt, y: .3em), radius: 0pt, width: 100%, above: .9em, below: .9em, stroke: none)
  show raw.where(block: true): set text(font: pdf-mono-fonts, size: 8.5pt, lang: "en")
  show raw.where(block: false): it => box(fill: luma(240), inset: (x: .3em, y: .12em), radius: 2pt, text(font: pdf-mono-fonts, size: .9em, lang: "en", it))
  show list: set par(first-line-indent: 0em)
  show enum: set par(first-line-indent: 0em)
  show table.cell: set align(left)
  show table: set text(size: 9pt)
  show quote: it => block(
    inset: (left: .9em),
    stroke: (left: 2pt + luma(200)),
    text(fill: luma(85), it.body),
  )
  show figure: set block(above: 1em, below: 1em)

  if title != none {
    let meta = ()
    if date != none { meta.push(_date(date)) }
    if update != none { meta.push("更新于 " + _date(update)) }
    if category != none and category != "" { meta.push(str(category)) }
    if tags.len() > 0 { meta.push(_join-strings(tags)) }
    let meta-text = meta.join(" · ")
    block(spacing: .5em)[
      #text(size: 21pt, weight: "bold")[#title]
      #v(.4em)
      #if meta-text != "" { text(meta-text, size: 9pt, fill: luma(115)) }
    ]
    v(.5em)
    line(length: 100%, stroke: .6pt + luma(200))
  }

  if summary != none and summary != "" {
    v(.9em)
    block(inset: (left: .8em), stroke: (left: 2pt + luma(205)))[
      #text(size: 10pt, fill: luma(95))[#summary]
    ]
  }
  v(.6em)

  body

  if article {
    v(1.6em)
    line(length: 100%, stroke: .4pt + luma(210))
    v(.3em)
    text(size: 8.5pt, fill: luma(120))[作者 #info.author　·　许可证 CC BY-NC-SA 4.0]
  }
}

#let fuwari-base(body, title: none, summary: none, date: none, update: none, tags: (), category: none, image: none, draft: false, words: none, minutes: none, article: false) = {
  let view = context {
    if target() == "html" {
      html.elem("div", attrs: (class: "site-shell", "data-page-kind": if article { "post" } else { "page" }))[
        #_navbar()
        #_banner()
        #html.elem("div", attrs: (class: "main-stage"))[
          #html.elem("div", attrs: (id: "main-grid", class: "main-grid"))[
            #_sidebar()
            #html.elem("main", attrs: (id: "swup-container", class: "main-column transition-swup-fade"))[
              #html.elem("div", attrs: (id: "content-wrapper", class: "content-wrapper onload-animation"), body)
              #_footer()
            ]
          ]
          #if article { _toc() } else { html.elem("div", attrs: (id: "toc")) }
          #html.elem("button", attrs: (id: "back-to-top-btn", class: "back-to-top hide", type: "button", "aria-label": "返回顶部"), icon("material-symbols:keyboard-arrow-up-rounded"))
        ]
      ]
    } else {
      [
        #show: paged-doc.with(title: title, date: date, update: update, tags: tags, category: category, summary: summary, article: article)
        #body
      ]
    }
  }
  tola-page(title: title, summary: summary, date: date, update: update, tags: tags, draft: draft, words: words, minutes: minutes, category: category, image: image, head: _head(title: title, summary: summary, image: image, article: article, date: date, update: update, tags: tags))[#view]
}

#let page-card(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (class: "page-card card-base"), html.elem("div", attrs: (class: "markdown-content page-content", "data-pagefind-body": ""), body))
  } else {
    body
  }
}

// ---------------------------------------------------------------------------
// Content components used by migrated Markdown posts.
// ---------------------------------------------------------------------------
