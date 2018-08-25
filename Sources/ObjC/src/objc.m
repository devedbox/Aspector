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
@end
