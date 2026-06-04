// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_browserstack_suppression.dart';

class BrowserStackResult {
  const BrowserStackResult({
    this.sessionId,
    this.buildName,
    this.projectName,
    this.browser,
    this.browserVersion,
    this.os,
    this.osVersion,
    this.device,
    this.realMobile,
    this.testName,
    this.testStatus,
    this.durationMs,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? sessionId;
  final String? buildName;
  final String? projectName;
  final String? browser;
  final String? browserVersion;
  final String? os;
  final String? osVersion;
  final String? device;
  final bool? realMobile;
  final String? testName;
  final String? testStatus;
  final int? durationMs;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class BrowserStackCallResult<T> {
  const BrowserStackCallResult({required this.value, this.result});
  final T value;
  final BrowserStackResult? result;
}

Future<T> tracedBrowserStack<T>({
  required String operation,
  required Future<BrowserStackCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (browserStackInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_browserstack');
  final span = t.startSpan('browserstack $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'browserstack')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.sessionId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('browserstack.session.id', res.sessionId!)]));
      }
      if (res.buildName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('cicd.pipeline.run.name', res.buildName!)]));
      }
      if (res.projectName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('browserstack.project', res.projectName!)]));
      }
      if (res.browser != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('browser.name', res.browser!)]));
      }
      if (res.browserVersion != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('browser.version', res.browserVersion!)]));
      }
      if (res.os != null) {
        span.addAttributes(
            OTel.attributes([OTel.attributeString('os.name', res.os!)]));
      }
      if (res.osVersion != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('os.version', res.osVersion!)]));
      }
      if (res.device != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('device.model.name', res.device!)]));
      }
      if (res.realMobile != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeBool('browserstack.real_mobile', res.realMobile!)]));
      }
      if (res.testName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('test.name', res.testName!)]));
      }
      if (res.testStatus != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('test.status', res.testStatus!)]));
      }
      if (res.durationMs != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('test.duration', res.durationMs!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('browserstack.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
            ErrorResource.errorType.key,
            res.errorCode ?? 'browserstack.error',
          )
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
