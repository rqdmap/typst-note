#import "git_version.typ": show_git_history

#set text(font: ("Sarasa Fixed Slab SC"), weight: "regular", size: 14pt)

/* 显示提交历史 */
#show_git_history()

~

#show outline.entry: it => {
  if it.level == 1 {
    v(1em) 
  } else if it.level == 2 {
    v(0.6em)
  } else {
    v(0.3em)
  }
  it
}
#outline(
    title: "目录",
    target: heading.where(level: 2)
        .or(heading.where(level: 3))
        .or(heading.where(level: 4)),
    indent: n => (n - 1) * 2em
)

#pagebreak()


/* 正文配置 */
#set par(leading: 1em,)
#show heading: it => {
  it
  v(0.3em)
}
#show link: it => text(rgb(139, 0, 0), underline(stroke: 2pt, offset: 1.5pt, evade: false, it))
#set figure(supplement: "图")


/* 正文 */

#align(center)[#heading[Template]]

