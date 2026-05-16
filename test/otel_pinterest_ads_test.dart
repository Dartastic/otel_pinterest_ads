// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_pinterest_ads/otel_pinterest_ads.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_pinterest_ads-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('analytics.get records catalog_sales + saves + checkouts', () async {
    await tracedPinterestAds<String>(
      operation: 'analytics.get',
      invoke: () async => const PinterestAdsCallResult(
        value: 'ok',
        result: PinterestAdsResult(
          advertiserId: 'adv_1',
          campaignId: 'cam_1',
          objectiveType: 'CATALOG_SALES',
          optimizationGoal: 'CONVERSION',
          creativeType: 'SHOPPING',
          entityStatus: 'ACTIVE',
          catalogId: 'cat_1',
          spendMicros: 8500000,
          currencyCode: 'USD',
          impressions: 65000,
          clicks: 1200,
          saves: 450,
          outboundClicks: 780,
          checkouts: 28,
          conversions: 35,
          statusCode: 200,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('pinterest_ads analytics.get')!);
    expect(a['pinterest_ads.objective.type'], 'CATALOG_SALES');
    expect(a['pinterest_ads.creative.type'], 'SHOPPING');
    expect(a['pinterest_ads.catalog.id'], 'cat_1');
    expect(a['pinterest_ads.spend.micros'], 8500000);
    expect(a['pinterest_ads.saves'], 450);
    expect(a['pinterest_ads.checkouts'], 28);
  });

  test('HTTP 500 sets span error', () async {
    await tracedPinterestAds<String>(
      operation: 'ads.create',
      invoke: () async => const PinterestAdsCallResult(
        value: 'ok',
        result: PinterestAdsResult(statusCode: 500),
      ),
    );
    expect(
      spans.findSpanByName('pinterest_ads ads.create')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutPinterestAdsInstrumentationAsync(() async {
      await tracedPinterestAds<String>(
        operation: 'catalogs.create',
        invoke: () async => const PinterestAdsCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('pinterest_ads '), isEmpty);
  });
}
