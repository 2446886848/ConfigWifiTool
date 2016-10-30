/*
#include <execinfo.h>

void print_stack()
{
    
    NSLog(@"before ----------------------");
    int size = 16;
    int i;
    void *array[16];
    int stack_num = backtrace(array, size);
    char **stacktrace = NULL;
    
    stacktrace = (char**)backtrace_symbols(array, stack_num);
    
    for(i = 0; i < stack_num; i++)
    {
        NSLog(@"%s\n", stacktrace[i]);
    }
    free(stacktrace);
    
    NSLog(@"after ----------------------");
}
*/

#import "WifiPwdViewController.h"
#import "WifiManager.h"

%hook NEHotspotNetwork

- (void)setPassword:(NSString *)password
{
    %orig;
    [[WifiManager manager] addWifi:[self valueForKey:@"SSID"] pwd:password];
}

%end

%hook HomeViewController

%new
- (void)watchPwd
{
    UINavigationController *nav = [self valueForKey:@"navigationController"];
    WifiPwdViewController *wifiPwdVc = [[WifiPwdViewController alloc] init];
    [nav pushViewController:wifiPwdVc animated:YES];
}

- (void)viewDidLoad
{
    %orig;
    UIView *tableHeaderView = [self valueForKey:@"headerView"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 10, 80, 30);
    [button setTitle:@"查看密码" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(watchPwd) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:button];
}

%end


//去广告

%hook SplashView

+ (void) showInView:(id)arg1 canSkip:(BOOL)arg2 clickURL:(id)arg3 image:(id)arg4 splashDuration:(long)arg5 clickAction:(id)arg6 closeBlock:(id)arg7
{
}

%end
/*
%hook NEHotspotHelper

+ (BOOL)registerWithOptions:(NSDictionary *)options
queue:(dispatch_queue_t)queue
handler:(id)handler
{
    NSLog(@"walen:registerWithOptions:options = %@", options);
    return %orig;
}

%end

%hook NEHotspotHelperCommand

- (NSArray *)networkList
{
    NSArray *origValue = %orig;
    NSLog(@"walen:networkList:networkList = %@", origValue);
    return origValue;
}

%end

%hook AFJSONResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
data:(NSData *)data
error:(NSError **)error
{
    id r = %orig;
    NSLog(@"walen:AFJSONResponseSerializer:responseObjectForResponse r = %@", r);
    return r;
}

%end

%hook AFXMLDocumentResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
data:(NSData *)data
error:(NSError **)error
{
    id r = %orig;
    NSLog(@"walen:AFXMLDocumentResponseSerializer:responseObjectForResponse r = %@", r);
    return r;
}

%end

*/
//#import <substrate.h>
//#import <mach-o/dyld.h>
//#import <dlfcn.h>
//
//int (*old_sub_f78c4)(void);
//
//int new_sub_f78c4(void)
//{
//    // old_sub_ACF0();
//    NSLog(@"iOSRE: anti-anti-debugging");
//    return 0;
//}
//
//int	my_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data)
//{
//    return 0;
//}
//
//void (**old_dlsym)(void * __handle, const char * __symbol);
//
//void *new_dlsym(void * __handle, const char * __symbol)
//{
//    if ([@"ptrace" isEqualToString:@(__symbol)]) {
//        return (void *)my_ptrace;
//    }
//    return old_dlsym(__handle, __symbol);
//}
//
//%ctor
//{
//    @autoreleasepool
//    {
//        MSHookFunction((void *)dlsym, (void *)new_dlsym, (void **)&old_dlsym);
////        unsigned long _sub_f78c4 = (_dyld_get_image_vmaddr_slide(0) + 0xf78c4) | 0x1;
////        if (_sub_f78c4) NSLog(@"iOSRE: Found sub_f78c4!");
////        MSHookFunction((void *)_sub_f78c4, (void *)&new_sub_f78c4, (void **)&old_sub_f78c4);
//    }
//}


/*
#import <substrate.h>
#import <sys/ptrace.h>

int (*org_ptrace)(int _request, pid_t _pid, caddr_t _addr, int _data);

int	my_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data)
{
    return org_ptrace(0, _pid, _addr, _data);
}

%ctor
{
    @autoreleasepool
    {
        MSHookFunction(((void*)MSFindSymbol(NULL, "ptrace")),(void*)my_ptrace, (void**)&org_ptrace);
//        MSHookFunction(ptrace, my_ptrace, &org_ptrace);
    }
}

*/
