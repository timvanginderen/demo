enum PricingTier {
  basic,
  normal,
  advanced;

  @override
  String toString() => name;
}

const Map<PricingTier, int> kMonthlyPrices = <PricingTier, int>{
  PricingTier.basic: 9,
  PricingTier.normal: 12,
  PricingTier.advanced: 15
};
