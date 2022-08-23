@react.component
let make = () => {
  <div className={`w-full`}>
    <nav className={`max-w-5xl p-5 flex items-center justify-between m-auto text-white`}>
      <Remix.Link prefetch=#none to=`/`>
        <span className={`font-bold text-3xl daimonion`}> {`Lair Game`->React.string} </span>
      </Remix.Link>
    </nav>
  </div>
}
