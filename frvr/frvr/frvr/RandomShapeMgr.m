//
//  RandomShapeMgr.m
//  frvr
//
//  Created by James wu on 15/10/15.
//  Copyright © 2015年 James wu. All rights reserved.
//

#import "RandomShapeMgr.h"
@interface RandomShapeMgr ()
@property (nonatomic,strong) NSMutableArray *posResultsArray;
@property (nonatomic,strong) NSMutableArray *compareSeqArray;
@end

@implementation RandomShapeMgr
+ (instancetype)sharedRandomShapeMgr
{
    static RandomShapeMgr *_defaultManagerInstance = nil;
    @synchronized(self) {
        if (_defaultManagerInstance == nil) {
            _defaultManagerInstance = [[RandomShapeMgr alloc] init];
        }
    }
    return _defaultManagerInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self posInfoInit];
    }
    return self;
}

- (SKSpriteNode *)shapeGenerator
{
    NSArray *array = @[@1,@3,@3,@4,@4,@4,@6];
    NSUInteger shapeCategory = arc4random() % [array count];
    NSUInteger shapeType = arc4random() % [(NSNumber *)[array objectAtIndex:shapeCategory] unsignedIntegerValue];
    
    NSUInteger count = 0;
    for (int i = 0; i < shapeCategory; i++) {
        count += [(NSNumber *)[array objectAtIndex:i] unsignedIntegerValue];
    }
    count += shapeType;
    
    return [self nodeType:count];
}

- (SKSpriteNode *)shapeWithType:(NSInteger)shapeType
{
    return [self nodeType:shapeType];
}

#pragma mark - shape generator detail
- (SKTexture *)textureWithShapeType:(NSInteger)shapeType {
    NSArray *array = @[@1,@3,@3,@4,@4,@4,@6];
    NSUInteger count = [array count];
    NSUInteger number = 0;
    NSUInteger index = 0;
    for (; index < count; index++) {
        number += [(NSNumber *)[array objectAtIndex:index] unsignedIntegerValue];
        if (number > shapeType) {
            break;
        }
    }
    
    return [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"6kuai_%lu.png",index+1]];
}

- (SKSpriteNode *)nodeType:(NSInteger)shapeType {
    SKSpriteNode *shape = [[SKSpriteNode alloc] init];
    shape.name = @"shape";
    [shape setSize:CGSizeMake(100, 100)];
    shape.zPosition = 2;
    
    SKTexture *texture = [self textureWithShapeType:shapeType];
    
    NSArray *posArray = (NSArray *)[_posResultsArray objectAtIndex:shapeType];
    NSUInteger count = [posArray count];
    
    for (NSUInteger index = 0; index < count; index++) {
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:texture];
        [node setScale:0.5];
        node.position = [(NSValue *)[posArray objectAtIndex:index] CGPointValue];
        node.name = [NSString stringWithFormat:@"%lu",(unsigned long)index];
        [shape addChild:node];
    }
    
    shape.userData = [[NSMutableDictionary alloc] init];
    [shape.userData setObject:[NSNumber numberWithUnsignedInteger:shapeType] forKey:@"shapeType"];
    [shape.userData setObject:[_compareSeqArray objectAtIndex:shapeType] forKey:@"shapeCompOrder"];
    
    return shape;
}

- (void)posInfoInit {
    _posResultsArray = [[NSMutableArray alloc] init];
    _compareSeqArray = [[NSMutableArray alloc] init];
    
    CGFloat width = 45/2;
    CGFloat height = 45/2;
    
    NSArray *pos1 = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],
                      ];
    NSArray *compareSeq1 = @[];
    [_posResultsArray addObject:pos1];
    [_compareSeqArray addObject:compareSeq1];
    
    NSArray *pos2 = @[[NSValue valueWithCGPoint:CGPointMake(-width*3/2, 0)],
                          [NSValue valueWithCGPoint:CGPointMake(-width/2, 0)],
                          [NSValue valueWithCGPoint:CGPointMake(width/2, 0)],
                          [NSValue valueWithCGPoint:CGPointMake(width*3/2, 0)],
                          ];
    NSArray *compareSeq2 = @[@2,@2,@2];
    [_posResultsArray addObject:pos2];
    [_compareSeqArray addObject:compareSeq2];
    
    NSArray *pos3 = @[[NSValue valueWithCGPoint:CGPointMake(width*3/4, height/2+19)],
                      [NSValue valueWithCGPoint:CGPointMake(width/4, height/2)],
                      [NSValue valueWithCGPoint:CGPointMake(-width/4, height/2-19 )],
                      [NSValue valueWithCGPoint:CGPointMake(-width*3/4, height/2-38 )],
                      ];
    NSArray *compareSeq3 = @[@4,@4,@4];
    [_posResultsArray addObject:pos3];
    [_compareSeqArray addObject:compareSeq3];
    
    NSArray *pos4 = @[[NSValue valueWithCGPoint:CGPointMake(-width*3/4, height/2+19)],
                      [NSValue valueWithCGPoint:CGPointMake(-width/4, height/2)],
                      [NSValue valueWithCGPoint:CGPointMake(width/4, height/2-19 )],
                      [NSValue valueWithCGPoint:CGPointMake(width*3/4, height/2-38 )],
                      ];
    NSArray *compareSeq4 = @[@3,@3,@3];
    [_posResultsArray addObject:pos4];
    [_compareSeqArray addObject:compareSeq4];
    
    NSArray *pos5 = @[[NSValue valueWithCGPoint:CGPointMake(0, height/2)],
                      [NSValue valueWithCGPoint:CGPointMake(width, height/2)],
                      [NSValue valueWithCGPoint:CGPointMake(-width/2, height/2-19 )],
                      [NSValue valueWithCGPoint:CGPointMake(width/2, height/2-19 )],
                      ];
    NSArray *compareSeq5 = @[@2,@4,@5];
    [_posResultsArray addObject:pos5];
    [_compareSeqArray addObject:compareSeq5];
    
    NSArray *pos6 = @[[NSValue valueWithCGPoint:CGPointMake(0, height/2)],
                      [NSValue valueWithCGPoint:CGPointMake(-width, height/2)],
                      [NSValue valueWithCGPoint:CGPointMake(width/2, height/2-19 )],
                      [NSValue valueWithCGPoint:CGPointMake(-width/2, height/2-19 )],
                      ];
    NSArray *compareSeq6 = @[@5,@3,@2];
    [_posResultsArray addObject:pos6];
    [_compareSeqArray addObject:compareSeq6];
    
    NSArray *pos7 = @[[NSValue valueWithCGPoint:CGPointMake(0, height/2)],
                      [NSValue valueWithCGPoint:CGPointMake(-width/2, height/2-19)],
                      [NSValue valueWithCGPoint:CGPointMake(0, height/2 -38 )],
                      [NSValue valueWithCGPoint:CGPointMake(width/2, height/2-19 )],
                      ];
    NSArray *compareSeq7 = @[@4,@3,@1];
    [_posResultsArray addObject:pos7];
    [_compareSeqArray addObject:compareSeq7];
    
    NSArray *pos8 = @[[NSValue valueWithCGPoint:CGPointMake(-width/2, 19)],
                      [NSValue valueWithCGPoint:CGPointMake(width/2, 19)],
                      [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                      [NSValue valueWithCGPoint:CGPointMake(-width/2, -19 )],
                      ];
    NSArray *compareSeq8 = @[@2,@4,@4];
    [_posResultsArray addObject:pos8];
    [_compareSeqArray addObject:compareSeq8];
    
    NSArray *pos9 = @[[NSValue valueWithCGPoint:CGPointMake(width/2, 19)],
                      [NSValue valueWithCGPoint:CGPointMake(width, 0 )],
                      [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                      [NSValue valueWithCGPoint:CGPointMake(-width/2, -19 )],
                      
                      ];
    NSArray *compareSeq9 = @[@3,@5,@4];
    [_posResultsArray addObject:pos9];
    [_compareSeqArray addObject:compareSeq9];
    
    NSArray *pos10 = @[[NSValue valueWithCGPoint:CGPointMake(width/2, 19)],
                      [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width, 0 )],
                      [NSValue valueWithCGPoint:CGPointMake(-width/2, -19 )],
                      
                      ];
    NSArray *compareSeq10 = @[@4,@5,@3];
    [_posResultsArray addObject:pos10];
    [_compareSeqArray addObject:compareSeq10];
    
    NSArray *pos11 = @[[NSValue valueWithCGPoint:CGPointMake(width/2, 19)],
                       [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width/2, -19 )],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, -19 )],
                       ];
    NSArray *compareSeq11 = @[@4,@4,@2];
    [_posResultsArray addObject:pos11];
    [_compareSeqArray addObject:compareSeq11];
    
    NSArray *pos12 = @[[NSValue valueWithCGPoint:CGPointMake(-width/2, 19)],
                       [NSValue valueWithCGPoint:CGPointMake(-width, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, -19 )],
                       ];
    NSArray *compareSeq12 = @[@4,@2,@3];
    [_posResultsArray addObject:pos12];
    [_compareSeqArray addObject:compareSeq12];
    
    NSArray *pos13 = @[[NSValue valueWithCGPoint:CGPointMake(-width/2, 19)],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, 19)],
                       [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, -19 )],
                       ];
    NSArray *compareSeq13 = @[@2,@4,@3];
    [_posResultsArray addObject:pos13];
    [_compareSeqArray addObject:compareSeq13];
    
    NSArray *pos14 = @[[NSValue valueWithCGPoint:CGPointMake(-width/2, 19)],
                       [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width/2, -19)],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, -19 )],
                       ];
    NSArray *compareSeq14 = @[@3,@3,@5];
    [_posResultsArray addObject:pos14];
    [_compareSeqArray addObject:compareSeq14];
    
    NSArray *pos15 = @[[NSValue valueWithCGPoint:CGPointMake(-width/2, 19)],
                       [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(width, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, -19)],
                       ];
    NSArray *compareSeq15 = @[@3,@2,@4];
    [_posResultsArray addObject:pos15];
    [_compareSeqArray addObject:compareSeq15];
    
    NSArray *pos16 = @[[NSValue valueWithCGPoint:CGPointMake(-width/2, 19)],
                       [NSValue valueWithCGPoint:CGPointMake(-width, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(width, 0)],
                       ];
    NSArray *compareSeq16 = @[@4,@2,@2];
    [_posResultsArray addObject:pos16];
    [_compareSeqArray addObject:compareSeq16];
    
    NSArray *pos17 = @[[NSValue valueWithCGPoint:CGPointMake(-width/2, -19)],
                       [NSValue valueWithCGPoint:CGPointMake(-width, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(width, 0)],
                       ];
    NSArray *compareSeq17 = @[@0,@2,@2];
    [_posResultsArray addObject:pos17];
    [_compareSeqArray addObject:compareSeq17];
    
    NSArray *pos18 = @[[NSValue valueWithCGPoint:CGPointMake(width/2, 19)],
                       [NSValue valueWithCGPoint:CGPointMake(width, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width, 0)],
                       ];
    NSArray *compareSeq18 = @[@3,@5,@5];
    [_posResultsArray addObject:pos18];
    [_compareSeqArray addObject:compareSeq18];
    
    NSArray *pos19 = @[[NSValue valueWithCGPoint:CGPointMake(width/2, -19)],
                       [NSValue valueWithCGPoint:CGPointMake(width, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(0, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width, 0)],
                       ];
    NSArray *compareSeq19 = @[@1,@5,@5];
    [_posResultsArray addObject:pos19];
    [_compareSeqArray addObject:compareSeq19];
    
    NSArray *pos20 = @[[NSValue valueWithCGPoint:CGPointMake(-width/2, 19 )],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, 19 )],
                       [NSValue valueWithCGPoint:CGPointMake(width, 0)],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, -19)],
                       ];
    NSArray *compareSeq20 = @[@2,@3,@4];
    [_posResultsArray addObject:pos20];
    [_compareSeqArray addObject:compareSeq20];
    
    NSArray *pos21 = @[[NSValue valueWithCGPoint:CGPointMake(width/2, 19 )],
                       [NSValue valueWithCGPoint:CGPointMake(width, 0)],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, -19)],
                       [NSValue valueWithCGPoint:CGPointMake(-width/2, -19 )],
                       ];
    NSArray *compareSeq21 = @[@3,@4,@5];
    [_posResultsArray addObject:pos21];
    [_compareSeqArray addObject:compareSeq21];
    
    NSArray *pos22 = @[[NSValue valueWithCGPoint:CGPointMake(width, 0)],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, -19)],
                       [NSValue valueWithCGPoint:CGPointMake(-width/2, -19 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width, 0 )],
                       ];
    NSArray *compareSeq22 = @[@4,@5,@0];
    [_posResultsArray addObject:pos22];
    [_compareSeqArray addObject:compareSeq22];
    
    NSArray *pos23 = @[
                       [NSValue valueWithCGPoint:CGPointMake(width/2, -19)],
                       [NSValue valueWithCGPoint:CGPointMake(-width/2, -19 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width/2, 19 )],
                       ];
    NSArray *compareSeq23 = @[@5,@0,@1];
    [_posResultsArray addObject:pos23];
    [_compareSeqArray addObject:compareSeq23];
    
    NSArray *pos24 = @[[NSValue valueWithCGPoint:CGPointMake(-width/2, -19 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width/2, 19 )],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, 19)],
                       ];
    NSArray *compareSeq24 = @[@0,@1,@2];
    [_posResultsArray addObject:pos24];
    [_compareSeqArray addObject:compareSeq24];
    
    NSArray *pos25 = @[[NSValue valueWithCGPoint:CGPointMake(-width, 0 )],
                       [NSValue valueWithCGPoint:CGPointMake(-width/2, 19 )],
                       [NSValue valueWithCGPoint:CGPointMake(width/2, 19)],
                       [NSValue valueWithCGPoint:CGPointMake(width, 0)],
                       ];
    NSArray *compareSeq25 = @[@1,@2,@3];
    [_posResultsArray addObject:pos25];
    [_compareSeqArray addObject:compareSeq25];
    
    
}


@end
