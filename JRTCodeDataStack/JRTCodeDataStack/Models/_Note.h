// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.h instead.

#import <CoreData/CoreData.h>
#import "File.h"

extern const struct NoteAttributes {
	__unsafe_unretained NSString *text;
} NoteAttributes;

extern const struct NoteRelationships {
	__unsafe_unretained NSString *notebook;
} NoteRelationships;

@class Notebook;

@interface NoteID : FileID {}
@end

@interface _Note : File {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) NoteID* objectID;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Notebook *notebook;

//- (BOOL)validateNotebook:(id*)value_ error:(NSError**)error_;

@end

@interface _Note (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (Notebook*)primitiveNotebook;
- (void)setPrimitiveNotebook:(Notebook*)value;

@end
