//
//  JJSDynamicAnimation.h
//  pop
//
//  Created by RuanSTao on 15/8/20.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^DynamicAnimationComplete)(BOOL finish);
typedef void (^DynamicMove)(CGPoint center);
@interface JJSDynamicAnimation : NSObject 

//自动移除
+ (void) animatorWithReferenceView:(UIView *)view andItems:(NSArray *)items completeWithBlock:(DynamicAnimationComplete) complete;

//需要手动移除
- (void) animatorWithReferenceView:(UIView *)view andItems:(NSArray *)items completeWithBlock:(DynamicAnimationComplete) complete;

-(void) invalidate;
@property (nonatomic,strong)DynamicMove moveblock;

@end
