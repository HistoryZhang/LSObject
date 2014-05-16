LSObject
========

Convert a NSDictionary to a Custom Object.

========
This project uses KVO.You can see more about KVO from www.google.com

========
You can use it as follow:

1.Create a subclass of LSObject.

2.If the class DO NOT have custom Class(only NSString, NSNumber), you use it just like this.

	@interface Student : LSObject
	@property (nonatomic, copy) NSString *hello;
	@property (nonatomic, copy) NSString *world;
	@end
	
	@implementation Student

	@end
  if NOT.Like this:

 	@interface Persion : LSObject
	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, copy) NSString *sex;
	@property (nonatomic, retain) NSArray *studentAry;
	@property (nonatomic, retain) Student *student;
	@end

   Then you should have an CLASS function for key studentAry if the objects in the NSArray is custom object like Student.

   The function name should be + (Class)ls_property_keyname_class;Replace the keyname with your key(studentAry in this example).

   You should NOT give an CLASS function for key student.We know its Class.

	@implementation Persion
	+ (Class)ls_property_studentAry_class
	{
	    return [Student class];
	}
	@end
	
3.If you have an Undifined Key or a key name is id.You can set it as follow: 

	- (void)setValue:(id)value forUndefinedKey:(NSString *)key
	{
		NSLog(@"This is SubClass : UndefinedKey - %@", key);
		[super setValue:value forUndefinedKey:key];
		if ([key isEqualToString:"keyname")]) {
			self.keyname = value;
		}
	}

4.Create your instance like this:

	 NSDictionary *dictionary = @{@"undefine": @"undefine",
	                                     @"name": @"History",
	                                     @"sex": @"male",
	                                     @"student": @{@"hello": @"你好",
	                                                   @"world": @"世界"},
	                                     @"studentAry": @[@{@"hello": @"你好1",
	                                                        @"world": @"世界1"},
	                                                      @{@"hello": @"你好2",
	                                                        @"world": @"世界2"}]
	                                     };
    Persion *persion = [[Persion alloc] initWithDictionary:dictionary];
    
    Persion *persion2 = [Persion objectWithDictionary:dictionary];

TODO
========
NSNull 
BOOL
READONLY
More and More...