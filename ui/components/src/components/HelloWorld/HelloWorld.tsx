import { HELLO_TARGET } from "@julie-test-changesets/core"

export const HelloWorld = () => {
  const time = new Date()

  return (
    <div>
      <h1>Hello {HELLO_TARGET}!</h1>
    <div>
      It is {time.toLocaleTimeString()} on {time.toLocaleDateString()}.
    </div>
    </div>
  )
}