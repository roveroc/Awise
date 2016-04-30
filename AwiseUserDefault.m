//
//  AwiseUserDefault.m
//  AwiseController
//
//  Created by rover on 16/4/30.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "AwiseUserDefault.h"

@implementation AwiseUserDefault


+ (AwiseUserDefault *)sharedInstance{
    static AwiseUserDefault *gInstance = NULL;
    @synchronized(self){
        if (!gInstance)
            gInstance = [self new];
    }
    return(gInstance);
}


- (void)setSingleTouchSceneValue:(NSString *)singleTouchSceneValue{
    [[NSUserDefaults standardUserDefaults] setObject:singleTouchSceneValue forKey:@"singleTouchSceneValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)singleTouchSceneValue{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"singleTouchSceneValue"];
}




@end
