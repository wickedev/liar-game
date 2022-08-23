@react.component
let default = () => {
  <div className="flex flex-col justify-center items-center text-center text-white m-8">
    <h3 className="text-4xl daimonion"> {"Let the games Begin"->React.string} </h3>
    <form
      className="w-32 flex m-2 flex-col gap-y-2"
      onSubmit={e => {
        e->ReactEvent.Synthetic.preventDefault
        let target = e->ReactEvent.Synthetic.target
        let value = target["nickname"]["value"]
        Js.Console.log(value)
        
        // 좋슴당
        // TODO: 쿠키 셋팅
        // TODO: 웹소켓 입장 후 redirect
        ()
      }}>
      <input name="nickname" type_="text" placeholder="nickname" className="daimonion" />
      <button className="daimonion"> {"Enter!"->React.string} </button>
    </form>
  </div>
}
