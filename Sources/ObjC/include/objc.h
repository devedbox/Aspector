//
//  objc.h
//  ObjC
//
//  Created by devedbox on 2018/8/24.
//

#ifndef objc_h
#define objc_h

#import <objc/runtime.h>
#import <Foundation/NSObject.h>

NS_ASSUME_NONNULL_BEGIN
_Nonnull IMP
objc_msgForward_imp(_Nonnull id self, _Nonnull SEL selector);

void
objc_send_msgForward(_Nonnull id self, _Nonnull SEL selector, _Nonnull id invocation);

BOOL
objc_responds_to(_Nonnull id obj, _Nonnull SEL selector);

@interface ASPInvocation: NSObject {
    id _invocation;
}
- (nullable instancetype)initWithObjcInvocation:(id _Nonnull)invocation;

@property (readonly, nonatomic) NSMethodSignature *methodSignature;

- (void)retainArguments;
@property (readonly) BOOL argumentsRetained;

@property (nonatomic, nullable) id target;
@property (nonatomic) SEL selector;

- (void)getReturnValue:(void *)retLoc;
- (void)setReturnValue:(void *)retLoc;

- (void)getArgument:(void *)argumentLocation atIndex:(NSInteger)idx;
- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx;

- (void)invoke;
- (void)invokeWithTarget:(id)target;

- (nullable id)argumentAtIndex:(NSUInteger )idx;
- (nonnull NSArray *)arguments;

- (nullable id)returnValue;
@end
NS_ASSUME_NONNULL_END
#endif /* objc_h */
