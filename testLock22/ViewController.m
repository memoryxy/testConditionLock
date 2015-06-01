//
//  ViewController.m
//  testLock22
//
//  Created by Jianfei Wang on 15/6/1.
//  Copyright (c) 2015年 Sina. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)testConditionLockArray_logStep
{
    
    const NSInteger noData = 0;
    const NSInteger hasData = 1;
    
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:noData];
    
    NSMutableArray *productors = [NSMutableArray array];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        int i=0;
        
        while (YES) {
            NSLog(@"a");
            [lock lockWhenCondition:noData];
            NSLog(@"b");
            [productors addObject:[NSString stringWithFormat:@"productor %d", i]];
            i++;
            [lock unlockWithCondition:hasData];
            NSLog(@"c");
            
        }
    });
    
    dispatch_async(queue, ^{
        while (YES) {
            NSLog(@"1");
            [lock lockWhenCondition:hasData];
            NSLog(@"2");
            NSString *obj = [productors objectAtIndex:0];
            [productors removeObject:obj];
            [lock unlockWithCondition:[productors count] == 0?noData:hasData];
            NSLog(@"3");
        }
    });
}

// 生产者消费者问题
- (void)testConditionLockArray
{
    
    const NSInteger noData = 0;
    const NSInteger hasData = 1;
    
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:noData];
    
    NSMutableArray *productors = [NSMutableArray array];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        int i=0;
        
        while (YES) {
            [lock lockWhenCondition:noData];
            [productors addObject:[NSString stringWithFormat:@"productor %d", i]];
            NSLog(@"produced %d", i);
            i++;
            [lock unlockWithCondition:hasData];

        }
    });
    
    dispatch_async(queue, ^{        
        while (YES) {
            [lock lockWhenCondition:hasData];
            NSString *obj = [productors objectAtIndex:0];
            [productors removeObject:obj];
            NSLog(@"consume the productor: %@", obj);
            [lock unlockWithCondition:[productors count] == 0?noData:hasData];
        }
    });
}

- (void)viewDidLoad {
    [self testConditionLockArray];
}

@end
