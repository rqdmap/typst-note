// 简化版主题配置

// 默认配置
#let default-config = (
  // 字体
  font-family: ("Times New Roman", "SimSun"),
  font-size: 12pt,

  // Git 历史
  git-title: "文档版本修改历史",
  git-show: true,
  git-max-entries: 20,

  // 目录
  outline-title: "目录",
  outline-levels: (2, 3, 4),

  // 样式
  primary-color: rgb(0, 0, 0),
  link-color: rgb(139, 0, 0),
)

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

// 快速文档设置
#let setup-document(
  body,
  title: none,
  show-git-history: true,
  show-outline: true,
  config: (:)
) = {
  let config = default-config + config

  set text(
    font: config.font-family,
    size: config.font-size
  )

  set par(
    leading: 1em,     // 行距
    spacing: 1.2em,   // 段落之间的间距
    justify: true,    // 文本两端对齐
    first-line-indent: (amount: 1.5em, all: true), // 首行缩进
  )

  show link: it => text(
    config.link-color,
    underline(stroke: 2pt, offset: 1.5pt, evade: false, it)
  )

  show heading: it => {
    set text(fill: config.primary-color, weight: "regular")
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

  if title != none {
    align(center)[= #title]
    v(1em)
  }

  set figure(supplement: "图")

  {
    set heading(numbering: (..nums) => {
      if nums.pos().len() >= 2 {
        nums.pos().slice(1).map(str).join(".") + "."
      }
    })

    body
  }
}
