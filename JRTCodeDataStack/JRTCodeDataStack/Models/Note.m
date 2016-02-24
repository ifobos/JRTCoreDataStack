#import "Note.h"

@interface Note ()

// Private interface goes here.

@end

@implementation Note

+ (NSArray *)observableKeyNames {
    return @[@"name", @"creationDate", @"notebook"];
}


+ (instancetype)noteWithName:(NSString *)name notebook:(Notebook *)notebook context:(NSManagedObjectContext *)context {
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:[Note entityName] inManagedObjectContext:context];
    note.name = name;
    note.creationDate = [NSDate date];
    note.modificationDate = [NSDate date];
    note.notebook = notebook;
    
    return note;
}

@end
