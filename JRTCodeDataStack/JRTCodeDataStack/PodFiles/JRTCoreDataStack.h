//Copyright (c) 2015 Juan Carlos Garcia Alfaro. All rights reserved.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

@import CoreData;

#import <Foundation/Foundation.h>

@interface JRTCoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

+ (NSString *)persistentStoreCoordinatorErrorNotificationName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName
                          databaseFilename:(NSString *)aDBName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName
                               databaseURL:(NSURL *)aDBURL;

- (id)initWithModelName:(NSString *)aModelName
            databaseURL:(NSURL *)aDBURL;

- (void)deleteAllData;

- (void)saveWithErrorBlock:(void (^)(NSError *error))errorBlock;

- (NSArray *)executeRequest:(NSFetchRequest *)request
                  withError:(void (^)(NSError *error))errorBlock;

- (void)deleteObject:(NSManagedObject *)object;

- (void)autoSaveWithErrorBlock:(void (^)(NSError *error))errorBlock
                    afterDelay:(NSTimeInterval)delay
                        repeat:(BOOL)repeat;

- (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest;

- (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest
                                                      sectionNameKeyPath:(NSString *)sectionNameKeyPath;

@end
