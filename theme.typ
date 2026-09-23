#import "@preview/touying:0.7.1": *
#import "colors.typ": text as palette-text, muted, rule, bullet

// =============================================================================
// НАСТРОЙКИ ТЕМЫ
//
// Все типографические размеры и интервалы заданы относительно основного
// размера шрифта через em. В физических единицах оставлен только формат слайда.
// =============================================================================

// -----------------------------------------------------------------------------
// Формат слайда
// -----------------------------------------------------------------------------

#let slide-width = 297mm
#let slide-height = 167.0625mm

#let slide-margin = (
  left: 1.45em,
  right: 1.45em,
  top: 1.10em,
  bottom: 1.30em,
)

// -----------------------------------------------------------------------------
// Основной текст
// -----------------------------------------------------------------------------

#let font-family = (
  "New Computer Modern",
)

// Единственный базовый абсолютный размер. Всё остальное масштабируется от него.
#let body-font-size = 22pt

// leading — расстояние между нижней границей одной строки и верхней следующей.
#let body-leading = 0.7em
#let paragraph-spacing = 1em

// -----------------------------------------------------------------------------
// Заголовки
// -----------------------------------------------------------------------------

#let slide-title-size = 1.45em
#let slide-title-weight = "regular"

// Расстояние между заголовком обычного слайда и его содержимым.
#let slide-title-gap = 1.9em

#let section-title-size = 1.65em
#let section-title-weight = "regular"

// -----------------------------------------------------------------------------
// Титульный слайд
// -----------------------------------------------------------------------------

#let title-page-title-size = 1.90em
#let title-page-subtitle-size = 1.18em
#let title-page-author-size = 1.00em
#let title-page-institution-size = 0.84em
#let title-page-supervisors-size = 0.74em
#let title-page-date-size = 0.74em

#let title-page-title-gap = 0.52em
#let title-page-author-gap = 0.95em
#let title-page-small-gap = 0.28em

// -----------------------------------------------------------------------------
// Цвета
// -----------------------------------------------------------------------------

#let c-text = palette-text
#let c-muted = muted
#let c-rule = rule
#let c-bullet = bullet

// -----------------------------------------------------------------------------
// Списки
// -----------------------------------------------------------------------------

// Общий вертикальный интервал вокруг крупных блоков содержимого.
// Меняя только это значение, можно одновременно увеличить или уменьшить
// расстояние вокруг списков, таблиц и блочных уравнений.
#let content-block-spacing = 0.58em

#let list-indent = 1.35em
#let list-body-indent = 0.52em

// Расстояние между отдельными пунктами списка.
#let list-item-spacing = 0.38em

// Индивидуальные интервалы вокруг списка.
// По умолчанию наследуют общий content-block-spacing.
#let list-block-above = content-block-spacing
#let list-block-below = content-block-spacing

#let bullet-size = 0.19em

// Строчный маркер с фиксированной базовой линией: маркер остаётся у
// первой строки даже у многострочного пункта, а не центрируется по блоку.
#let _bullet-marker() = box(
  width: bullet-size,
  height: bullet-size,
  baseline: -0.09em,
  fill: c-bullet,
)

// -----------------------------------------------------------------------------
// Формулы, таблицы, сетки и нумерация
// -----------------------------------------------------------------------------

// Интервалы вокруг блочных уравнений.
#let display-equation-above = content-block-spacing
#let display-equation-below = content-block-spacing

// Интервалы вокруг таблиц.
#let table-block-above = content-block-spacing
#let table-block-below = content-block-spacing

#let rule-thickness = 0.025em
#let table-inset = (x: 0.12em, y: 0.09em)

#let page-number-size = 1.2em
#let page-number-offset = (x: 0.3em, y: 0.3em)

// =============================================================================
// ВНУТРЕННИЕ ЭЛЕМЕНТЫ ТЕМЫ
// =============================================================================

#let _page-number() = context place(
  bottom + right,
  dx: -page-number-offset.x,
  dy: -page-number-offset.y,
  text(
    size: page-number-size,
    fill: c-muted,
  )[
    #utils.slide-counter.display()
  ],
)

#let _slide-title(title) = text(
  size: slide-title-size,
  weight: slide-title-weight,
  fill: c-text,
)[
  // #smallcaps()[#title]
  #title
]

// =============================================================================
// ОБЫЧНЫЙ СЛАЙД
//
// Заголовок второго уровня создаёт новый слайд:
//
// == Название слайда
// =============================================================================

#let _slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  title: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-page(
      header: none,
      footer: none,
      foreground: _page-number(),
    ),
  )

  let new-setting(body) = {
    if title == none {
      block(
        width: 100%,
        height: 100%,
        breakable: false,
      )[
        #setting(body)
      ]
    } else {
      let displayed-title = if title == auto {
        utils.display-current-heading(level: 2)
      } else {
        title
      }

      block(
        width: 100%,
        height: 100%,
        breakable: false,
      )[
        #grid(
          // Единственная колонка обязательно занимает всю доступную ширину.
          // Без 1fr колонка имеет размер auto и сжимается до содержимого,
          // поэтому вложенный align(center) не может двигать элементы
          // относительно всей ширины слайда.
          columns: (1fr,),
          rows: (auto, 1fr),
          row-gutter: slide-title-gap,

          // Это выравнивание относится только к каркасу темы.
          align: left + top,

          _slide-title(displayed-title),
          setting(body),
        )
      ]
    }
  }

  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: new-setting,
    composer: composer,
    ..bodies,
  )
})

// =============================================================================
// СЛАЙД РАЗДЕЛА
//
// Заголовок первого уровня создаёт секционный слайд:
//
// = Название раздела
// =============================================================================

#let _section-slide(config: (:), body) = touying-slide-wrapper(
  self => {
    let self = utils.merge-dicts(
      self,
      config-page(
        fill: white,
        header: none,
        footer: none,
        foreground: none,
      ),
    )

    touying-slide(
      self: self,
      config: utils.merge-dicts(
        config,
        config-common(freeze-slide-counter: true),
      ),
      align(
        center + horizon,
        text(
          size: section-title-size,
          weight: section-title-weight,
          fill: c-text,
        )[
          #utils.display-current-heading(level: 1)
        ],
      ),
    )
  },
)

// =============================================================================
// ТИТУЛЬНЫЙ СЛАЙД
// =============================================================================

#let title-slide(config: (:), ..args) = touying-slide-wrapper(
  self => {
    let info = self.info + args.named()

    let title = info.at("title", default: none)
    let subtitle = info.at("subtitle", default: none)
    let author = info.at("author", default: none)
    let institution = info.at("institution", default: none)
    let supervisors = info.at("supervisors", default: none)
    let date = info.at("date", default: none)

    let self = utils.merge-dicts(
      self,
      config-page(
        fill: white,
        header: none,
        footer: none,
        foreground: none,
      ),
    )

    let title-body = block(width: 100%)[
      #if title != none {
        align(
          center,
          text(
            size: title-page-title-size,
            weight: "regular",
            fill: c-text,
          )[
            #title
          ],
        )
      }

      #if subtitle != none {
        v(title-page-title-gap)
        align(
          center,
          text(
            size: title-page-subtitle-size,
            fill: c-text,
          )[
            #subtitle
          ],
        )
      }

      #if author != none {
        v(title-page-author-gap)
        align(
          center,
          text(
            size: title-page-author-size,
            fill: c-text,
          )[
            #author
          ],
        )
      }

      #if institution != none {
        v(title-page-small-gap)
        align(
          center,
          text(
            size: title-page-institution-size,
            fill: c-text,
          )[
            #institution
          ],
        )
      }

      #if supervisors != none {
        v(title-page-small-gap)
        align(
          center,
          text(
            size: title-page-supervisors-size,
            fill: c-text,
          )[
            #supervisors
          ],
        )
      }

      #if date != none {
        v(title-page-small-gap)
        align(
          center,
          text(
            size: title-page-date-size,
            fill: c-muted,
          )[
            #date
          ],
        )
      }
    ]

    touying-slide(
      self: self,
      config: utils.merge-dicts(
        config,
        config-common(freeze-slide-counter: true),
      ),
      align(center + horizon, title-body),
    )
  },
)

// =============================================================================
// ОСНОВНАЯ ТЕМА
// =============================================================================

#let theme(info, ..args, body) = {
  set text(
    font: font-family,
    size: body-font-size,
    fill: c-text,
    // Учебные слайды не должны разбивать слова автоматическим дефисом:
    // короткие карточки и схемы остаются визуально чище.
    hyphenate: false,
  )

  set par(
    // На слайдах важнее ровный естественный край, чем растянутые пробелы
    // между словами в карточках и узких колонках.
    justify: false,
    first-line-indent: 0em,
    leading: body-leading,
    spacing: paragraph-spacing,
  )

  set heading(numbering: none)

  set math.equation(
    numbering: none,
  )

  set list(
    marker: _bullet-marker(),
    indent: list-indent,
    body-indent: list-body-indent,
    spacing: list-item-spacing,
  )

  set enum(
    indent: list-indent,
    body-indent: list-body-indent,
    spacing: list-item-spacing,
  )

  // Тема задаёт только линии и внутренние поля таблицы.
  // Положение таблицы и выравнивание ячеек задаются в основном документе.
  set table(
    stroke: rule-thickness + c-rule,
    inset: table-inset,
  )

  // Вертикальные интервалы вокруг маркированных и нумерованных списков.
  show list: set block(
    above: list-block-above,
    below: list-block-below,
  )

  show enum: set block(
    above: list-block-above,
    below: list-block-below,
  )

  // Настраиваем только внешние интервалы таблицы.
  // Важно: не оборачиваем таблицу в block(width: 100%),
  // иначе внешнему #align(center)[...] нечего будет центрировать.
  show table: set block(
    above: table-block-above,
    below: table-block-below,
  )

  // Меняем только внешние интервалы блочных уравнений.
  // Само уравнение остаётся штатным элементом Typst и сохраняет
  // встроенное центрирование по ширине доступной области.
  show math.equation.where(block: true): set block(
    above: display-equation-above,
    below: display-equation-below,
  )

  show: touying-slides.with(
    config-page(
      width: slide-width,
      height: slide-height,
      margin: slide-margin,
      fill: white,
      header-ascent: 0em,
      footer-descent: 0em,
    ),
    config-common(
      slide-fn: _slide,
      new-section-slide-fn: _section-slide,
      zero-margin-footer: false,
    ),
    config-info(..info),
    config-colors(
      primary: c-text,
      neutral-lightest: white,
      neutral-darkest: c-text,
    ),
    ..args,
  )

  body
}
