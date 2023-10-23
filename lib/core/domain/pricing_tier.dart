enum PricingTier { basic, normal, advanced }

const Map<PricingTier, int> monthlyPrices = <PricingTier, int>{
  PricingTier.basic: 9,
  PricingTier.normal: 12,
  PricingTier.advanced: 15
};
