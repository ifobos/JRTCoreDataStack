#import "File.h"

@interface File ()

// Private interface goes here.

@end

@implementation File

#pragma mark - Class

+ (NSArray *)observableKeyNames {
    return @[@"name", @"creationDate"];
}


#pragma mark - KVO

- (void)setupKVO {
    for (NSString *key in [self.class observableKeyNames]) {
        [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    
}

- (void)clearKVO {
    for (NSString *key in [self.class observableKeyNames]) {
        [self removeObserver:self forKeyPath:key];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    self.modificationDate = [NSDate date];
}

#pragma mark - Life Cicle

- (void)awakeFromInsert {
    [super awakeFromInsert];
    [self setupKVO];
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    [self setupKVO];
}

- (void)willTurnIntoFault{
    [super willTurnIntoFault];
    [self clearKVO];
}

@end
