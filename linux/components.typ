#import "../colors.typ": (
  blue, green, muted, orange, purple, red, rule, surface, terminal-background,
  terminal-command, terminal-error, terminal-header, terminal-output,
  terminal-prompt, terminal-success, terminal-text, terminal-warning,
  text as c-text,
)

#let mono(body, size: 0.84em, fill: c-text) = text(
  font: "DejaVu Sans Mono",
  size: size,
  fill: fill,
)[#body]
#let inlinecode(body) = box(
  fill: surface,
  inset: (x: .23em, y: .08em),
  radius: .1em,
)[#mono(body, size: .78em)]
#let key(body) = box(
  stroke: .045em + rule,
  fill: surface,
  radius: .12em,
  inset: (x: .34em, y: .12em),
)[#mono(body, size: .72em)]
#let shortcut(first, second, third: none) = if third == none {
  key(first) + [+] + key(second)
} else {
  key(first) + [+] + key(second) + [+] + key(third)
}
#let sequence(first, second) = key(first) + [, затем ] + key(second)

// Каждая запись — самостоятельный block. Иначе соседние inline-вызовы
// объединяются Typst в одну строку внутри общего окна терминала.
#let terminal_line(body, fill: terminal-output) = block(width: 100%)[
  #set smartquote(enabled: false)
  #text(font: "DejaVu Sans Mono", size: .75em, fill: fill)[#body]
]
// Адрес, пользователь и каталог задаются у каждой строки: после ssh/cd
// приглашение меняется вместе с текущей машиной и директорией.
#let cmd(
  body,
  user: "yaroslav",
  host: "laptop",
  dir: "~/project",
) = terminal_line(
  [
    #text(fill: terminal-prompt, user + "@" + host + ":" + dir + "$")
    #body
  ],
  fill: terminal-command,
)
#let remote(body, dir: "~", host: "cluster", user: "yaroslav") = cmd(
  body,
  user: user,
  host: host,
  dir: dir,
)
#let output(body) = terminal_line(body)
#let comment(body) = terminal_line(body, fill: muted)
#let error(body) = terminal_line(body, fill: terminal-error)
#let success(body) = terminal_line(body, fill: terminal-success)

#let terminal(body, title: none, padding-y: .48em) = block(
  width: 100%,
  fill: terminal-background,
  stroke: .045em + rule,
  radius: .22em,
  clip: true,
)[
  // Нейтральная верхняя панель без подписи; она визуально отделяет
  // демонстрацию от текста, не дублируя заголовок слайда.
  #block(width: 100%, height: .7em, fill: terminal-header, below: 0pt)[]
  #block(width: 100%, above: 0pt, inset: (x: .85em, y: padding-y))[
    #set par(
      leading: .4em,
      spacing: .3em,
    )
    #body
  ]
]

#let note(title, body, color: blue) = block(
  width: 100%,
  fill: surface,
  stroke: (left: .16em + color),
  inset: .65em,
)[
  #text(weight: "bold", fill: color)[#title]\
  #body
]

#let tree(body, width: auto) = block(
  width: width,
  fill: surface,
  inset: .8em,
  radius: .15em,
)[#mono(body, size: .8em)]
#let diagram(title, body, color: blue) = block(
  width: 100%,
  height: 4.6em,
  stroke: .06em + color,
  inset: (x: .45em, y: .55em),
  radius: .15em,
)[#align(center + horizon, stack(
  dir: ttb,
  spacing: .7em,
  align(center, text(
    size: .9em,
    weight: "bold",
    fill: color,
  )[#title]),
  align(center, text(size: .82em)[#body]),
))]
