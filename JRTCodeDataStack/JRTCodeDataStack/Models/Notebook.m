#import "Notebook.h"

@interface Notebook ()

// Private interface goes here.

@end

@implementation Notebook

+ (NSArray *)observableKeyNames {
    return @[@"name", @"creationDate", @"notes"];
}

+ (instancetype)notebookWithName:(NSString *)name context:(NSManagedObjectContext *)context {
    Notebook *notebook = [NSEntityDescription insertNewObjectForEntityForName:[Notebook entityName] inManagedObjectContext:context];
    notebook.name = name;
    notebook.creationDate = [NSDate date];
    notebook.modificationDate = [NSDate date];
    return notebook;
}

@end
