// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Notebook.h instead.

#import <CoreData/CoreData.h>
#import "File.h"

extern const struct NotebookRelationships {
	__unsafe_unretained NSString *notes;
} NotebookRelationships;

@class Note;

@interface NotebookID : FileID {}
@end

@interface _Notebook : File {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) NotebookID* objectID;

@property (nonatomic, strong) NSSet *notes;

- (NSMutableSet*)notesSet;

@end

@interface _Notebook (NotesCoreDataGeneratedAccessors)
- (void)addNotes:(NSSet*)value_;
- (void)removeNotes:(NSSet*)value_;
- (void)addNotesObject:(Note*)value_;
- (void)removeNotesObject:(Note*)value_;

@end

@interface _Notebook (CoreDataGeneratedPrimitiveAccessors)

- (NSMutableSet*)primitiveNotes;
- (void)setPrimitiveNotes:(NSMutableSet*)value;

@end
