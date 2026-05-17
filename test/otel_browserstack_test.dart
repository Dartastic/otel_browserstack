// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_browserstack/otel_browserstack.dart';
import 'package:test/test.dart';

void main() {
  group('otel_browserstack', () {
    test('suppression toggles in zone', () async {
      expect(browserStackInstrumentationSuppressed(), isFalse);
      await runWithoutBrowserStackInstrumentationAsync(() async {
        expect(browserStackInstrumentationSuppressed(), isTrue);
      });
      expect(browserStackInstrumentationSuppressed(), isFalse);
    });

    test('BrowserStackResult fields default null', () {
      const r = BrowserStackResult();
      expect(r.statusCode, isNull);
    });
  });
}
