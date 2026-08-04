#import "hooks.h"

static kern_return_t (*orig_vm_region)(vm_map_t, vm_address_t*, vm_size_t*, vm_region_flavor_t, vm_region_info_t, mach_msg_type_number_t*, mach_port_t*) = NULL;
static kern_return_t (*orig_vm_region_64)(vm_map_t, vm_address_t*, vm_size_t*, vm_region_flavor_t, vm_region_info_t, mach_msg_type_number_t*, mach_port_t*) = NULL;
static kern_return_t (*orig_vm_region_recurse)(vm_map_t, vm_address_t*, vm_size_t*, uint32_t*, vm_region_recurse_info_t, mach_msg_type_number_t*) = NULL;
static kern_return_t (*orig_vm_region_recurse_64)(vm_map_t, vm_address_t*, vm_size_t*, uint32_t*, vm_region_recurse_info_t, mach_msg_type_number_t*) = NULL;

static kern_return_t hooked_vm_region(vm_map_t target_task, vm_address_t* address, vm_size_t* size, vm_region_flavor_t flavor, vm_region_info_t info, mach_msg_type_number_t* infoCnt, mach_port_t* object_name) {
    kern_return_t result = orig_vm_region(target_task, address, size, flavor, info, infoCnt, object_name);
    if(result == KERN_SUCCESS && !isCallerTweak() && info && flavor == VM_REGION_BASIC_INFO_64) {
        vm_region_basic_info_64_t basic_info = (vm_region_basic_info_64_t)info;
        if(basic_info->protection & VM_PROT_EXECUTE) {
            const char* name = dyld_image_path_containing_address((void*)*address);
            if(name) {
                NSString* nsName = @(name);
                for(NSString* suspicious in [DetectionSignatures suspiciousDylibNames]) {
                    if([nsName rangeOfString:suspicious options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        basic_info->protection &= ~VM_PROT_EXECUTE;
                        break;
                    }
                }
            }
        }
    }
    return result;
}

static kern_return_t hooked_vm_region_64(vm_map_t target_task, vm_address_t* address, vm_size_t* size, vm_region_flavor_t flavor, vm_region_info_t info, mach_msg_type_number_t* infoCnt, mach_port_t* object_name) {
    kern_return_t result = orig_vm_region_64(target_task, address, size, flavor, info, infoCnt, object_name);
    if(result == KERN_SUCCESS && !isCallerTweak() && info && flavor == VM_REGION_BASIC_INFO_64) {
        vm_region_basic_info_64_t basic_info = (vm_region_basic_info_64_t)info;
        if(basic_info->protection & VM_PROT_EXECUTE) {
            const char* name = dyld_image_path_containing_address((void*)*address);
            if(name) {
                NSString* nsName = @(name);
                for(NSString* suspicious in [DetectionSignatures suspiciousDylibNames]) {
                    if([nsName rangeOfString:suspicious options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        basic_info->protection &= ~VM_PROT_EXECUTE;
                        break;
                    }
                }
            }
        }
    }
    return result;
}

static kern_return_t hooked_vm_region_recurse(vm_map_t target_task, vm_address_t* address, vm_size_t* size, uint32_t* nesting_depth, vm_region_recurse_info_t info, mach_msg_type_number_t* infoCnt) {
    return orig_vm_region_recurse(target_task, address, size, nesting_depth, info, infoCnt);
}

static kern_return_t hooked_vm_region_recurse_64(vm_map_t target_task, vm_address_t* address, vm_size_t* size, uint32_t* nesting_depth, vm_region_recurse_info_t info, mach_msg_type_number_t* infoCnt) {
    return orig_vm_region_recurse_64(target_task, address, size, nesting_depth, info, infoCnt);
}

void andromeda_hook_VnodeBypass(void) {
    MSHookFunction((void*)vm_region, (void*)hooked_vm_region, (void**)&orig_vm_region);
    MSHookFunction((void*)vm_region_64, (void*)hooked_vm_region_64, (void**)&orig_vm_region_64);
    MSHookFunction((void*)vm_region_recurse, (void*)hooked_vm_region_recurse, (void**)&orig_vm_region_recurse);
    MSHookFunction((void*)vm_region_recurse_64, (void*)hooked_vm_region_recurse_64, (void**)&orig_vm_region_recurse_64);
}
