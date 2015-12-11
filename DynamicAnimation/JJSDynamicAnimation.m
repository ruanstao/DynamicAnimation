//
//  JJSDynamicAnimation.m
//  pop
//
//  Created by RuanSTao on 15/8/20.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import "JJSDynamicAnimation.h"
@interface JJSDynamicAnimation()<UIGestureRecognizerDelegate>
{
    UIDynamicAnimator *_animator;
    DynamicAnimationComplete _completeBlock;
    NSTimer *_time;
    BOOL _autoRemove;
    UIView *_localView;
    NSArray *_localItems;
    UISnapBehavior *_snapBehavior;
//    UIGravityBehavior *_gravityBehavior;
}
@end

@implementation JJSDynamicAnimation

+ (void) animatorWithReferenceView:(UIView *)view andItems:(NSArray *)items completeWithBlock:(DynamicAnimationComplete) complete
{
    JJSDynamicAnimation *animation = [[JJSDynamicAnimation alloc] init];
    [animation animatorWithReferenceView:view andItems:items completeWithBlock:complete autoRemoveBehavior:YES];
}

- (void) animatorWithReferenceView:(UIView *)view andItems:(NSArray *)items completeWithBlock:(DynamicAnimationComplete) complete
{
    [self animatorWithReferenceView:view andItems:items completeWithBlock:complete autoRemoveBehavior:NO];
}

- (void) animatorWithReferenceView:(UIView *)view andItems:(NSArray *)items completeWithBlock:(DynamicAnimationComplete) complete autoRemoveBehavior:(BOOL) autoRemove
{
    if (nil != complete) {
        _completeBlock = complete;
    }
    _localView = view;
    _localItems = items;
    _autoRemove = autoRemove;
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:view];
    [self addBehaviors];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handlePanGestures:)];
        //        无论最大还是最小都只允许一个手指
//        panGestureRecognizer.minimumNumberOfTouches = 1;
//        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.delegate = self;
        [obj addGestureRecognizer:panGestureRecognizer];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taphandlePanGestures:)];
        [obj addGestureRecognizer:tapGestureRecognizer];
        
    }];


    _time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(running) userInfo:nil repeats:YES];
}

- (void) addBehaviors
{
    
    UIGravityBehavior * gravityBehavior= [[UIGravityBehavior alloc] initWithItems:_localItems];
    //    [behavior setGravityDirection:CGVectorMake(0.0f, 0.3f)];
    gravityBehavior.gravityDirection = CGVectorMake(0.0f, 10.0f);
    UIDynamicItemBehavior * itembehav = [[UIDynamicItemBehavior alloc] initWithItems:_localItems];
    itembehav.elasticity = 0.3;
    //    behavior.magnitude = 1;
    UICollisionBehavior * collision = [[UICollisionBehavior alloc] initWithItems:_localItems];
    collision.collisionMode = UICollisionBehaviorModeBoundaries;
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(99999, 0, 0, 0)];
    [_animator addBehavior:gravityBehavior];
    [_animator addBehavior:collision];
    [_animator addBehavior:itembehav];

}
- (void) running
{
    
}

- (void)taphandlePanGestures:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan ) {
        [_animator removeAllBehaviors];
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {

    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        [self addBehaviors];
    }

}

-(void)handlePanGestures:(UIPanGestureRecognizer *)recognizer
{
    CGPoint p = [recognizer translationInView:_localView];
    [recognizer setTranslation:CGPointZero inView:_localView];
//    NSLog(@"local point %f, %f  state %ld",p.x,p.y,recognizer.state);

    if (recognizer.state == UIGestureRecognizerStateBegan ) {
        [_animator removeAllBehaviors];
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (recognizer.view.center.y + p.y > _localView.center.y) {
            p.y = 0;
        }
        recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + p.y);

       
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        [self addBehaviors];
        if (self.moveblock) {
            self.moveblock(recognizer.view.center);
        }
    }

//    CGPoint tapPoint = [paramTap locationInView:self.view];
//    
//    if (self.snapBehavior != nil){
//        [self.animator removeBehavior:self.snapBehavior];
//    }
//    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.squareView snapToPoint:tapPoint];
//    self.snapBehavior.damping = 0.5f;  //剧列程度
//    [self.animator addBehavior:self.snapBehavior];
//    recognizer.view.center = CGPointMake(_localVIew.center.x, _localVIew.center.y + p.y);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _completeBlock = nil;
    }
    return self;
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator*)animator
{
//    NSLog(@"ani %@",animator);
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator
{
//    NSLog(@"ani %@",animator);
    

    if (nil != _completeBlock) {
        _completeBlock(YES);
    }
    if (_autoRemove) {
        [self invalidate];
    }
}

-(void) invalidate
{
    _localView  =  nil;
    _localItems = nil;
    [_animator removeAllBehaviors];
    [_time invalidate];
}

//- (void)dealloc
//{
//    NSLog(@" dealloc %@",[self class]);
//}

@end
