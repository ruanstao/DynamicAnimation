//
//  ViewController.m
//  DynamicAnimation
//
//  Created by RuanSTao on 15/8/26.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import "ViewController.h"
#import "JJSDynamicAnimation.h"

@interface ViewController ()
{
    JJSDynamicAnimation *_dynamicAnimation;
     CGRect originalRect;
}
@property (weak, nonatomic) IBOutlet UIView *ads;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    originalRect = self.ads.frame;

}
- (IBAction)first:(id)sender {
    self.ads.frame = originalRect;
    _dynamicAnimation = [[JJSDynamicAnimation alloc] init];
    [_dynamicAnimation animatorWithReferenceView:self.view andItems:@[self.ads] completeWithBlock:^(BOOL finish) {
        
        NSLog(@"first end");
        
    }];
    __weak JJSDynamicAnimation *weakDynamic = _dynamicAnimation;
    _dynamicAnimation.moveblock = ^(CGPoint center){
        __strong JJSDynamicAnimation *strongDynamic = weakDynamic;
        //        NSLog(@"center %f,%f",center.x,center.y);
        
        [strongDynamic invalidate];
        
        NSLog(@"first invalidate");
        
    };
}
- (IBAction)second:(id)sender {
    self.ads.frame = originalRect;
    [JJSDynamicAnimation animatorWithReferenceView:self.view andItems:@[self.ads] completeWithBlock:^(BOOL finish) {
        NSLog(@"second end");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
