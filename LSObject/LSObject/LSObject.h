//
//  LSObject.h
//  LSObject
//
//  Created by History on 14-5-13.
//  Copyright (c) 2014年 History. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSObject : NSObject
/**
 *  Create an Object With a NSDictionary
 *
 *  @param dictionary Source Dictionary
 *
 *  @return an Object
 */
+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
