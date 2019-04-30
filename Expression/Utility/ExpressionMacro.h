//
//  ExpressionMacro.h
//  Pods
//
//  Created by bob on 2019/4/8.
//

#ifndef ExpressionMacro_h
#define ExpressionMacro_h

#if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
# define EXP_FINAL_CLASS __attribute__((objc_subclassing_restricted))
#else
# define EXP_FINAL_CLASS
#endif

#define ExpWeakSelf __weak typeof(self) wself = self
#define ExpStrongSelf __strong typeof(wself) self = wself



#endif /* ExpressionMacro_h */
