// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

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
