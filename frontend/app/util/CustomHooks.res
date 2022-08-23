type intersectingEntry = {isIntersecting: bool}
type observer

@new
external makeIntersectionObserver: (
  ~onIntersect: array<intersectingEntry> => unit,
  ~options: {"root": option<Dom.element>, "rootMargin": string, "threshold": float},
) => observer = "IntersectionObserver"

@send external observe: (observer, Dom.element) => unit = "observe"
@send external unobserve: (observer, Dom.element) => unit = "unobserve"

let useIntersectionObserverSimple = (
  ~root=?,
  ~target: React.ref<Js.Nullable.t<Dom.element>>,
  ~threshold,
  ~rootMargin,
  (),
) => {
  let (isIntersecting, setIsIntersecting) = React.useState(_ => false)

  React.useEffect4(_ =>
    switch target.current->Js.Nullable.toOption {
    | Some(t) =>
      let observer = makeIntersectionObserver(
        ~onIntersect=interSectingEntryArray =>
          setIsIntersecting(_ => (interSectingEntryArray->Array.getExn(0)).isIntersecting),
        ~options={
          "root": root,
          "rootMargin": rootMargin,
          "threshold": threshold,
        },
      )

      observe(observer, t)

      Some(_ => unobserve(observer, t))
    | None => None
    }
  , (root, target, threshold, rootMargin))
  isIntersecting
}