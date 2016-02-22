
#define SingletonInterface(Class) +(instancetype)shared##Class;

#if __has_feature(objc_arc)

// ARC
#define SingletonImplementation(Class) \
static Class *_instance; \
+(instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
+(instancetype)shared##Class \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
} \
-(id)copyWithZone:(NSZone *)zone \
{ \
    return _instance; \
}

#else

// MRC
#define SingletonImplementation(Class) \
static Class *_instance; \
+(instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+(instancetype)shared##Class \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
-(id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
- (oneway void)release{} \
- (instancetype)retain{return _instance;} \
- (instancetype)autorelease{return _instance;} \
- (NSUInteger)retainCount{return ULONG_MAX;}

#endif// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com