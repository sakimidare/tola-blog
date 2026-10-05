#import "/templates/tola.typ": tola-page
#import "@tola/site:0.0.0": info
#import "@tola/pages:0.0.0": pages
#import "@tola/current:0.0.0": current-permalink, headings, prev, next

#let icon(name, class: "icon") = html.elem("iconify-icon", attrs: (icon: name, class: class, "aria-hidden": "true"))

#let _posts() = pages().filter(p => p.permalink.starts-with("/posts/") and p.at("date", default: none) != none).sorted(key: p => str(p.date)).rev()

#let _date(value) = if value == none { "" } else if type(value) == datetime { value.display("[year]-[month]-[day]") } else { str(value) }

#let _tag-url(tag) = "/archive/?tag=" + str(tag)
#let _category-url(category) = if category == none or category == "" { "/archive/?uncategorized=1" } else { "/archive/?category=" + str(category) }

#let _head(title: none, summary: none, image: none, article: false, date: none, update: none, tags: ()) = context {
  if target() != "html" { return [] }
  let page-title = if title == none or title == info.title { info.title + " - A personal blog site." } else { str(title) + " - " + info.title }
  let description = if summary == none or summary == "" { page-title } else { summary }
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

#let pdf-fonts = ("Noto Serif CJK SC",)
#let pdf-heading-fonts = ("Noto Sans CJK SC",)
#let pdf-mono-fonts = ("JetBrains Mono", "Noto Sans Mono CJK SC")

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
  set par(justify: true, leading: .85em, first-line-indent: 2em, spacing: 1.1em)
  show heading: set block(above: 1.4em, below: .7em)
  show heading: set text(font: pdf-heading-fonts)
  show heading.where(level: 1): set text(size: 18pt, weight: "bold")
  show heading.where(level: 2): set text(size: 14pt, weight: "bold")
  show heading.where(level: 3): set text(size: 12pt, weight: "bold")
  show link: set text(fill: rgb("#2563eb"))
  show raw.where(block: true): set block(fill: luma(246), inset: 9pt, radius: 4pt, width: 100%, above: .9em, below: .9em)
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

  if article {
    context {
      let entries = query(heading).filter(entry => entry.level <= 2)
      if entries.len() >= 3 {
        block(above: 1em, below: .7em)[
          #set text(size: 9pt, fill: luma(115))
          #text(weight: "bold", fill: luma(80))[目录]
          #v(.25em)
          #for entry in entries {
            linebreak()
            link(entry.location(), {
              if entry.level == 2 { h(1.1em) }
              entry.body
            })
          }
        ]
      }
    }
  }

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

#let _post-meta(date: none, update: none, category: none, tags: (), hide-tags-mobile: false) = {
  let meta-item(icon-name, body) = html.elem("div", attrs: (class: "meta-item"), html.elem("span", attrs: (class: "meta-icon"), icon(icon-name)) + body)
  let tag-content = {
    if tags.len() == 0 {
      html.elem("span", "无标签")
    } else {
      for (index, tag) in tags.enumerate() {
        if index > 0 { text(" / ") }
        html.elem("a", attrs: (href: "/archive", "data-href": _tag-url(tag)), str(tag))
      }
    }
  }
  html.elem("div", attrs: (class: "post-meta"))[
    #if date != none { meta-item("material-symbols:calendar-today-outline-rounded", html.elem("span", _date(date))) }
    #if update != none and _date(update) != _date(date) { meta-item("material-symbols:edit-calendar-outline-rounded", html.elem("span", _date(update))) }
    #meta-item("material-symbols:book-2-outline-rounded", html.elem("a", attrs: (href: "/archive", "data-href": _category-url(category)), if category == none or category == "" { "未分类" } else { str(category) }))
    #html.elem("div", attrs: (class: "meta-item" + if hide-tags-mobile { " meta-tags-optional" } else { "" }), html.elem("span", attrs: (class: "meta-icon"), icon("material-symbols:tag-rounded")) + html.elem("span", attrs: (class: "meta-tags"), tag-content))
  ]
}

#let post(title: none, summary: none, date: none, update: none, tags: (), category: none, image: none, draft: false, words: none, minutes: none, body) = {
  let all-posts = _posts()
  let previous = prev(all-posts)
  let following = next(all-posts)
  let navigation = context if target() == "html" {
    html.elem("nav", attrs: (class: "post-navigation", "aria-label": "文章导航"))[
      #if following != none { html.elem("a", attrs: (href: following.permalink, class: "post-nav-link post-nav-prev card-base"), icon("material-symbols:chevron-left-rounded") + html.elem("span", following.title)) }
      #if previous != none { html.elem("a", attrs: (href: previous.permalink, class: "post-nav-link post-nav-next card-base"), html.elem("span", previous.title) + icon("material-symbols:chevron-right-rounded")) }
    ]
  } else { [] }
  let license = context if target() == "html" {
    html.elem("section", attrs: (class: "post-license"))[
      #html.elem("strong", title)
      #html.elem("a", attrs: (class: "license-url", href: if current-permalink == none { "/" } else { current-permalink }), if current-permalink == none { "/" } else { str(current-permalink) })
      #html.elem("div", attrs: (class: "license-details"))[
        #html.elem("span", html.elem("small", "作者") + html.elem("span", info.author))
        #html.elem("span", html.elem("small", "发布于") + html.elem("span", _date(date)))
        #html.elem("span", html.elem("small", "许可证") + html.elem("a", attrs: (href: "https://creativecommons.org/licenses/by-nc-sa/4.0/", target: "_blank", rel: "noopener"), "CC BY-NC-SA 4.0"))
      ]
    ]
  } else { [] }
  let pdf-url = if current-permalink == none { none } else {
    let p = str(current-permalink)
    (if p.ends-with("/") { p.slice(0, p.len() - 1) } else { p }) + ".pdf"
  }
  let article-body = context if target() == "html" {
    [
      #html.elem("article", attrs: (id: "post-container", class: "post-container card-base"))[
        #if words != none or minutes != none { html.elem("div", attrs: (class: "post-stats onload-animation"))[#if words != none { html.elem("span", icon("material-symbols:notes-rounded") + str(words) + " 字") } #if minutes != none { html.elem("span", icon("material-symbols:schedule-outline-rounded") + str(minutes) + " 分钟") }] }
        #html.elem("header", attrs: (class: "post-header onload-animation"))[
          #html.elem("h1", title)
          #_post-meta(date: date, update: update, category: category, tags: tags)
          #if summary != none and summary != "" { html.elem("p", attrs: (class: "post-summary"), summary) }
        ]
        #if pdf-url != none {
          html.elem("div", attrs: (class: "post-actions"))[
            #html.elem("a", attrs: (class: "post-pdf btn-regular", href: pdf-url, download: ""), icon("material-symbols:download-rounded") + html.elem("span", "下载 PDF"))
          ]
        }
        #if image != none and image != "" { html.elem("img", attrs: (id: "post-cover", class: "post-cover onload-animation", src: image, alt: "文章封面")) }
        #html.elem("div", attrs: (class: "markdown-content onload-animation", "data-pagefind-body": ""), body)
        #license
      ]
      #html.elem("section", attrs: (id: "comments", class: "comments card-base", "aria-label": "评论"))
      #navigation
    ]
  } else { body }
  fuwari-base(article-body, title: title, summary: summary, date: date, update: update, tags: tags, category: category, image: image, draft: draft, words: words, minutes: minutes, article: true)
}

#let post-card(item) = {
  let href = item.at("permalink", default: "/")
  let title = item.at("title", default: "Untitled")
  let summary = item.at("summary", default: none)
  let date = item.at("date", default: none)
  let update = item.at("update", default: none)
  let tags = item.at("tags", default: ())
  let category = item.at("category", default: none)
  let image = item.at("image", default: none)
  let words = item.at("words", default: none)
  let minutes = item.at("minutes", default: none)
  if target() == "html" {
    html.elem("article", attrs: (class: "post-card card-base onload-animation"))[
      #html.elem("div", attrs: (class: "post-card-body"))[
        #html.elem("h2", html.elem("a", attrs: (href: href, class: "post-card-link"), title))
        #_post-meta(date: date, update: update, category: category, tags: tags, hide-tags-mobile: true)
        #if summary != none and summary != "" { html.elem("p", attrs: (class: "post-card-summary"), summary) }
        #if words != none or minutes != none { html.elem("div", attrs: (class: "post-card-stats"), (if words != none { str(words) + " 字" } else { "" }) + (if words != none and minutes != none { " | " } else { "" }) + (if minutes != none { str(minutes) + " 分钟阅读" } else { "" })) }
      ]
      #if image != none and image != "" {
        html.elem("a", attrs: (href: href, class: "post-card-cover", "aria-label": title), html.elem("img", attrs: (src: image, alt: "", loading: "lazy")) + html.elem("span", icon("material-symbols:chevron-right-rounded")))
      } else {
        html.elem("a", attrs: (href: href, class: "post-card-enter", "aria-label": title), icon("material-symbols:chevron-right-rounded"))
      }
    ]
  } else { block[#heading(level: 2)[#title] #if summary != none { summary }] }
}

// ---------------------------------------------------------------------------
// Simple content page (About / Friends): a card wrapping Markdown prose.
// ---------------------------------------------------------------------------
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
#let _admonition-title(kind) = if kind == "tip" { "提示" } else if kind == "important" { "重要" } else if kind == "warning" { "警告" } else if kind == "caution" { "注意" } else { "笔记" }

#let admonition(kind: "note", title: none, body) = context {
  if target() != "html" {
    body
  } else {
    html.elem("div", attrs: (class: "admonition admonition-" + kind))[
      #html.elem("div", attrs: (class: "admonition-title"), if title != none and title != "" { title } else { _admonition-title(kind) })
      #html.elem("div", attrs: (class: "admonition-body"), body)
    ]
  }
}

#let code-block(code, lang: "plain", title: none, line-numbers: false, start: 1) = context {
  if target() != "html" {
    raw(code, lang: lang, block: true)
  } else {
    let body = if line-numbers {
      let lines = code.split("\n")
      if lines.len() > 0 and lines.last() == "" { lines = lines.slice(0, lines.len() - 1) }
      html.elem("pre", attrs: (class: "line-numbers"))[
        #for (index, line) in lines.enumerate() {
          html.elem("span", attrs: (class: "code-line"))[
            #html.elem("span", attrs: (class: "code-line-no"), str(start + index))
            #raw(if line == "" { " " } else { line }, lang: lang)
          ]
        }
      ]
    } else {
      raw(code, lang: lang, block: true)
    }
    html.elem("div", attrs: (class: "code-block"))[
      #if title != none and title != "" { html.elem("div", attrs: (class: "code-block-head"), title) }
      #body
    ]
  }
}

#let quote-block(body) = context {
  if target() != "html" { quote(body) } else { html.elem("blockquote", body) }
}

#let content-image(src, alt: "") = context {
  if target() == "html" { html.elem("img", attrs: (src: src, alt: alt, loading: "lazy")) } else { image(src, width: 100%) }
}

#let hr-line() = context {
  if target() == "html" { html.elem("hr") } else { line(length: 100%, stroke: 0.5pt) }
}

#let empty-note(text) = context {
  if target() == "html" { html.elem("p", attrs: (class: "post-list-empty"), text) } else { text }
}

#let card-list(body) = context {
  if target() == "html" { html.elem("div", attrs: (class: "card-list"), body) } else { body }
}

#let github-card(repo) = context {
  let href = "https://github.com/" + repo
  let parts = repo.split("/")
  let owner = if parts.len() > 0 { parts.at(0) } else { repo }
  let name = if parts.len() > 1 { parts.at(1) } else { "" }
  if target() != "html" { link(href, repo) } else {
    html.elem("a", attrs: (class: "card-github", href: href, target: "_blank", rel: "noopener noreferrer", "data-repo": repo),
      html.elem("span", attrs: (class: "gc-titlebar"),
        html.elem("span", attrs: (class: "gc-titlebar-left"),
          html.elem("span", attrs: (class: "gc-owner"),
            html.elem("span", attrs: (class: "gc-avatar")) + html.elem("span", attrs: (class: "gc-user"), owner))
          + html.elem("span", attrs: (class: "gc-divider"), "/")
          + html.elem("span", attrs: (class: "gc-repo"), name))
        + html.elem("span", attrs: (class: "github-logo")))
      + html.elem("span", attrs: (class: "gc-description"), "Waiting for api.github.com...")
      + html.elem("span", attrs: (class: "gc-infobar"),
          html.elem("span", attrs: (class: "gc-stars"), "0")
          + html.elem("span", attrs: (class: "gc-forks"), "0")
          + html.elem("span", attrs: (class: "gc-license"), "no-license")
          + html.elem("span", attrs: (class: "gc-language"), "")))
  }
}

#let link-card(href, title, avatar: none, description: none) = context {
  if target() != "html" { link(href, title) } else {
    let avatar-node = if avatar != none and avatar != "" {
      html.elem("span", attrs: (class: "hc-avatar", style: "background-image:url('" + avatar + "');"))
    } else {
      html.elem("span", attrs: (class: "hc-avatar"))
    }
    html.elem("a", attrs: (class: "card-hyperlink", href: href, target: "_blank", rel: "noopener noreferrer"),
      html.elem("span", attrs: (class: "hc-titlebar"), avatar-node + html.elem("span", attrs: (class: "hc-title"), title))
      + html.elem("span", attrs: (class: "hc-description"), if description == none { "" } else { description }))
  }
}

// ---------------------------------------------------------------------------
// Archive timeline, grouped by year.
// ---------------------------------------------------------------------------
#let _short-date(value) = {
  let s = str(value)
  if s.len() >= 10 { s.slice(5, 10) } else { s }
}

#let _year-of(value) = {
  let s = str(value)
  if s.len() >= 4 { s.slice(0, 4) } else { s }
}

#let _tag-string(tags) = {
  let parts = ()
  for tag in tags { parts.push("#" + str(tag)) }
  parts.join(" ")
}

#let archive-panel(posts) = context {
  if target() != "html" {
    return for item in posts {
      link(item.permalink, item.at("title", default: "Untitled"))
      linebreak()
    }
  }
  let years = ()
  let buckets = (:)
  for item in posts {
    let year = _year-of(item.at("date", default: ""))
    if year not in years { years.push(year) }
    buckets.insert(year, buckets.at(year, default: ()) + (item,))
  }
  let groups = {
    for year in years {
      let items = buckets.at(year)
      html.elem("section", attrs: (class: "archive-group"))[
        #html.elem("div", attrs: (class: "archive-year-row"), html.elem("span", attrs: (class: "archive-year"), year) + html.elem("span", attrs: (class: "archive-dot")) + html.elem("span", attrs: (class: "archive-count"), str(items.len()) + " 篇文章"))
        #html.elem("div", attrs: (class: "archive-items"))[
          #for item in items {
            let tags = item.at("tags", default: ())
            let tag-list = if type(tags) == array { tags } else { () }
            let category = item.at("category", default: none)
            let data-tags = tag-list.fold("", (acc, t) => acc + (if acc == "" { "" } else { " " }) + str(t))
            let data-category = if category == none { "" } else { str(category) }
            let attrs = (
              class: "archive-item",
              href: str(item.at("permalink", default: "/")),
              "aria-label": str(item.at("title", default: "Untitled")),
              "data-tags": data-tags,
              "data-category": data-category,
            )
            html.elem("a", attrs: attrs,
              html.elem("span", attrs: (class: "archive-date"), _short-date(item.at("date", default: "")))
              + html.elem("span", attrs: (class: "archive-line"), html.elem("span", attrs: (class: "archive-item-dot")))
              + html.elem("span", attrs: (class: "archive-title"), item.at("title", default: "Untitled"))
              + html.elem("span", attrs: (class: "archive-tags"), _tag-string(tags))
            )
          }
        ]
      ]
    }
  }
  html.elem("div", attrs: (class: "archive-page card-base onload-animation"), if posts.len() == 0 { html.elem("p", attrs: (class: "post-list-empty"), "暂无文章") } else { groups })
}
