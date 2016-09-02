xquery version "1.0-ml";

module namespace runFlow = "http://marklogic.com/rest-api/transform/run-flow";

import module namespace flow = "http://marklogic.com/data-hub/flow-lib"
at "/com.marklogic.hub/lib/flow-lib.xqy";

import module namespace trace = "http://marklogic.com/data-hub/trace"
  at "/com.marklogic.hub/lib/trace-lib.xqy";

import module namespace perf = "http://marklogic.com/data-hub/perflog-lib"
  at "/com.marklogic.hub/lib/perflog-lib.xqy";

declare namespace hub = "http://marklogic.com/data-hub";

declare function runFlow:transform(
  $context as map:map,
  $params as map:map,
  $content as document-node()
  ) as document-node()
{
  perf:log('/transforms/run-flow:transform', function() {
    let $entity-name := map:get($params, 'entity-name')
    let $flow-name := map:get($params, 'flow-name')

    let $uri := map:get($context, 'uri')
    let $flow := flow:get-flow($entity-name, $flow-name, "input")
    let $_ :=
      if ($flow) then ()
      else
        fn:error(xs:QName("MISSING_FLOW"), "The specified flow " || $entity-name || ":" || $flow-name || " is missing.")

    let $envelope := flow:run-plugins($flow, $uri, $content, $params)
    let $_ :=
      if (trace:enabled()) then
        trace:plugin-trace(
          $uri,
          if ($envelope instance of element()) then ()
          else
            null-node {},
          "writer",
          $flow/hub:type,
          $envelope,
          if ($envelope instance of element()) then ()
          else
            null-node {},
          xs:dayTimeDuration("PT0S")
        )
      else ()
    let $_ := trace:write-trace()
    return document { $envelope }
  })
};
