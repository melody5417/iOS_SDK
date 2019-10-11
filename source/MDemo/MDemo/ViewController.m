//
//  ViewController.m
//  MDemo
//
//  Created by yiqiwang(王一棋) on 2019/10/11.
//  Copyright © 2019 melody5417. All rights reserved.
//

#import "ViewController.h"
#import <MFramework/MFramework.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", [Cat new].description);
}


@end
