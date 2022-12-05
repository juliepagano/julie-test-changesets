import { HELLO_TARGET } from "@julie-test-changesets/core"

export const HelloWorld = () => {
  const time = new Date()
  const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone

  return (
    <div>
      <h1>Hello {HELLO_TARGET}!</h1>
      <p>It is {time.toLocaleTimeString()} on {time.toLocaleDateString()}.</p>
      {timeZone && <p>Your time zone is: {timeZone}.</p>}
    </div>
  )
}