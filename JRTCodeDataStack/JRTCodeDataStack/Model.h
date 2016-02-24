//
//  Model.h
//  JRTCodeDataStack
//
//  Created by Juan Garcia on 2/18/16.
//  Copyright © 2016 jerti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRTCoreDataStack.h"

@interface Model : JRTCoreDataStack
+ (instancetype)sharedInstance;
@end
