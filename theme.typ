// 简化版主题配置

// 默认配置
#let default-config = (
  // 字体
  serif-family: ("Times New Roman", "FandolSong"),
  sans-family: ("FandolHei"),
  font-size: 14pt,

  // 页面边距
  margin: (
    top: 2.5cm,
    bottom: 2.5cm,
    left: 2cm,
    right: 2cm
  ),

  // Git 历史
  git-title: "文档版本修改历史",
  git-show: true,
  git-max-entries: 20,

  // 目录
  outline-title: "目录",
  outline-levels: (2, 3, 4),

  // 样式
  primary-color: rgb(139, 0, 0),
  link-color: rgb(139, 0, 0),

  // 页码配置
  footer-show: true,
  footer-format: "第 {page} 页",  // 可选: "第 {page} 页，共 {total} 页", "{page}", "{page} / {total}"
  footer-alignment: center,       // 可选: left, center, right
  footer-line: true,              // 是否显示页脚上方的分割线
)

// 全局变量
#let global-font-size = state("global-font-size", 12pt)

#let Figure(content, caption: none, size: none, kind: auto) = {
  {
    if size != none {
      show figure.caption: set text(size: size)
      figure(content, caption: caption, kind: kind)
    } else {
      context{
        show figure.caption: set text(global-font-size.get())
        figure(content, caption: caption, kind: kind)
      }
    }
  }
}

// Git 历史组件
#let _show-git-history(config: default-config) = {
  if not config.git-show { return }

  let git-log = json("git_log.json")
  if git-log.len() == 0 { return }

  let entries = git-log.slice(0, calc.min(config.git-max-entries, git-log.len()))

  heading(level: 1, outlined: false)[#config.git-title]

  table(
    columns: (auto, auto, 1fr),
    fill: (x, y) => if y == 0 { config.primary-color.lighten(80%) },
    [版本时间], [哈希], [版本信息],
    ..entries.map(commit => (
      commit.time,
      commit.hash.slice(0, 7),
      commit.msg
    )).flatten()
  )
}

// 目录组件
#let _show-outline(config: default-config) = {
  let targets = config.outline-levels.map(level => heading.where(level: level))
  let target = targets.fold(targets.at(0), (acc, t) => acc.or(t))

  outline(
    title: config.outline-title,
    target: target,
    indent: n => (n - 1) * 2em
  )

  pagebreak()
}

// 页脚组件
#let _create-footer(config: default-config) = {
  if not config.footer-show { return none }
  
  let footer-content = context {
    let current-page = counter(page).display()
    let page-text = if "total" in config.footer-format {
      let total-pages = locate(loc => counter(page).final(loc).first())
      config.footer-format
        .replace("{page}", str(current-page))
        .replace("{total}", str(total-pages))
    } else {
      config.footer-format.replace("{page}", str(current-page))
    }
    
    if config.footer-line {
      [
        #line(length: 100%, stroke: 0.5pt + black)
        #v(-.5em)
        #align(config.footer-alignment)[#text(size: 0.9em)[#page-text]]
      ]
    } else {
      align(config.footer-alignment)[#text(size: 0.9em)[#page-text]]
    }
  }
  
  footer-content
}

// 快速文档设置
#let setup-document(
  body,
  title: none,
  show-git-history: true,
  show-outline: true,
  config: (:)
) = {
  let config = default-config + config

  set page(
    margin: config.margin,
    footer: none
  )

  set text(
    font: config.serif-family,
    size: config.font-size
  )

  set par(
    leading: 1.2em,     // 行距
    spacing: 1.2em,   // 段落之间的间距
    justify: true,    // 文本两端对齐
    first-line-indent: (amount: 2em, all: true), // 首行缩进
    linebreaks: "optimized",
  )

  show link: it => text(
    config.link-color,
    underline(stroke: 2pt, offset: 1.5pt, evade: false, it)
  )

  show heading: it => {
    set text(fill: config.primary-color, font: config.sans-family)
    it
    v(0.3em)
  }

  if show-git-history {
    _show-git-history(config: config)
    v(1em)
  }

  show outline.entry: it => {
    if it.level == 2 {
      v(0.2em)
    }
    it
    if it.level == 2 {
      v(0.2em)
    } else if it.level == 3 {
      v(0.2em)
    }
  }

  if show-outline {
    _show-outline(config: config)
  }

  counter(page).update(1)
  set page(footer: _create-footer(config: config))

  if title != none {
    align(center)[= #title]
    v(1em)
  }

  set figure(supplement: "图")
  global-font-size.update(config.font-size)

  show figure: set box(
    stroke: ( thickness: 0.5pt, paint: rgb("#3070b3"), join: "round",),
    radius: 2pt,
    inset: 4pt,
    fill: rgb("#f9f9fb")
  )

  {
    set heading(numbering: (..nums) => {
      if nums.pos().len() >= 2 {
        nums.pos().slice(1).map(str).join(".") + "."
      }
    })

    body
  }
}
