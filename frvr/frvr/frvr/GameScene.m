//
//  GameScene.m
//  frvr
//
//  Created by James wu on 15/10/14.
//  Copyright (c) 2015年 James wu. All rights reserved.
//

#import "GameScene.h"
#import "RandomShapeMgr.h"
#import "ShapeUnitInfo.h"

#define TOPMARGING 5
#define XDISTANCE 23
#define YDISTANCE 38
#define PLAYGROUNDLINE 9
#define UNITSHAPETYPE 16
#define UNITCOLORTYPE 5

@interface GameScene ()

@property (nonatomic) CGFloat unitWidth;
@property (nonatomic) CGFloat unitHight;
@property (nonatomic) NSUInteger score;
@property (nonatomic,strong) SKTexture *unitTexture;

@property (nonatomic, weak) SKSpriteNode *handleNode;

@property (nonatomic,strong) NSMutableArray *unitInfoArray;
@property (nonatomic,strong) NSMutableArray *unitNodeArray;

@property (nonatomic,strong) NSMutableArray *shapePosArray;
@property (nonatomic,strong) NSMutableArray *shapeArray;

@end


@implementation GameScene
#pragma mark - interface
- (void)startNewGame
{
    [self setPaused:NO];
    [self refreshPlayground];
    [self shapeFill];
}

#pragma mark - life cycle
-(void)didMoveToView:(SKView *)view {
    
    /* Setup your scene here */
    [self dataInit];
    
    [self addLabel];
    [self addPlayground];
    [self addShapeFrame];
}

- (void)dataInit
{
    _score = 0;
    [self unitInfoInit];
}

- (void)unitInfoInit
{
    if (_unitNodeArray != nil) {
        return;
    }
    
    _unitInfoArray = [[NSMutableArray alloc] init];
    
    NSString *bundleDir = [[NSBundle mainBundle] bundlePath];
    NSString *path = [bundleDir stringByAppendingPathComponent:@"unitInfo.json"];
//    NSLog(@"%@",path);
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error = nil;
    
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    NSLog(@"%@",jsonDic);
    
    NSArray *unitInfos = [jsonDic objectForKey:@"unitInfos"];
    
    if (unitInfos != nil) {
        for (NSDictionary *unitInfoDic in unitInfos) {
            ShapeUnitInfo *unitInfo = [[ShapeUnitInfo alloc] init];
            int x = ((NSNumber *)[unitInfoDic objectForKey:@"x"]).intValue;
            int y = ((NSNumber *)[unitInfoDic objectForKey:@"y"]).intValue;
            int sn = ((NSNumber *)[unitInfoDic objectForKey:@"serialNum"]).intValue;
            NSString *adjacentString = (NSString *)[unitInfoDic objectForKey:@"adjacent"];
            NSArray *adjacents = [adjacentString componentsSeparatedByString:@" "];
            unitInfo.unitLocation = CGPointMake(x, y);
            unitInfo.serialNumber = sn;
            
            [unitInfo.adjacentArray addObjectsFromArray:adjacents];
            
            [_unitInfoArray addObject:unitInfo];
//            NSLog(@"%@",unitInfo);
        }
    }
}

- (void)addLabel
{
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Frvr brave go!!!!";
    myLabel.fontSize = 30;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetHeight(self.frame)-40);
    [self addChild:myLabel];
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text = @"score : ";
    scoreLabel.fontSize = 26;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame)-120,
                                   CGRectGetHeight(self.frame)-90);
    [self addChild:scoreLabel];
    
    SKLabelNode *scoreNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreNumberLabel.name = @"scoreNumberLabel";
    scoreNumberLabel.text = [NSString stringWithFormat:@"%lu",_score];
    scoreNumberLabel.fontSize = 26;
    scoreNumberLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetHeight(self.frame)-90);
    [self addChild:scoreNumberLabel];
}

- (void)addPlayground
{
    SKSpriteNode *node;
    self.unitNodeArray = [[NSMutableArray alloc] init];
    
    self.unitTexture = [SKTexture textureWithImageNamed:@"6kuai_gray.png"];
    self.unitWidth = self.unitTexture.size.width;
    self.unitHight= self.unitTexture.size.height;
//    NSLog(@"unitWidth:%f,unitHight:%f",self.unitWidth,self.unitHight);
    
    NSArray *arrayNumber = @[@5,@6,@7,@8,@9,@8,@7,@6,@5];
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.frame) -2*self.unitWidth, CGRectGetHeight(self.frame)-150 );
//    NSLog(@"%@,frame:[%f,%f],start:[%f,%f]",arrayNumber,self.frame.size.width,self.frame.size.height,startPoint.x,startPoint.y);
//    NSLog(@"view:[%f,%f]",self.view.frame.size.width,self.view.frame.size.height);
    
    int index = 0;
    int nodeCount = 0;
    for (NSNumber *lineNumber in arrayNumber) {
        int count = lineNumber.intValue;
        for (int i = 0; i < count; i++) {
            node = [SKSpriteNode spriteNodeWithTexture:self.unitTexture];
            if (index <= 4) {
                [node setPosition:CGPointMake(startPoint.x-XDISTANCE*index +i*self.unitWidth, startPoint.y-YDISTANCE*index)];
            }
            else
            {
                [node setPosition:CGPointMake(startPoint.x - XDISTANCE*((PLAYGROUNDLINE-1)-index) + i*self.unitWidth, startPoint.y - YDISTANCE*index)];
            }
            
            ShapeUnitInfo *unitInfo = [_unitInfoArray objectAtIndex:nodeCount];
            unitInfo.unitPosition = node.position;
            node.userData = [[NSMutableDictionary alloc] init];
            [node.userData setValue:unitInfo forKey:@"unitInfo"];
            [node setName:@"unitShape"];
            
            SKLabelNode *label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%d",nodeCount]];
            label.position = CGPointMake(0, 0);
            label.fontColor = [UIColor blackColor];
            label.fontSize = 18;
            label.zPosition = 2;
            [node addChild:label];
            
//            [unitInfo debugInfo];
//            NSLog(@"%@",unitInfo);
            
            [self addChild:node];
            [self.unitNodeArray addObject:node];
            nodeCount++;
        }
        index++;
    }
}

- (void)shapeFill {
    
    NSInteger count = 3 - [_shapeArray count];
    for (NSInteger i = 0; i < count; i++) {
        SKSpriteNode *genShapeNode = [self randomShapeGenerator];
        [_shapeArray addObject:genShapeNode];
        [self addChild:genShapeNode];
    }
    
    for (NSInteger i = 0; i < 3; i++) {
        SKSpriteNode *shapeNode = [_shapeArray objectAtIndex:i];
        CGPoint location =  [(NSValue *)[_shapePosArray objectAtIndex:i] CGPointValue];
        SKAction *move = [SKAction moveTo:location duration:0.5];
        move.timingMode = SKActionTimingEaseOut;
        [shapeNode runAction:move];
    }
}

- (void)addShapeFrame
{
    SKSpriteNode *node;
    _shapePosArray = [[NSMutableArray alloc] initWithCapacity:3];
    _shapeArray = [[NSMutableArray alloc] initWithCapacity:3];

    for (int i = 0; i < 3; i++) {
        node = [[SKSpriteNode alloc] init];
        node.size = CGSizeMake(100, 100);
        node.position= CGPointMake(CGRectGetMidX(self.frame) + (i - 1)*120, 220);
        node.name = [NSString stringWithFormat:@"shapeFrame_%d",i];
        [self addChild:node];
        
        [_shapePosArray addObject:[NSValue valueWithCGPoint:node.position]];
    }
    
    [self shapeFill];
}

- (void)refreshPlayground
{
    SKTexture *texture = [SKTexture textureWithImageNamed:@"6kuai_gray.png"];
    for (SKSpriteNode *unitNode in _unitNodeArray) {
        ShapeUnitInfo *nodeInfo = (ShapeUnitInfo *)[unitNode.userData objectForKey:@"unitInfo"];
        nodeInfo.occupy = NO;
        [unitNode setTexture:texture];
    }
    [self dataInit];
    [self changeScore];
}

- (SKSpriteNode *)randomShapeGenerator
{
    return [[RandomShapeMgr sharedRandomShapeMgr] shapeGenerator];
}

#pragma mark - touch control
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    NSArray *nodes =[self nodesAtPoint:location];
    for (SKSpriteNode *node in nodes) {
        if ([node.name isEqual:@"shape"]) {
//            NSLog(@"shape");
            _handleNode = node;
            [_handleNode runAction:[SKAction scaleTo:2 duration:0.4] completion:^{
//                NSLog(@"The handleNode Pos:[%f,%f]",_handleNode.position.x,_handleNode.position.y);
            }];
            
            break;
        }
        else if ([node.name isEqual:@"unitShape"])
        {
//            NSLog(@"unitShape");
            ShapeUnitInfo *unitInfo = (ShapeUnitInfo *)[node.userData objectForKey:@"unitInfo"];
            [unitInfo debugInfo];
//            NSLog(@"%@",unitInfo);
            
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            for (NSString *indexString in unitInfo.adjacentArray) {
                if (![indexString isEqual:@"-1"]) {
                    [indexSet addIndex:[indexString integerValue]];
                }
            }
            
            NSArray *tempArray = [_unitNodeArray objectsAtIndexes:indexSet];
            for (SKSpriteNode *node in tempArray) {
//                NSArray *fadeGroup = @[[SKAction fadeAlphaTo:0 duration:0.3], [SKAction fadeAlphaTo:1 duration:0.3]];
                SKAction *fadeInAndOut = [SKAction rotateByAngle:M_PI*2 duration:0.8];
                [node runAction:fadeInAndOut];
            }
            
            break;
        }
        
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_handleNode != nil) {
        _handleNode.position = [[touches anyObject] locationInNode:self];
//        NSLog(@"h:[%f,%f]",_handleNode.position.x,_handleNode.position.y);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_handleNode != nil) {
        
//        _handleNode.position = [_handleNode.userData objectForKey:@"oriPosition"];
        
        NSArray *handleShapeNodes = [_handleNode children];
//        NSLog(@"The handleNode Pos:[%f,%f]",_handleNode.position.x,_handleNode.position.y);
        
        SKTexture *texture = [(SKSpriteNode *)[[_handleNode children] firstObject] texture];;
        
        NSUInteger index = 0;
        NSUInteger ocuppiedCount = 0;
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (SKSpriteNode *child in handleShapeNodes) {
            index++;
            CGPoint childLocation = CGPointMake(child.position.x*2 +_handleNode.position.x, child.position.y*2+_handleNode.position.y);
//            NSLog(@"%ld Child pos:[%f,%f]",index,childLocation.x,childLocation.y);
            NSArray *shapeNodes = [self nodesAtPoint:childLocation];
            for (SKNode *shapeNode in shapeNodes) {
                if ([self isShapeUnit:(SKSpriteNode *)shapeNode] && ![self isUnitOcuppied:(SKSpriteNode *)shapeNode]) {
                    ocuppiedCount++;
                    [tempArray addObject:shapeNode];
                    
//                    NSLog(@"indexOfObject:%lu",(unsigned long)[self.unitNodeArray indexOfObject:shapeNode]);
//                    NSLog(@"unitshape pos:[%f,%f],size:[%f,%f]",shapeNode.position.x,shapeNode.position.y,shapeNode.frame.size.width,shapeNode.frame.size.height);
                }
            }
        }
        
//        NSLog(@"count:%lu, unitCount:%lu",(unsigned long)index,(unsigned long)ocuppiedCount);
        if ( index == ocuppiedCount ) {
            for (SKSpriteNode *unitNode in tempArray) {
                [unitNode setTexture:texture];
                ShapeUnitInfo *unitInfo = [unitNode.userData objectForKey:@"unitInfo"];
                unitInfo.occupy = YES;
//                NSLog(@"set occupy");
            }
            [_shapeArray removeObject:_handleNode];
            
            [_handleNode removeFromParent];
            [self shapeFill];
        }
        else {
            NSUInteger index = [_shapeArray indexOfObject:_handleNode];
            CGPoint location = [(NSValue *)[_shapePosArray objectAtIndex:index] CGPointValue];
            SKAction *scale = [SKAction scaleTo:1 duration:0.3];
            SKAction *move = [SKAction moveTo:location duration:0.3];
            SKAction *group = [SKAction group:@[scale,move]];
            group.timingMode = SKActionTimingEaseOut;
            [_handleNode runAction:group];
        }

        
        _handleNode = nil;
    }
    
    [self resultDealElimination];
    
    [self checkContinue];
}


#pragma mark - update
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - result check
- (BOOL)isShapeUnit:(SKSpriteNode *)unitNode {
//    ShapeUnitInfo *unitInfo = [unitNode.userData objectForKey:@"unitInfo"];
    if ([unitNode.name isEqual:@"unitShape"]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isUnitOcuppied:(SKSpriteNode *)unitNode {
    
    if ([self isShapeUnit:unitNode]) {
        ShapeUnitInfo *unitInfo = [unitNode.userData objectForKey:@"unitInfo"];
        if (unitInfo.occupy == YES)
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)setUnitOcuppied:(SKSpriteNode *)node ocuppied:(BOOL)ocuppiedStatus {
    if ([self isShapeUnit:node]) {
        ShapeUnitInfo *unitInfo = [node.userData objectForKey:@"unitInfo"];
        unitInfo.occupy = ocuppiedStatus;
    }
}

- (NSInteger)indexOfUnitShape:(SKSpriteNode *)shapeNode {
    if ([_unitNodeArray containsObject:shapeNode]) {
        return [_unitNodeArray indexOfObject:shapeNode];
    }
    
    return -1;
}

- (SKSpriteNode *)fetchAdjacentUnitWithNode:(SKSpriteNode *)node FromDirect:(ShapeUnitDirector)direct {
    if ([self isShapeUnit:node] && direct != SUDNone) {
        ShapeUnitInfo *unitInfo = [node.userData objectForKey:@"unitInfo"];
        NSInteger number =((NSString *)[unitInfo.adjacentArray objectAtIndex:direct]).integerValue;
        if (number == -1) {
            return nil;
        }
        return [_unitNodeArray objectAtIndex:number];
    }
    
    return nil;
}

- (NSArray *)dealDirectOcuppiedWithStartUnit:(NSInteger)startIndex direct:(ShapeUnitDirector)direct {
    
    SKSpriteNode *shapeNode = [_unitNodeArray objectAtIndex:startIndex];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if (shapeNode != nil && [self isUnitOcuppied:shapeNode] == YES) {
        SKSpriteNode *tempNode = shapeNode;
        ShapeUnitDirector suDirect = direct;
        while (tempNode != nil) {
            if (![self isUnitOcuppied:tempNode]) {
                // NO;
                return nil;
            }
            // YES;
            [tempArray addObject:tempNode];
            tempNode = [self fetchAdjacentUnitWithNode:tempNode FromDirect:suDirect];
        }
        
        return tempArray;
    }
    
    return nil;
}

- (void)eliminateNode:(SKSpriteNode *)node
{
    if ([self isShapeUnit:node]) {
        SKTexture *texture = [SKTexture textureWithImageNamed:@"6kuai_gray.png"];
        SKAction *action = [SKAction setTexture:texture];
        action.timingMode = SKActionTimingEaseOut;
        [node runAction:[SKAction setTexture:texture]];
        
        [self setUnitOcuppied:node ocuppied:NO];
    }
}

- (void)resultDealElimination {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSArray *compareIndexRow = @[@0,@5,@11,@18,@26,@35,@43,@50,@56];
    NSArray *compareIndexTopSlash = @[@0,@1,@2,@3,@4];
    NSArray *compareIndexBottomSlash = @[@56,@57,@58,@59,@60];
    
    for (NSNumber *index in compareIndexRow) {
        NSArray *compareResult = [self dealDirectOcuppiedWithStartUnit:index.integerValue direct:SUDRight];
        if (compareResult != nil) {
            [resultArray addObject:compareResult];
        }
    }
    
    for (NSNumber *index in compareIndexTopSlash) {
        NSArray *compareResult = [self dealDirectOcuppiedWithStartUnit:index.integerValue direct:SUDBottomLeft];
        if (compareResult != nil) {
            [resultArray addObject:compareResult];
        }
        
        compareResult = [self dealDirectOcuppiedWithStartUnit:index.integerValue direct:SUDBottomRight];
        if (compareResult != nil) {
            [resultArray addObject:compareResult];
        }
    }
    
    for (NSNumber *index in compareIndexBottomSlash) {
        NSArray *compareResult = [self dealDirectOcuppiedWithStartUnit:index.integerValue direct:SUDTopLeft];
        if (compareResult != nil) {
            [resultArray addObject:compareResult];
        }
        
        compareResult = [self dealDirectOcuppiedWithStartUnit:index.integerValue direct:SUDTopRight];
        if (compareResult != nil) {
            [resultArray addObject:compareResult];
        }
    }
    
    if ([resultArray count] > 0) {
        NSUInteger scoreFactor = [resultArray count];
        for (NSArray *array in resultArray) {
            for (SKSpriteNode *node in array) {
                [self eliminateNode:node];
                _score += scoreFactor;
            }
        }
        [self changeScore];
    }
}

- (void)checkContinue
{
    for (SKSpriteNode *shape in _shapeArray) {
        for (SKSpriteNode *unitNode in _unitNodeArray) {
            if (![self isOccupByShape:shape atUnit:unitNode]) {
                return;
            }
        }
    }
    
    [self gameOver];
    NSLog(@"game over");
}

- (void)gameOver
{
    SKView *view = self.view;
    [self setPaused:YES];
    UIView *toast = [view viewWithTag:1001];
    UILabel *scoreLabel = (UILabel *)[toast viewWithTag:2001];
    [scoreLabel setText:[NSString stringWithFormat:@"得分：%lu",_score]];
    [toast setHidden:NO];
}

- (BOOL)isOccupByShape:(SKSpriteNode *)shapeNode atUnit:(SKSpriteNode *)unitNode
{
    NSArray *comSeqArray = (NSArray *)[shapeNode.userData objectForKey:@"shapeCompOrder"];
    
    SKSpriteNode *tempNode = unitNode;
    ShapeUnitInfo *nodeInfo = (ShapeUnitInfo *)[tempNode.userData objectForKey:@"unitInfo"];
    if ([nodeInfo isOccupied]) {
        return YES;
    }
    
    for (NSNumber *index in comSeqArray) {
        
        NSInteger nodeIndex = [(NSNumber *)[nodeInfo.adjacentArray objectAtIndex:[index unsignedIntegerValue]] integerValue];
        if(-1 == nodeIndex) {
            return YES;
        }
        
        tempNode = (SKSpriteNode *)[_unitNodeArray objectAtIndex:nodeIndex];
        nodeInfo = (ShapeUnitInfo *)[tempNode.userData objectForKey:@"unitInfo"];
        if ([nodeInfo isOccupied]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)changeScore
{
    SKLabelNode *label = (SKLabelNode *)[self childNodeWithName:@"scoreNumberLabel"];
    [label setText:[NSString stringWithFormat:@"%lu",_score]];
}



@end
