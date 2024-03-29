//
//  NSSet+Accessors.m
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @mneorr | mneorr.com. All rights reserved.
//

#import "NSSet+Accessors.h"

@implementation NSSet (Accessors)

- (id)first {
    NSArray *allObjects = self.allObjects;

    if (allObjects.count > 0)
        return allObjects[0];
    return nil;
}

- (id)last {
    return self.allObjects.lastObject;
}

- (void)each:(void (^)(id))block {
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj);
    }];
}

- (void)eachWithIndex:(void (^)(id, int))block {
    __block int counter = 0;
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj, counter);
        counter ++;
    }];
}

- (NSArray *)map:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        id newObject = block(object);
        [array addObject:newObject];
    }
    
    return array;
}

@end
