//
//  LSObject.h
//  LSObject
//
//  Created by History on 14-5-13.
//  Copyright (c) 2014年 History. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSObject : NSObject
+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
