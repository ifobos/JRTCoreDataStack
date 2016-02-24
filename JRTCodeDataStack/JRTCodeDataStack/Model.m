//
//  Model.m
//  JRTCodeDataStack
//
//  Created by Juan Garcia on 2/18/16.
//  Copyright © 2016 jerti. All rights reserved.
//

#import "Model.h"
#import "Notebook.h"
#import "Note.h"

@implementation Model

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self coreDataStackWithModelName:@"Model"];
                      [sharedInstance dataDummy];
                  });

    return sharedInstance;
}

- (void)dataDummy {
    [self deleteAllData];
    for (int i = 0 ; i < 9 ; i++) {
        Notebook *notebook = [Notebook notebookWithName:[NSString stringWithFormat:@"Notebook %i", i] context:self.context];
        for (int j = 0 ; j < 9 ; j++) {
            [Note noteWithName:[NSString stringWithFormat:@"Note %i", j] notebook:notebook context:self.context];
        }
    }
}
@end
