#import "theme.typ": c-rule

// Сплошная рамка вокруг части формулы.
#let boxed(
  body,
  inset: (x: 0.3em, y: 0.7em),
) = math.class(
  "normal",
  box(
    stroke: 1pt,
    inset: inset,
    body,
    baseline: 0%,
  ),
)

// Пунктирная рамка вокруг части формулы.
#let dashed(
  body,
  inset: (x: 0.3em, y: 0.7em),
) = math.class(
  "normal",
  box(
    stroke: (
      thickness: 1pt,
      dash: "dashed",
    ),
    inset: inset,
    body,
    baseline: 35%,
  ),
)
