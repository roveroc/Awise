//
//  RoverARP.m
//  FindDevice
//
//  Created by rover on 16/4/11.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "RoverARP.h"

@implementation RoverARP
@synthesize macDic;


#pragma mark - 获取ARP表单
- (NSMutableDictionary*) arpTable{
    macDic = [[NSMutableDictionary alloc] init];
    [self dump:0];
    return macDic;
}



static int nflag;

void
ether_print(cp)
u_char *cp;
{

    printf("%x:%x:%x:%x:%x:%x", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]);
}


/*
 * Dump the entire arp table
 */
//int
//dump(addr)
//u_long addr;
- (int)dump:(u_long)addr
{
    int mib[6];
    size_t needed;
    char *host, *lim, *buf, *next;
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    extern int h_errno;
    struct hostent *hp;
    int found_entry = 0;
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0)
        err(1, "route-sysctl-estimate");
    if ((buf = malloc(needed)) == NULL)
        err(1, "malloc");
    if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0)
        err(1, "actual retrieval of routing table");
    lim = buf + needed;
    for (next = buf; next < lim; next += rtm->rtm_msglen) {
        rtm = (struct rt_msghdr *)next;
        sin = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)(sin + 1);
        if (addr) {
            if (addr != sin->sin_addr.s_addr)
                continue;
            found_entry = 1;
        }
        if (nflag == 0)
            hp = gethostbyaddr((caddr_t)&(sin->sin_addr),
                               sizeof sin->sin_addr, AF_INET);
        else
            hp = 0;
        if (hp)
            host = hp->h_name;
        else {
            host = "?";
            if (h_errno == TRY_AGAIN)
                nflag = 1;
        }
//        printf("%s (%s) at ", host, inet_ntoa(sin->sin_addr));
        
        
        
        if (sdl->sdl_alen){
//            ether_print((u_char *)LLADDR(sdl));
            
            //by rover
            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(sin->sin_addr)];
            u_char *cp = (u_char *)LLADDR(sdl);
            NSString *mac = [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x",cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
            
//            NSLog(@"ip == %@  mac == %@",ip,mac);
            [macDic setObject:ip forKey:mac];
        
        }
        else{}
//            printf("(incomplete)");
        if (rtm->rtm_rmx.rmx_expire == 0){}
//            printf(" permanent");
        if (sin->sin_other & SIN_PROXY){}
//            printf(" published (proxy only)");
        if (rtm->rtm_addrs & RTA_NETMASK) {
            sin = (struct sockaddr_inarp *)
            (sdl->sdl_len + (char *)sdl);
            if (sin->sin_addr.s_addr == 0xffffffff){}
//                printf(" published");
            if (sin->sin_len != 8){}
//                printf("(weird)");
        }
//        printf("\n");
    }
    return (found_entry);
}



@end
