#import "hooks.h"

static unsigned int (*orig_objc_getClassList)(Class*, int) = NULL;

static unsigned int hooked_objc_getClassList(Class* buffer, int bufferCount) {
    unsigned int totalCount = orig_objc_getClassList(buffer, bufferCount);
    if(!isCallerTweak() && totalCount > 0 && buffer) {
        unsigned int writeIdx = 0;
        for(unsigned int i = 0; i < totalCount && i < (unsigned int)bufferCount; i++) {
            if(buffer[i]) {
                NSString* className = NSStringFromClass(buffer[i]);
                if([className hasPrefix:@"_"]
                || [className containsString:@"Substrate"]
                || [className containsString:@"Cephei"]
                || [className containsString:@"Tweak"]
                || [className rangeOfString:@"^[_A-Za-z]*Hook" options:NSRegularExpressionSearch].location != NSNotFound
                || [className rangeOfString:@"^[_A-Za-z]*Inject" options:NSRegularExpressionSearch].location != NSNotFound) {
                    continue;
                }
                buffer[writeIdx++] = buffer[i];
            }
        }
        return writeIdx;
    }
    return totalCount;
}

void andromeda_hook_TweakClasses() {
    MSHookFunction(&objc_getClassList, &hooked_objc_getClassList, (void**)&orig_objc_getClassList);
}
