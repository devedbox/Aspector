//
//  objc.m
//  ObjC
//
//  Created by devedbox on 2018/8/24.
//

#import "objc.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/Foundation.h>

_Nonnull IMP objc_msgForward_imp(_Nonnull id self, _Nonnull SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    // As an ugly internal runtime implementation detail in the 32bit runtime, we need to determine of the method we hook returns a struct or anything larger than id.
    // https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/783
    // http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf (Section 5.4)
    Method method = class_getInstanceMethod([self class], selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}

void objc_send_msgForward(_Nonnull id self, _Nonnull SEL selector, _Nonnull id invocation) {
    if (![invocation isKindOfClass:[NSInvocation class]]) {
        return;
    }
    
    ((void( *)(id, SEL, NSInvocation *))objc_msgSend)(self, selector, (NSInvocation *)invocation);
}

BOOL objc_responds_to(_Nonnull id obj, _Nonnull SEL selector) {
    return [obj respondsToSelector:selector];
}

@implementation ASPInvocation

- (instancetype)initWithObjcInvocation:(id)invocation {
    if (![invocation isKindOfClass:[NSInvocation class]]) {
        return nil;
    }
    
    if (self = [super init]) {
        _invocation = invocation;
    }
    return self;
}

- (NSMethodSignature *)methodSignature {
    return [(NSInvocation *)_invocation methodSignature];
}

- (void)retainArguments {
    [(NSInvocation *)_invocation retainArguments];
}

- (BOOL)argumentsRetained {
    return [(NSInvocation *)_invocation argumentsRetained];
}

- (id)target {
    return [(NSInvocation *)_invocation target];
}

- (void)setTarget:(id)target {
    [(NSInvocation *)_invocation setTarget:target];
}

- (SEL)selector {
    return [(NSInvocation *)_invocation selector];
}

- (void)setSelector:(SEL)selector {
    [(NSInvocation *)_invocation setSelector:selector];
}

- (void)getReturnValue:(void *)retLoc {
    return [(NSInvocation *)_invocation getReturnValue:retLoc];
}

- (void)setReturnValue:(void *)retLoc {
    return [(NSInvocation *)_invocation setReturnValue:retLoc];
}

- (void)getArgument:(void *)argumentLocation atIndex:(NSInteger)idx {
    return [(NSInvocation *)_invocation getArgument:argumentLocation atIndex:idx];
}

- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx {
    [(NSInvocation *)_invocation setArgument:argumentLocation atIndex:idx];
}

- (void)invoke {
    [(NSInvocation *)_invocation invoke];
}

- (void)invokeWithTarget:(id)target {
    [(NSInvocation *)_invocation invokeWithTarget:target];
}

// Thanks to the ReactiveCocoa & Aspects team for providing a generic solution for this.
- (id)argumentAtIndex:(NSUInteger)index {
    const char *argType = [self.methodSignature getArgumentTypeAtIndex:index];
    // Skip const type qualifier.
    if (argType[0] == _C_CONST) argType++;
    
#define WRAP_AND_RETURN(type) do { type val = 0; [self getArgument:&val atIndex:(NSInteger)index]; return @(val); } while (0)
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        __autoreleasing id returnObj;
        [self getArgument:&returnObj atIndex:(NSInteger)index];
        return returnObj;
    } else if (strcmp(argType, @encode(SEL)) == 0) {
        SEL selector = 0;
        [self getArgument:&selector atIndex:(NSInteger)index];
        return NSStringFromSelector(selector);
    } else if (strcmp(argType, @encode(Class)) == 0) {
        __autoreleasing Class theClass = Nil;
        [self getArgument:&theClass atIndex:(NSInteger)index];
        return theClass;
        // Using this list will box the number with the appropriate constructor, instead of the generic NSValue.
    } else if (strcmp(argType, @encode(char)) == 0) {
        WRAP_AND_RETURN(char);
    } else if (strcmp(argType, @encode(int)) == 0) {
        WRAP_AND_RETURN(int);
    } else if (strcmp(argType, @encode(short)) == 0) {
        WRAP_AND_RETURN(short);
    } else if (strcmp(argType, @encode(long)) == 0) {
        WRAP_AND_RETURN(long);
    } else if (strcmp(argType, @encode(long long)) == 0) {
        WRAP_AND_RETURN(long long);
    } else if (strcmp(argType, @encode(unsigned char)) == 0) {
        WRAP_AND_RETURN(unsigned char);
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        WRAP_AND_RETURN(unsigned int);
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        WRAP_AND_RETURN(unsigned short);
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        WRAP_AND_RETURN(unsigned long);
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        WRAP_AND_RETURN(unsigned long long);
    } else if (strcmp(argType, @encode(float)) == 0) {
        WRAP_AND_RETURN(float);
    } else if (strcmp(argType, @encode(double)) == 0) {
        WRAP_AND_RETURN(double);
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(argType, @encode(bool)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(argType, @encode(char *)) == 0) {
        WRAP_AND_RETURN(const char *);
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        __unsafe_unretained id block = nil;
        [self getArgument:&block atIndex:(NSInteger)index];
        return [block copy];
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(argType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [self getArgument:valueBytes atIndex:(NSInteger)index];
        
        return [NSValue valueWithBytes:valueBytes objCType:argType];
    }
    return nil;
#undef WRAP_AND_RETURN
}

- (id)returnValue {
    const char *rtnType = [self.methodSignature methodReturnType];
    // Skip const type qualifier.
    if (rtnType[0] == _C_CONST) rtnType++;
    if (strcmp(rtnType, @encode(void)) == 0) return nil;
    
#define WRAP_AND_RETURN(type) do { type val = 0; [self getReturnValue:&val]; return @(val); } while (0)
    if (strcmp(rtnType, @encode(id)) == 0 || strcmp(rtnType, @encode(Class)) == 0) {
        __autoreleasing id returnObj;
        [self getReturnValue:&returnObj];
        return returnObj;
    } else if (strcmp(rtnType, @encode(SEL)) == 0) {
        SEL selector = 0;
        [self getReturnValue:&selector];
        return NSStringFromSelector(selector);
    } else if (strcmp(rtnType, @encode(Class)) == 0) {
        __autoreleasing Class theClass = Nil;
        [self getReturnValue:&theClass];
        return theClass;
        // Using this list will box the number with the appropriate constructor, instead of the generic NSValue.
    } else if (strcmp(rtnType, @encode(char)) == 0) {
        WRAP_AND_RETURN(char);
    } else if (strcmp(rtnType, @encode(int)) == 0) {
        WRAP_AND_RETURN(int);
    } else if (strcmp(rtnType, @encode(short)) == 0) {
        WRAP_AND_RETURN(short);
    } else if (strcmp(rtnType, @encode(long)) == 0) {
        WRAP_AND_RETURN(long);
    } else if (strcmp(rtnType, @encode(long long)) == 0) {
        WRAP_AND_RETURN(long long);
    } else if (strcmp(rtnType, @encode(unsigned char)) == 0) {
        WRAP_AND_RETURN(unsigned char);
    } else if (strcmp(rtnType, @encode(unsigned int)) == 0) {
        WRAP_AND_RETURN(unsigned int);
    } else if (strcmp(rtnType, @encode(unsigned short)) == 0) {
        WRAP_AND_RETURN(unsigned short);
    } else if (strcmp(rtnType, @encode(unsigned long)) == 0) {
        WRAP_AND_RETURN(unsigned long);
    } else if (strcmp(rtnType, @encode(unsigned long long)) == 0) {
        WRAP_AND_RETURN(unsigned long long);
    } else if (strcmp(rtnType, @encode(float)) == 0) {
        WRAP_AND_RETURN(float);
    } else if (strcmp(rtnType, @encode(double)) == 0) {
        WRAP_AND_RETURN(double);
    } else if (strcmp(rtnType, @encode(BOOL)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(rtnType, @encode(bool)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(rtnType, @encode(char *)) == 0) {
        WRAP_AND_RETURN(const char *);
    } else if (strcmp(rtnType, @encode(void (^)(void))) == 0) {
        __unsafe_unretained id block = nil;
        [self getReturnValue:&block];
        return [block copy];
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(rtnType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [self getReturnValue:valueSize];
        
        return [NSValue valueWithBytes:valueBytes objCType:rtnType];
    }
    return nil;
#undef WRAP_AND_RETURN
}

- (NSArray *)arguments {
    NSMutableArray *argumentsArray = [NSMutableArray array];
    for (NSUInteger idx = 2; idx < self.methodSignature.numberOfArguments; idx++) {
        [argumentsArray addObject:[self argumentAtIndex:idx] ?: NSNull.null];
    }
    return [argumentsArray copy];
}
@end
