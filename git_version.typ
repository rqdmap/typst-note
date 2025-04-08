// git_version.typ

#let show_version_info() = {
  let info = get_version_info()
  text(10pt)[版本: #info.version (#info.commit) - #info.date]
}

#let show_git_history() = {
  let git_log = json("git_log.json")
  if git_log.len() > 0 [
    #heading(level: 2, outlined: false)[Git 版本提交历史]
    
    #table(
      columns: (auto, auto, 5fr),
      [*版本时间*], [*版本哈希*], [*版本消息*],
      ..git_log.map(commit => (
        [#commit.time],
        [#commit.hash],
        [#commit.msg]
      )).flatten()
    )
  ] else [
    #warning[无法获取 Git 提交历史。]
  ]
}
