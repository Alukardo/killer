//
//  test.m
//  Killer
//
//  Created by  qztcm09 on 16/6/11.
//  Copyright © 2016年  qztcm09. All rights reserved.
//

#import "IPUnity.h"
#import "Networking/IPAdress.h"
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
@implementation IPUnity

-(NSString*)IPFromData:(NSData*)data
{
    struct sockaddr_in *addr = (struct sockaddr_in*)[data bytes];
    if (addr->sin_family == AF_INET) {
        NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(addr->sin_addr)];
        return ip;
    }
    return @"no ip address";
}
-(NSString *)deviceIPAdress {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
//    NSLog(@"%s", ip_names[0]);
//    NSLog(@"%s", ip_names[1]);
//    NSLog(@"%s", ip_names[2]);
//    NSLog(@"%s", ip_names[3]);
    int i = -1 ;
    while (ip_names[i+1] != NULL) {
        
       
        i++;
        //NSLog(@"%s", ip_names[i]);
        
    }
    
    return [NSString stringWithFormat:@"%s", ip_names[i]];
}
-(NSString *)localIPAddress{
//        NSString *localIP = nil;
//        struct ifaddrs *addrs;
//        if (getifaddrs(&addrs)==0) {
//            const struct ifaddrs *cursor = addrs;
//            while (cursor != NULL) {
//                if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
//                {
//                    //NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
//                    //if ([name isEqualToString:@"en0"]) // Wi-Fi adapter
//                    {
//                        localIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
//                        break;
//                    }
//                }
//                cursor = cursor->ifa_next;
//            }
//            freeifaddrs(addrs);
//        }
//        return localIP;
    struct hostent *host = gethostbyname([[self hostname] UTF8String]);
    if (!host) {herror("resolv"); return nil;}
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}

- (NSString *) hostname
{
    char baseHostName[256]; // Thanks, Gunnar Larisch
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '\0';
    
#if TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s", baseHostName];
#else
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}
@end
