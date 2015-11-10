//
//  ShapeUnitInfo.m
//  frvr
//
//  Created by James wu on 15/10/15.
//  Copyright © 2015年 James wu. All rights reserved.
//

#import "ShapeUnitInfo.h"


@implementation ShapeUnitInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.adjacentArray = [[NSMutableArray alloc] initWithCapacity:6];
        self.occupy = NO;
    }
    return self;
}

- (void)debugInfo
{
    NSLog(@"location:[%f,%f]",_unitLocation.x,_unitLocation.y);
    NSLog(@"position:[%f,%f]",_unitPosition.x,_unitPosition.y);
    NSLog(@"serailNum:%lu",(unsigned long)_serialNumber);
    NSLog(@"adjacents:%@",_adjacentArray);
    NSLog(@"occupy:%d",_occupy);
}


@end
