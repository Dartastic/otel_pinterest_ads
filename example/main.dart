// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_pinterest_ads/otel_pinterest_ads.dart';

/// Traces Pinterest Ads calls with OpenTelemetry.
///
/// `otel_pinterest_ads` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Pinterest Ads call in
/// [tracedPinterestAds]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'pinterest-ads-example');

  // Wraps a Pinterest Ads API call in a CLIENT span.
  final pinterestAdsId = await tracedPinterestAds<String>(
    operation: 'campaigns.create',
    invoke: () async {
      // Make the Pinterest Ads call here, then report what it returned.
      const id = 'pinterest_ads_8f3a2c';
      return const PinterestAdsCallResult(
          value: id,
          result: PinterestAdsResult(
              advertiserId: 'advertiser_8f3a2c',
              campaignId: 'campaign_8f3a2c',
              adGroupId: 'adgroup_8f3a2c',
              adId: 'ad_8f3a2c',
              pinId: 'pin_8f3a2c',
              objectiveType: 'AWARENESS',
              optimizationGoal: 'IMPRESSION',
              creativeType: 'REGULAR',
              entityStatus: 'ACTIVE',
              catalogId: 'catalog_8f3a2c',
              spendMicros: 1,
              currencyCode: 'usd',
              impressions: 1,
              clicks: 1,
              saves: 1,
              outboundClicks: 1,
              checkouts: 1,
              conversions: 1,
              statusCode: 201));
    },
  );
  OTelLog.info('tracedPinterestAds campaigns.create returned $pinterestAdsId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutPinterestAdsInstrumentationAsync.
  await runWithoutPinterestAdsInstrumentationAsync(
    () => tracedPinterestAds<String>(
      operation: 'campaigns.create',
      invoke: () async {
        const id = 'pinterest_ads_8f3a2c';
        return const PinterestAdsCallResult(
            value: id,
            result: PinterestAdsResult(
                advertiserId: 'advertiser_8f3a2c',
                campaignId: 'campaign_8f3a2c',
                adGroupId: 'adgroup_8f3a2c',
                adId: 'ad_8f3a2c',
                pinId: 'pin_8f3a2c',
                objectiveType: 'AWARENESS',
                optimizationGoal: 'IMPRESSION',
                creativeType: 'REGULAR',
                entityStatus: 'ACTIVE',
                catalogId: 'catalog_8f3a2c',
                spendMicros: 1,
                currencyCode: 'usd',
                impressions: 1,
                clicks: 1,
                saves: 1,
                outboundClicks: 1,
                checkouts: 1,
                conversions: 1,
                statusCode: 201));
      },
    ),
  );

  await OTel.shutdown();
}
