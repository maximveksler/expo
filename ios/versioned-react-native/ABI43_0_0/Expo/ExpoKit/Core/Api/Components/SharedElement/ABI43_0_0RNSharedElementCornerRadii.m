//
//  ABI43_0_0RNSharedElementCornerRadii_m
//  ABI43_0_0React-native-shared-element
//

#import "ABI43_0_0RNSharedElementCornerRadii.h"
#import <ABI43_0_0React/ABI43_0_0RCTUtils.h>
#import <ABI43_0_0React/ABI43_0_0RCTI18nUtil.h>

static CGFloat ABI43_0_0RNSharedElementDefaultIfNegativeTo(CGFloat defaultValue, CGFloat x)
{
  return x >= 0 ? x : defaultValue;
};

#define RADII_COUNT 9

@implementation ABI43_0_0RNSharedElementCornerRadii {
  CGFloat _radii[RADII_COUNT];
  BOOL _invalidated;
  CGRect _cachedBounds;
  ABI43_0_0RCTCornerRadii _cachedRadii;
}

- (instancetype)init
{
  if (self = [super init]) {
    _invalidated = YES;
    _layoutDirection = UIUserInterfaceLayoutDirectionLeftToRight;
    for (int i = 0; i < RADII_COUNT; i++) {
      _radii[i] = -1;
    }
  }
  return self;
}


#pragma mark Properties

- (void)setLayoutDirection:(UIUserInterfaceLayoutDirection)layoutDirection
{
  if (_layoutDirection != layoutDirection) {
    _layoutDirection = layoutDirection;
    _invalidated = YES;
  }
}


#pragma mark Methods

- (CGFloat)radiusForCorner:(ABI43_0_0RNSharedElementCorner)corner
{
  return _radii[corner];
}

- (BOOL)setRadius:(CGFloat)radius corner:(ABI43_0_0RNSharedElementCorner)corner
{
  if (_radii[corner] != radius) {
    _radii[corner] = radius;
    _invalidated = YES;
    return YES;
  }
  return NO;
}

- (void)updateClipMaskForLayer:(CALayer *)layer bounds:(CGRect)bounds
{
  ABI43_0_0RCTCornerRadii radii = [self radiiForBounds:bounds];
  
  CALayer *mask = nil;
  CGFloat cornerRadius = 0;
  
  if (ABI43_0_0RCTCornerRadiiAreEqual(radii)) {
    cornerRadius = radii.topLeft;
  } else {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    ABI43_0_0RCTCornerInsets cornerInsets = ABI43_0_0RCTGetCornerInsets(radii, UIEdgeInsetsZero);
    CGPathRef path = ABI43_0_0RCTPathCreateWithRoundedRect(bounds, cornerInsets, NULL);
    shapeLayer.path = path;
    CGPathRelease(path);
    mask = shapeLayer;
  }
  
  layer.cornerRadius = cornerRadius;
  layer.mask = mask;
}

- (void)updateShadowPathForLayer:(CALayer *)layer bounds:(CGRect)bounds
{
  ABI43_0_0RCTCornerRadii radii = [self radiiForBounds:bounds];
  
  BOOL hasShadow = layer.shadowOpacity * CGColorGetAlpha(layer.shadowColor) > 0;
  if (!hasShadow) {
    layer.shadowPath = nil;
    return;
  }
  
  ABI43_0_0RCTCornerInsets cornerInsets = ABI43_0_0RCTGetCornerInsets(radii, UIEdgeInsetsZero);
  CGPathRef path = ABI43_0_0RCTPathCreateWithRoundedRect(bounds, cornerInsets, NULL);
  layer.shadowPath = path;
  CGPathRelease(path);
}

- (ABI43_0_0RCTCornerRadii)radiiForBounds:(CGRect)bounds;
{
  if (!_invalidated && CGRectEqualToRect(_cachedBounds, bounds)) {
    return _cachedRadii;
  }
  
  const BOOL isRTL = _layoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
  const CGFloat radius = MAX(0, _radii[ABI43_0_0RNSharedElementCornerAll]);
  ABI43_0_0RCTCornerRadii result;
  
  if ([[ABI43_0_0RCTI18nUtil sharedInstance] doLeftAndRightSwapInRTL]) {
    const CGFloat topStartRadius = ABI43_0_0RNSharedElementDefaultIfNegativeTo(_radii[ABI43_0_0RNSharedElementCornerTopLeft], _radii[ABI43_0_0RNSharedElementCornerTopStart]);
    const CGFloat topEndRadius = ABI43_0_0RNSharedElementDefaultIfNegativeTo(_radii[ABI43_0_0RNSharedElementCornerTopRight], _radii[ABI43_0_0RNSharedElementCornerTopEnd]);
    const CGFloat bottomStartRadius = ABI43_0_0RNSharedElementDefaultIfNegativeTo(_radii[ABI43_0_0RNSharedElementCornerBottomLeft], _radii[ABI43_0_0RNSharedElementCornerBottomStart]);
    const CGFloat bottomEndRadius = ABI43_0_0RNSharedElementDefaultIfNegativeTo(_radii[ABI43_0_0RNSharedElementCornerBottomRight], _radii[ABI43_0_0RNSharedElementCornerBottomEnd]);
    
    const CGFloat directionAwareTopLeftRadius = isRTL ? topEndRadius : topStartRadius;
    const CGFloat directionAwareTopRightRadius = isRTL ? topStartRadius : topEndRadius;
    const CGFloat directionAwareBottomLeftRadius = isRTL ? bottomEndRadius : bottomStartRadius;
    const CGFloat directionAwareBottomRightRadius = isRTL ? bottomStartRadius : bottomEndRadius;
    
    result.topLeft = ABI43_0_0RNSharedElementDefaultIfNegativeTo(radius, directionAwareTopLeftRadius);
    result.topRight = ABI43_0_0RNSharedElementDefaultIfNegativeTo(radius, directionAwareTopRightRadius);
    result.bottomLeft = ABI43_0_0RNSharedElementDefaultIfNegativeTo(radius, directionAwareBottomLeftRadius);
    result.bottomRight = ABI43_0_0RNSharedElementDefaultIfNegativeTo(radius, directionAwareBottomRightRadius);
  } else {
    const CGFloat directionAwareTopLeftRadius = isRTL ? _radii[ABI43_0_0RNSharedElementCornerTopEnd] : _radii[ABI43_0_0RNSharedElementCornerTopStart];
    const CGFloat directionAwareTopRightRadius = isRTL ? _radii[ABI43_0_0RNSharedElementCornerTopStart] : _radii[ABI43_0_0RNSharedElementCornerTopEnd];
    const CGFloat directionAwareBottomLeftRadius = isRTL ? _radii[ABI43_0_0RNSharedElementCornerBottomEnd] : _radii[ABI43_0_0RNSharedElementCornerBottomStart];
    const CGFloat directionAwareBottomRightRadius = isRTL ? _radii[ABI43_0_0RNSharedElementCornerBottomStart] : _radii[ABI43_0_0RNSharedElementCornerBottomEnd];
    
    result.topLeft =
    ABI43_0_0RNSharedElementDefaultIfNegativeTo(radius, ABI43_0_0RNSharedElementDefaultIfNegativeTo(_radii[ABI43_0_0RNSharedElementCornerTopLeft], directionAwareTopLeftRadius));
    result.topRight =
    ABI43_0_0RNSharedElementDefaultIfNegativeTo(radius, ABI43_0_0RNSharedElementDefaultIfNegativeTo(_radii[ABI43_0_0RNSharedElementCornerTopRight], directionAwareTopRightRadius));
    result.bottomLeft =
    ABI43_0_0RNSharedElementDefaultIfNegativeTo(radius, ABI43_0_0RNSharedElementDefaultIfNegativeTo(_radii[ABI43_0_0RNSharedElementCornerBottomLeft], directionAwareBottomLeftRadius));
    result.bottomRight = ABI43_0_0RNSharedElementDefaultIfNegativeTo(
                                                            radius, ABI43_0_0RNSharedElementDefaultIfNegativeTo(_radii[ABI43_0_0RNSharedElementCornerBottomRight], directionAwareBottomRightRadius));
  }
  
  // Get scale factors required to prevent radii from overlapping
  const CGFloat topScaleFactor = ABI43_0_0RCTZeroIfNaN(MIN(1, bounds.size.width / (result.topLeft + result.topRight)));
  const CGFloat bottomScaleFactor = ABI43_0_0RCTZeroIfNaN(MIN(1, bounds.size.width / (result.bottomLeft + result.bottomRight)));
  const CGFloat rightScaleFactor = ABI43_0_0RCTZeroIfNaN(MIN(1, bounds.size.height / (result.topRight + result.bottomRight)));
  const CGFloat leftScaleFactor = ABI43_0_0RCTZeroIfNaN(MIN(1, bounds.size.height / (result.topLeft + result.bottomLeft)));
  
  result.topLeft *= MIN(topScaleFactor, leftScaleFactor);
  result.topRight *= MIN(topScaleFactor, rightScaleFactor);
  result.bottomLeft *= MIN(bottomScaleFactor, leftScaleFactor);
  result.bottomRight *= MIN(bottomScaleFactor, rightScaleFactor);
  
  _cachedBounds = bounds;
  _cachedRadii = result;
  _invalidated = NO;
  
  return result;
}

@end
