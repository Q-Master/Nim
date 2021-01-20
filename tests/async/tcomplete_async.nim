discard """
  output: "OK"
"""

import asyncdispatch

proc recursiveWaiter2() {.async.} =
  await sleepAsync(500)
  await sleepAsync(500)
  echo "NOT OK"

proc recursiveWaiter1() {.async.} =
  await recursiveWaiter2()
  await sleepAsync(1200)
  echo "NOT OK"

proc main() {.async.} =
  var fut = recursiveWaiter1()
  await sleepAsync(1000)
  fut.complete()
  await fut
  await sleepAsync(2000)

try:
  waitFor(main())
except FutureError:
  echo "NOT OK"
echo "OK"
