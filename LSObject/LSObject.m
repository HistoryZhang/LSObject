//
//  LSObject.m
//  LSObject
//
//  Created by History on 14-5-13.
//  Copyright (c) 2014年 History. All rights reserved.
//

#import "LSObject.h"
#import <objc/runtime.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface LSRuntimeHelper : NSObject
+ (NSDictionary *)propertyWithClass:(Class)aClass;
+ (NSArray *)propertyNamesWithClass:(Class)aClass;
@end

@implementation LSRuntimeHelper

+ (NSDictionary *)propertyWithClass:(Class)aClass
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
    NSMutableDictionary *propertyDictionary = [NSMutableDictionary dictionaryWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@\"\\w+\"" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result = [regex firstMatchInString:attributes options:0 range:NSMakeRange(0, attributes.length)];
        NSString *type = [attributes substringWithRange:NSMakeRange(result.range.location + 2, result.range.length - 3)];
        [propertyDictionary setObject:type forKey:name];
    }
    free(properties);
    return propertyDictionary;
}

+ (NSArray *)propertyNamesWithClass:(Class)aClass
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
    NSMutableArray *propertyNameAry = [NSMutableArray arrayWithCapacity:outCount];
    for (i = 0; i < outCount; ++ i) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [propertyNameAry addObject:name];
    }
    free(properties);
    return propertyNameAry;
}

@end

@interface LSObject () <NSCoding>
@property (nonatomic, strong) NSDictionary *property;
@end
@implementation LSObject

- (void)encodeWithCoder:(NSCoder*)encoder
{
	for (NSString *key in [LSRuntimeHelper propertyNamesWithClass:[self class]]) {
		[encoder encodeObject:[self valueForKey:key] forKey:key];
	}
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		for (NSString *key in [LSRuntimeHelper propertyNamesWithClass:[self class]]) {
			id value = [decoder decodeObjectForKey:key];
			if (value != [NSNull null] && value) {
				[self setValue:value forKey:key];
			}
		}
	}
	return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _property = [LSRuntimeHelper propertyWithClass:[self class]];
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    LSObject *object = [[LSObject alloc] initWithDictionary:dictionary];
    return object;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSString *propertyTypeString = [_property valueForKey:key];
    Class propertyTypeClass = NSClassFromString(propertyTypeString);
    if ([propertyTypeClass isSubclassOfClass:[NSDictionary class]]) {
        [super setValue:value forKey:key];
    }
    else if ([propertyTypeClass isSubclassOfClass:[NSArray class]]) {
        NSString *selector_string = [NSString stringWithFormat:@"ls_property_%@_class", key];
        SEL aSel = NSSelectorFromString(selector_string);
        if ([[self class] respondsToSelector:aSel]) {
            NSMutableArray *objAry = [NSMutableArray array];
            Class objClass;
            SuppressPerformSelectorLeakWarning(
                                               objClass = [[self class] performSelector:aSel]
                                               );
            for (NSDictionary *dictionary in value) {
                id obj = [[objClass alloc] initWithDictionary:dictionary];
                [objAry addObject:obj];
            }
            [super setValue:[[propertyTypeClass alloc] initWithArray:objAry] forKey:key];
        }
        else {
            [super setValue:value forKey:key];
        }
    }
    else if ([propertyTypeClass isSubclassOfClass:[LSObject class]]) {
        id obj = [[propertyTypeClass alloc] initWithDictionary:value];
        [super setValue:obj forKey:key];
    }
    else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end