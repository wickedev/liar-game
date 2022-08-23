/*
 * 인자에 대한 dynamic type을 module을 사용하여 모델링.
 * JavaScript의 dynamic type은 union type(sum type)으로 표현 할 수 있다.
 * sum type인 type t = (a | b)는 함수 (a | b) => t 로 모델링 가능하다.
 * 또한, (a | b) => t는 (a => t, a => t)와 같으므로
 * type t = a | b를 직접 모델링 할 수 없을때는 tuple이나 record구조를 사용해서
 * union 타입에 대한 모델링이 가능하다.
 * 따라서 Loop.t는 (bool => t, int => t)에 의해 bool | int와 동일한 타입이라고 할 수 있다.
 * 이것은 GADT와 church-encoding(Böhm-Berarducci encoding)이 상호 교환 가능하다는 것을
 * 보여주는 예시에 해당한다. 상황에 따라 둘 중 더 적합한 것을 선택 할 수 있다.
 * https://www.haskellforall.com/2021/01/the-visitor-pattern-is-essentially-same.html
 */
module Loop = {
  // (type t = bool | int) = (bool | int => t)
  type t

  // (bool => t, int => t) = (bool | int => t)
  external ofBool: bool => t = "%identity"
  external ofInt: int => t = "%identity"
}

type t

type config = {
  container: Dom.element,
  renderer: string,
  animationData: Js.Json.t,
  loop: Loop.t,
  autoplay: bool,
  name: string,
}

@val @module("lottie-web") external instance: t = "default"

module AnimationItem = {
  type t = {
    name: string,
    isLoaded: bool,
    currentFrame: int,
    currentRawFrame: int,
  }
  @send external goToAndPlay: (t, ~value: int, ~isFrame: bool, unit) => unit = "goToAndPlay"
  @get external name: t => string = "name"
}

@send external play: t => unit = "play"
@send external stop: t => unit = "stop"
@send external loadAnimation: (t, config) => AnimationItem.t = "loadAnimation"
@send external destroy: (t, string) => unit = "destroy"

module Component = {
  @react.component
  let make = (
    ~className=?,
    ~animationData,
    ~loop,
    ~autoplay=false,
    ~renderer="svg",
    ~useIntersection=false,
    ~isClickable=false,
    ~name="",
  ) => {
    let (animationItem, setAnimationItem) = React.Uncurried.useState(_ => None)
    let ref = React.useRef(Js.Nullable.null)
    let isIntersecting = CustomHooks.useIntersectionObserverSimple(
      ~target=ref,
      ~rootMargin="0px 0px 0px 0px",
      ~threshold=0.5,
      (),
    )
    React.useLayoutEffect1(_ => {
      if useIntersection {
        if isIntersecting {
          animationItem
          ->Option.map(item => {
            item->AnimationItem.goToAndPlay(~value=0, ~isFrame=false, ())
          })
          ->ignore
        }
      }
      None
    }, [isIntersecting])
    React.useEffect0(_ => {
      ref.current
      ->Js.Nullable.toOption
      ->Option.map(current' => {
        let config = {
          container: current',
          renderer: renderer,
          loop: loop,
          autoplay: autoplay,
          animationData: animationData,
          name: name,
        }
        setAnimationItem(._ => Some(instance->loadAnimation(config)))
      })
      ->ignore

      Some(
        () => {
          animationItem
          ->Option.map(item => {
            instance->destroy(item->AnimationItem.name)
          })
          ->ignore
        },
      )
    })
    <figure
      ?className
      ref={ref->ReactDOM.Ref.domRef}
      onClick={_ => {
        if isClickable {
          animationItem
          ->Option.map(item => {
            item->AnimationItem.goToAndPlay(~value=0, ~isFrame=false, ())
          })
          ->ignore
        }
      }}
    />
  }
}

let fetcher = url => {
  Ky.get(url) |> Js.Promise.then_(res => res->Fetch.Response.json)
}

module LoaderComponent = {
  @react.component
  let make = (
    ~jsonUrl: string,
    ~className=?,
    ~loop,
    ~autoplay=false,
    ~renderer="svg",
    ~useIntersection=false,
    ~isClickable=false,
    ~name="",
  ) => {
    let {data} = Swr.useSWR(jsonUrl, fetcher)

    switch data {
    | Some(data') =>
      <Component
        ?className animationData=data' loop autoplay renderer useIntersection isClickable name
      />
    | None => React.null
    }
  }
}

// Todo useLottie
// Animation 을 컴포넌트에서 Control 할 수 있도록 훅 사용