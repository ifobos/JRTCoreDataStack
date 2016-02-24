#import "_Note.h"

@interface Note : _Note {}
+ (instancetype)noteWithName:(NSString *)name notebook:(Notebook *)notebook context:(NSManagedObjectContext *)context;
@end
