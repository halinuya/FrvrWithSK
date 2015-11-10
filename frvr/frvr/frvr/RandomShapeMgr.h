//
//  RandomShapeMgr.h
//  frvr
//
//  Created by James wu on 15/10/15.
//  Copyright © 2015年 James wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

typedef enum : NSInteger {
    SUDNone = -1,
    SUDTopLeft = 0,
    SUDTopRight,
    SUDRight,
    SUDBottomRight,
    SUDBottomLeft,
    SUDLeft,
} ShapeUnitDirector;

typedef enum : NSUInteger {
    STypeSingle = 0,
    STypeLine,
    STypeLeftSlashLine,
    STypeRightSlashLine,
    STypeLeftSquare,
    STypeRightSquare,
    STypeSquare,
    STypeLLTCompositeOne,
    STypeLRTCompositeOne,
    STypeLLBCompositeOne,
    STypeLRBCompositeOne,
    STypeRLTCompositeOne,
    STypeRRTCompositeOne,
    STypeRLBCompositeOne,
    STypeRRBCompositeOne,
    STypeTopLeftCompositeTwo,
    STypeBottomLeftCompositeTwo,
    STypeTopRightCompositeTwo,
    STypeBottomRightCompositeTwo,
    STypeZeroCompositeThree,
    STypeOneCompositeThree,
    STypeTwoCompositeThree,
    STypeThreeCompositeThree,
    STypeFourCompositeThree,
    STypeFiveCompositeThree,
} ShapeType;

@interface RandomShapeMgr : NSObject

+ (instancetype)sharedRandomShapeMgr;
- (SKSpriteNode *)shapeWithType:(NSInteger)shapeType;

- (SKSpriteNode *)shapeGenerator;

@end
