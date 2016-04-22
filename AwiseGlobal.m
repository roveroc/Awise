//
//  AwiseGlobal.m
//  AwiseController
//
//  Created by rover on 16/4/21.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "AwiseGlobal.h"

@implementation AwiseGlobal

+ (AwiseGlobal *)sharedInstance{
    static AwiseGlobal *gInstance = NULL;
    @synchronized(self){
        if (!gInstance){
            gInstance = [self new];
        }
    }
    return(gInstance);
}




@end
