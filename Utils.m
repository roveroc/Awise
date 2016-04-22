//
//  Utils.m
//  ArpMac
//
//  Created by Evgeniy Kapralov on 17/09/14.
//  Copyright (c) 2014 Kapralos Software. All rights reserved.
//

#import "Utils.h"

#if (TARGET_IPHONE_SIMULATOR)
#import <net/if_types.h>
#import <net/route.h>
#import <netinet/if_ether.h>
#else
#import "if_types.h"
#import "route.h"
#import "if_ether.h"
#endif

#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <ifaddrs.h>
#import <net/if_dl.h>
#import <net/if.h>
#import <netinet/in.h>

#define ROUNDUP(a) ((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))

@interface Utils()

+ (void)logSockaddrInarp:(struct sockaddr_inarp)sockaddr;

@end

@implementation Utils
@synthesize ip_macArray;

+ (NSString*)ipToMac:(NSString*)ipAddress
{
    NSString* res = nil;
    
    in_addr_t addr = inet_addr([ipAddress UTF8String]);
    
    size_t needed;
    char *buf, *next;
    
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET, NET_RT_FLAGS, RTF_LLINFO};
    
    if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), NULL, &needed, NULL, 0) < 0)
    {
        NSLog(@"error in route-sysctl-estimate");
        return nil;
    }
    
    if ((buf = (char*)malloc(needed)) == NULL)
    {
        NSLog(@"error in malloc");
        return nil;
    }
    
    if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), buf, &needed, NULL, 0) < 0)
    {
        NSLog(@"retrieval of routing table");
        return nil;
    }
    
    for (next = buf; next < buf + needed; next += rtm->rtm_msglen)
    {
        rtm = (struct rt_msghdr *)next;
        sin = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)(sin + 1);
#ifdef DEBUG
        [Utils logSockaddrInarp:*sin];
#endif
        
        if (addr != sin->sin_addr.s_addr || sdl->sdl_alen < 6)
            continue;
        
        u_char *cp = (u_char*)LLADDR(sdl);
        
        res = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
               cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
        
        break;
    }
    
    free(buf);
    
    return res;
}

+ (NSString*)getDefaultGatewayIp
{
    NSString* res = nil;
    
    size_t needed;
    char *buf, *next;
    
    struct rt_msghdr *rtm;
    struct sockaddr * sa;
    struct sockaddr * sa_tab[RTAX_MAX];
    int i = 0;
    
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET, NET_RT_FLAGS, RTF_GATEWAY};
    
    if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), NULL, &needed, NULL, 0) < 0)
    {
        NSLog(@"error in route-sysctl-estimate");
        return nil;
    }
    
    if ((buf = (char*)malloc(needed)) == NULL)
    {
        NSLog(@"error in malloc");
        return nil;
    }
    
    if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), buf, &needed, NULL, 0) < 0)
    {
        NSLog(@"retrieval of routing table");
        return nil;
    }
    
    for (next = buf; next < buf + needed; next += rtm->rtm_msglen)
    {
        rtm = (struct rt_msghdr *)next;
        sa = (struct sockaddr *)(rtm + 1);
        for(i = 0; i < RTAX_MAX; i++)
        {
            if(rtm->rtm_addrs & (1 << i))
            {
                sa_tab[i] = sa;
                sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
            }
            else
            {
                sa_tab[i] = NULL;
            }
        }
        
        if(((rtm->rtm_addrs & (RTA_DST|RTA_GATEWAY)) == (RTA_DST|RTA_GATEWAY))
           && sa_tab[RTAX_DST]->sa_family == AF_INET
           && sa_tab[RTAX_GATEWAY]->sa_family == AF_INET)
        {
            if(((struct sockaddr_in *)sa_tab[RTAX_DST])->sin_addr.s_addr == 0)
            {
                char ifName[128];
                if_indextoname(rtm->rtm_index,ifName);
                
                if(strcmp("en0",ifName) == 0)
                {
                    struct in_addr temp;
                    temp.s_addr = ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr;
                    res = [NSString stringWithUTF8String:inet_ntoa(temp)];
                }
            }
        }
    }
    
    free(buf);
    
    return res;
}


- (void) arpTable:(NSString *)mac{
    int mib[6] = {CTL_NET,
        PF_ROUTE,//其实就是af_route的define
        0, AF_INET,
        NET_RT_FLAGS, RTF_LLINFO};
    
    
    size_t len;
    sysctl(mib, 6, NULL, &len, NULL, 0);
    char *buf = malloc(len);
    NSAssert(buf != NULL, @"malloc出错");
    sysctl(mib, 6, buf, &len, NULL, 0);
    NSLog(@"arp表长度%zd",len);
    char *cur = buf;
    char *max = buf + len;
    
    if(self.ip_macArray == nil){
        self.ip_macArray = [[NSMutableArray alloc] init];
    }
    if(self.ip_macArray.count > 0){
        [self.ip_macArray removeAllObjects];
    }
    
    while (cur < max) {
        struct rt_msghdr *rtm = (struct rt_msghdr *)cur;
        struct sockaddr_inarp *sin = (struct sockaddr_inarp *)(rtm + 1);
        struct sockaddr_dl *sdl = (struct sockaddr_dl *)(sin + 1);
        unsigned char *cp = LLADDR(sdl);
//        NSString *mAddr = [NSString stringWithFormat:@"ip=>%s mac: %x:%x:%x:%x:%x:%x\n",inet_ntoa(sin->sin_addr),cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
        
        NSString *ip  = [NSString stringWithFormat:@"%s",inet_ntoa(sin->sin_addr)];
        NSString *mac = [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x",cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
        
        if([mac rangeOfString:@"0:0:0"].location == NSNotFound){
            //NSLog(@"MAC地址为 ---> %@",mac);
            [self.ip_macArray addObject:mac];
            [self.ip_macArray addObject:ip];
        }
        
        cur += rtm->rtm_msglen;
    }
    NSLog(@"搜索到设备IP和MAC对应的关系为---> %@",self.ip_macArray);
    if([self.ip_macArray containsObject:mac]){
        int index = (int)[self.ip_macArray indexOfObject:mac];
        NSLog(@"mac--->%@ 对应的IP地址为----> %@",mac,[self.ip_macArray objectAtIndex:index+1]);
    }
    else{
        NSLog(@"没有找到该MAC地址对应的IP");
    }
    free(buf);
}

#pragma mark - Internal

+ (void)logSockaddrInarp:(struct sockaddr_inarp)sockaddr
{
//    printf("sockaddr_inarp:\n");
//    printf("    sin_addr = %s\n", inet_ntoa(sockaddr.sin_addr));
//    printf("    sin_family = %uc\n", sockaddr.sin_family);
//    printf("    sin_len = %uc\n", sockaddr.sin_len);
//    printf("    sin_other = %us\n", sockaddr.sin_other);
//    printf("    sin_port = %us\n", sockaddr.sin_port);
//    printf("    sin_srcaddr = %s\n", inet_ntoa(sockaddr.sin_srcaddr));
//    printf("    sin_tos = %us\n", sockaddr.sin_tos);
}

@end
