//
//  Persion.m
//  Dictionary2Object
//
//  Created by History on 14-5-13.
//  Copyright (c) 2014年 History. All rights reserved.
//

#import "Persion.h"

@implementation Persion
+ (Class)ls_property_studentAry_class
{
    return [Student class];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@ - %@", _name, _sex, [_student description]];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
    
    NSLog(@"This is SubClass : UndefinedKey - %@", key);
}
@end
