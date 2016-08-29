//
//  MBProgressHUD+MBProgressHUDView.m
//  Botianxia
//
//  Created by CNEONLINE on 16/5/10.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import "MBProgressHUD+MBProgressHUDView.h"

@implementation MBProgressHUD (MBProgressHUDView)

- (void)showByCustomView:(BOOL)animated
{
    [self initCustomView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show:animated];
    });
}

- (void)initCustomView
{
    self.mode = MBProgressHUDModeCustomView;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=30; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"earthRotation-%zd", i]];
        [idleImages addObject:image];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    self.customView = imageView;
    imageView.animationDuration = 4;
    [(UIImageView*)(self.customView) setAnimationImages:idleImages];
    [(UIImageView*)(self.customView) startAnimating];
    
}

- (void)showByCustomViewAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(MBProgressHUDCompletionBlock)completion
{
    [self initCustomView];
    [self showAnimated:YES whileExecutingBlock:^{
        block();
    }completionBlock:^{
        completion();
        if ([(UIImageView*)(self.customView) isAnimating])
        {
            [(UIImageView*)(self.customView) stopAnimating];
        }
    }];
}

- (void)hideByCustomView:(BOOL)animated
{
    self.mode = MBProgressHUDModeCustomView;
    if ([(UIImageView*)(self.customView) isAnimating])
    {
        [(UIImageView*)(self.customView) stopAnimating];
       
    }
     self.customView = nil;
    [self hide:animated];
}

@end
