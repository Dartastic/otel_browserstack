# otel_browserstack

Dartastic OpenTelemetry bridge for BrowserStack (cross-browser cloud testing).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_browserstack/otel_browserstack.dart';

await tracedBrowserStack<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return BrowserStackCallResult(value: r, result: BrowserStackResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutBrowserStackInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
