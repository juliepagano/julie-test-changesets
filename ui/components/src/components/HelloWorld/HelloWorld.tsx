import { HELLO_TARGET } from "@julie-test-changesets/core"

export const HelloWorld = () => {
  const time = new Date()
  const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone

  return (
    <div style={{color: 'blue'}}>
      <h1>Hello <span data-maske2e>{HELLO_TARGET}</span>!</h1>
      <p>It is {time.toLocaleTimeString()} on {time.toLocaleDateString()}.</p>
      {timeZone && <p>Your time zone is: {timeZone}.</p>}
      <strong>I like testing things! 😀</strong>
    </div>
  )
}