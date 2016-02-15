//
//  PBSingleTon.h
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#ifndef PBSingleTon_h
#define PBSingleTon_h


// .h文件的实现
#define SingletonH(className) \
\
+ (className *)sharedInstance;

// .m文件的实现
#if __has_feature(objc_arc) // 是ARC

#define SingletonM(className) \
\
static className *sharedInstance = nil; \
\
+ (className *)sharedInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[className alloc] init]; \
}); \
return sharedInstance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [super allocWithZone:zone]; \
}); \
return sharedInstance; \
}

#else // 不是ARC

#define SingletonM(className) \
\
static className *sharedInstance = nil; \
\
+ (className *)sharedInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[className alloc] init]; \
}); \
return sharedInstance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [super allocWithZone:zone]; \
}); \
return sharedInstance; \
} \
\
- (id) copyWithZone:(NSZone*)zone \
{ \
return self; \
} \
\
- (id) retain \
{ \
return self; \
} \
\
- (NSUInteger) retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (oneway void) release \
{ \
} \
\
- (id) autorelease \
{ \
return self; \
}

#endif
#endif /* PBSingleTon_h */
