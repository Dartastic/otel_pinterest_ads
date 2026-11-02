// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_pinterest_ads_suppression.dart';

const _tracerName = 'dartastic_otel_libs_pinterest_ads';

APITracer _tracer() => OTelAPI.tracerProvider().getTracer(_tracerName);

class PinterestAdsResult {
  /// Creates a result.
  const PinterestAdsResult({
    this.advertiserId,
    this.campaignId,
    this.adGroupId,
    this.adId,
    this.pinId,
    this.objectiveType,
    this.optimizationGoal,
    this.creativeType,
    this.entityStatus,
    this.catalogId,
    this.spendMicros,
    this.currencyCode,
    this.impressions,
    this.clicks,
    this.saves,
    this.outboundClicks,
    this.checkouts,
    this.conversions,
    this.statusCode,
  });

  final String? advertiserId;
  final String? campaignId;
  final String? adGroupId;
  final String? adId;
  final String? pinId;

  /// `AWARENESS` / `CONSIDERATION` / `VIDEO_VIEW` /
  /// `WEB_CONVERSION` / `CATALOG_SALES` / `WEB_SESSIONS`.
  final String? objectiveType;

  /// `IMPRESSION` / `CLICKTHROUGH` / `OUTBOUND_CLICKS` / `CONVERSION`.
  final String? optimizationGoal;

  /// `REGULAR` / `VIDEO` / `SHOPPING` / `CAROUSEL` / `IDEA` /
  /// `COLLECTION`.
  final String? creativeType;

  /// `ACTIVE` / `PAUSED` / `ARCHIVED` / `DRAFT`.
  final String? entityStatus;

  /// Catalog (product feed) id for SHOPPING / CATALOG_SALES.
  final String? catalogId;

  /// Spend in micros.
  final int? spendMicros;

  final String? currencyCode;
  final int? impressions;
  final int? clicks;

  /// Saves (Pinterest's unique engagement — pin saved to a board).
  final int? saves;

  /// Outbound clicks to advertiser site.
  final int? outboundClicks;

  final int? checkouts;
  final int? conversions;
  final int? statusCode;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class PinterestAdsCallResult<T> {
  /// Creates a call result.
  const PinterestAdsCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final PinterestAdsResult? result;
}

/// Wraps a Pinterest Ads API call in a CLIENT span. [operation] is
/// one of `analytics.get`, `campaigns.create`, `ad_groups.create`,
/// `ads.create`, `catalogs.create`, `events.send`, `audiences.create`.
Future<T> tracedPinterestAds<T>({
  required String operation,
  required Future<PinterestAdsCallResult<T>> Function() invoke,
}) async {
  if (pinterestAdsInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'pinterest_ads',
    'rpc.method': operation,
    'pinterest_ads.operation': operation,
  };

  final span = _tracer().startSpan(
    'pinterest_ads $operation',
    kind: SpanKind.client,
    attributes: OTelAPI.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final extras = <Attribute<Object>>[];
      if (r.result!.advertiserId != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.advertiser.id',
          r.result!.advertiserId!,
        ));
      }
      if (r.result!.campaignId != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.campaign.id',
          r.result!.campaignId!,
        ));
      }
      if (r.result!.adGroupId != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.ad_group.id',
          r.result!.adGroupId!,
        ));
      }
      if (r.result!.adId != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.ad.id',
          r.result!.adId!,
        ));
      }
      if (r.result!.pinId != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.pin.id',
          r.result!.pinId!,
        ));
      }
      if (r.result!.objectiveType != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.objective.type',
          r.result!.objectiveType!,
        ));
      }
      if (r.result!.optimizationGoal != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.optimization.goal',
          r.result!.optimizationGoal!,
        ));
      }
      if (r.result!.creativeType != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.creative.type',
          r.result!.creativeType!,
        ));
      }
      if (r.result!.entityStatus != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.entity.status',
          r.result!.entityStatus!,
        ));
      }
      if (r.result!.catalogId != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.catalog.id',
          r.result!.catalogId!,
        ));
      }
      if (r.result!.spendMicros != null) {
        extras.add(OTelAPI.attributeInt(
          'pinterest_ads.spend.micros',
          r.result!.spendMicros!,
        ));
      }
      if (r.result!.currencyCode != null) {
        extras.add(OTelAPI.attributeString(
          'pinterest_ads.currency.code',
          r.result!.currencyCode!,
        ));
      }
      if (r.result!.impressions != null) {
        extras.add(OTelAPI.attributeInt(
          'pinterest_ads.impressions',
          r.result!.impressions!,
        ));
      }
      if (r.result!.clicks != null) {
        extras.add(OTelAPI.attributeInt(
          'pinterest_ads.clicks',
          r.result!.clicks!,
        ));
      }
      if (r.result!.saves != null) {
        extras.add(OTelAPI.attributeInt(
          'pinterest_ads.saves',
          r.result!.saves!,
        ));
      }
      if (r.result!.outboundClicks != null) {
        extras.add(OTelAPI.attributeInt(
          'pinterest_ads.outbound_clicks',
          r.result!.outboundClicks!,
        ));
      }
      if (r.result!.checkouts != null) {
        extras.add(OTelAPI.attributeInt(
          'pinterest_ads.checkouts',
          r.result!.checkouts!,
        ));
      }
      if (r.result!.conversions != null) {
        extras.add(OTelAPI.attributeInt(
          'pinterest_ads.conversions',
          r.result!.conversions!,
        ));
      }
      if (r.result!.statusCode != null) {
        extras.add(OTelAPI.attributeInt(
          'http.response.status_code',
          r.result!.statusCode!,
        ));
        if (r.result!.statusCode! >= 400) {
          span.setStatus(
            SpanStatusCode.Error,
            'Pinterest Ads HTTP ${r.result!.statusCode}',
          );
        }
      }
      if (extras.isNotEmpty) span.addAttributes(OTelAPI.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTelAPI.attributes([
      OTelAPI.attributeString(
        ErrorAttributes.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
