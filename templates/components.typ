// Reusable content components for page sources.
// Usage: #import "/templates/components.typ": quote-block, ruby, ...

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

#let quote-block(body) = context {
  if target() != "html" { quote(body) } else { html.elem("blockquote", body) }
}

#let anchor(id) = context {
  if target() == "html" { html.elem("a", attrs: (id: id)) } else { [] }
}

#let content-image(src, alt: "") = context {
  if target() == "html" { html.elem("img", attrs: (src: src, alt: alt, loading: "lazy")) } else { image(src, width: 100%) }
}

#let ruby(base, reading) = context {
  if target() == "html" {
    html.elem("ruby", base + html.elem("rt", reading))
  } else {
    box(stack(
      dir: ttb,
      spacing: 0.08em,
      align(center, move(dy: -0.12em, text(size: 0.5em, reading))),
      align(center, base),
    ))
  }
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
