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


#import "JRTCoreDataStack.h"

@interface JRTCoreDataStack ()

@property (strong, nonatomic, readonly) NSManagedObjectModel *model;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *storeCoordinator;
@property (strong, nonatomic) NSURL *modelURL;
@property (strong, nonatomic) NSURL *dbURL;
@property (nonatomic)NSTimeInterval autoSaveDelay;
@end

@implementation JRTCoreDataStack

#pragma mark -  Properties
// When using a readonly property with a custom getter, auto-synthesize
// is disabled.
// See http://www.cocoaosx.com/2012/12/04/auto-synthesize-property-reglas-excepciones/
// (in Spanish)
@synthesize model = _model;
@synthesize storeCoordinator = _storeCoordinator;
@synthesize context = _context;


- (NSManagedObjectContext *)context {
    if (_context == nil) {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = self.storeCoordinator;
    }
    
    return _context;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if (_storeCoordinator == nil) {
        _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        
        NSError *err = nil;
        if (![_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:self.dbURL
                                                   options:nil
                                                     error:&err]) {
            // Something went really wrong...
            // Send a notification and return nil
            NSNotification *note = [NSNotification
                                    notificationWithName:[JRTCoreDataStack persistentStoreCoordinatorErrorNotificationName]
                                                  object:self
                                                userInfo:@{@"error": err}];
            [[NSNotificationCenter defaultCenter] postNotification:note];
            NSLog(@"Error while adding a Store: %@", err);
            return nil;
        }
    }
    
    return _storeCoordinator;
}

- (NSManagedObjectModel *)model {
    if (_model == nil) {
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    }
    
    return _model;
}

#pragma mark - Class Methods

+ (NSString *)persistentStoreCoordinatorErrorNotificationName {
    return @"persistentStoreCoordinatorErrorNotificationName";
}

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (JRTCoreDataStack *)coreDataStackWithModelName:(NSString *)aModelName databaseFilename:(NSString *)aDBName {
    NSURL *url = nil;
    
    if (aDBName) {
        url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:aDBName];
    }
    else {
        url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:aModelName];
    }
    
    return [self coreDataStackWithModelName:aModelName
                                databaseURL:url];
}

+ (JRTCoreDataStack *)coreDataStackWithModelName:(NSString *)aModelName {
    return [self coreDataStackWithModelName:aModelName databaseFilename:nil];
}

+ (JRTCoreDataStack *)coreDataStackWithModelName:(NSString *)aModelName databaseURL:(NSURL *)aDBURL {
    return [[self alloc] initWithModelName:aModelName databaseURL:aDBURL];
}

#pragma mark - Init

- (id)initWithModelName:(NSString *)aModelName
            databaseURL:(NSURL *)aDBURL {
    if (self = [super init]) {
        self.modelURL = [[NSBundle mainBundle] URLForResource:aModelName withExtension:@"momd"];
        self.dbURL = aDBURL;
    }
    
    return self;
}

#pragma mark - Delete

- (void)deleteAllData {
    NSError *err = nil;
    for (NSPersistentStore *store in self.storeCoordinator.persistentStores) {
        if (![self.storeCoordinator removePersistentStore:store error:&err]) {
            NSLog(@"Error while removing store %@ from store coordinator %@", store, self.storeCoordinator);
        }
    }
    if (![[NSFileManager defaultManager] removeItemAtURL:self.dbURL error:&err]) {
        NSLog(@"Error removing %@: %@", self.dbURL, err);
    }
    
    // The Core Data stack does not like you removing the file under it. If you want to delete the file
    // you should tear down the stack, delete the file and then reconstruct the stack.
    // Part of the problem is that the stack keeps a cache of the data that is in the file. When you
    // remove the file you don't have a way to clear that cache and you are then putting
    // Core Data into an unknown and unstable state.
    
    _context = nil;
    _storeCoordinator = nil;
    [self context]; // this will rebuild the stack
}

- (void)deleteObject:(NSManagedObject *)object {
    [self.context deleteObject:object];
}

#pragma mark - Save

- (void)saveWithErrorBlock:(void (^)(NSError *error))errorBlock {
    NSError *err = nil;
    // If a context is nil, saving it should also be considered an
    // error, as being nil might be the result of a previous error
    // while creating the db.
    if (!_context) {
        err = [NSError errorWithDomain:@"JRTCoreDataStack"
                                  code:1
                              userInfo:@{ NSLocalizedDescriptionKey: @"Attempted to save a nil NSManagedObjectContext. This AGTSimpleCoreDataStack has no context - probably there was an earlier error trying to access the CoreData database file." }];
        errorBlock(err);
    }
    else if (self.context.hasChanges) {
        if (![self.context save:&err]) {
            errorBlock(err);
        }
    }
}

- (void)autoSaveWithErrorBlock:(void (^)(NSError *error))errorBlock
                    afterDelay:(NSTimeInterval)delay
                        repeat:(BOOL)repeat {
    if (repeat) {
        self.autoSaveDelay = delay;
        [self autoSaveWithErrorBlock:errorBlock];
    }
    else {
        [self performSelector:@selector(saveWithErrorBlock:) withObject:errorBlock afterDelay:delay];
    }
}

- (void)autoSaveWithErrorBlock:(void (^)(NSError *error))errorBlock {
    [self saveWithErrorBlock:errorBlock];
    [self performSelector:@selector(autoSaveWithErrorBlock:) withObject:errorBlock afterDelay:self.autoSaveDelay];
}

#pragma mark - Request

- (NSArray *)executeRequest:(NSFetchRequest *)request
                  withError:(void (^)(NSError *error))errorBlock {
    NSError *err = nil;
    NSArray *results = nil;
    
    if (!_context) {
        err = [NSError errorWithDomain:@"JRTCoreDataStack"
                                  code:1
                              userInfo:@{ NSLocalizedDescriptionKey: @"Attempted to search a nil NSManagedObjectContext. This AGTSimpleCoreDataStack has no context - probably there was an earlier error trying to access the CoreData database file." }];
        errorBlock(err);
    }
    else {
        results = [self.context executeFetchRequest:request
                                              error:&err];
        if (!results) {
            errorBlock(err);
        }
    }
    
    return results;
}

#pragma mark - Fetch Result Controller

- (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest
                                                      sectionNameKeyPath:(NSString *)sectionNameKeyPath {
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:self.context
                                                 sectionNameKeyPath:sectionNameKeyPath
                                                          cacheName:nil];
}

- (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest {
    return [self fetchedResultsControllerWithFetchRequest:fetchRequest sectionNameKeyPath:nil];
}

#pragma mark - Undo Manager

- (void)undoManagerActive:(BOOL)active {
    if (active) {
        self.context.undoManager = [[NSUndoManager alloc] init];
    }
    else {
        self.context.undoManager = nil;
    }

}
@end
