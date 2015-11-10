//
//  ShapeUnitInfo.h
//  frvr
//
//  Created by James wu on 15/10/15.
//  Copyright © 2015年 James wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomShapeMgr.h"

@interface ShapeUnitInfo : NSObject

@property (nonatomic) CGPoint unitLocation;
@property (nonatomic) CGPoint unitPosition;
@property (nonatomic) NSUInteger serialNumber;

@property (nonatomic,getter=isOccupied) BOOL occupy;
@property (nonatomic,strong) NSMutableArray *adjacentArray;

- (void)debugInfo;

@end
