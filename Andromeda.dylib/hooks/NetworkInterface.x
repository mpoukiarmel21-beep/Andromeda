#import "hooks.h"

#ifndef IFT_ETHER_VLAN
#define IFT_ETHER_VLAN 0xec
#endif

static int (*orig_getifaddrs)(struct ifaddrs**) = NULL;

static int hooked_getifaddrs(struct ifaddrs** ifap) {
    int result = orig_getifaddrs(ifap);
    if(result == 0 && ifap && *ifap) {
        for(struct ifaddrs* ifa = *ifap; ifa != NULL; ifa = ifa->ifa_next) {
            if(ifa->ifa_addr && ifa->ifa_addr->sa_family == AF_LINK) {
                struct sockaddr_dl* sdl = (struct sockaddr_dl*)ifa->ifa_addr;
                if(sdl->sdl_type == IFT_ETHER || sdl->sdl_type == IFT_ETHER_VLAN) {
                    if(sdl->sdl_alen == 6) {
                        uint8_t* mac = (uint8_t*)LLADDR(sdl);
                        NSString* spoofedMAC = [_spoofer spoofedWiFiMAC];
                        NSArray* parts = [spoofedMAC componentsSeparatedByString:@":"];
                        if(parts.count == 6) {
                            for(int i = 0; i < 6; i++) {
                                mac[i] = (uint8_t)strtol([parts[i] UTF8String], NULL, 16);
                            }
                        }
                    }
                }
            }
        }
    }
    return result;
}

void andromeda_hook_NetworkInterface(void) {
    MSHookFunction((void*)getifaddrs, (void*)hooked_getifaddrs, (void**)&orig_getifaddrs);
}
