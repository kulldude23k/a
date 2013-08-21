

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
#import "ImageSlideshowViewController.h"
#import "GalleryRequest.h"
#import "WebServiceCall.h"
#import "NSString+HTML.h"
#import "SharingViewController.h"
#import "MBProgressHUD.h"
#import "GSSampleActivity.h"
#import "AppDelegate.h"


@interface TechReport : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,ImageSlideshowRequest,WebServiceCallDelegate>
{
    AppDelegate *appDelegate;
    GalleryRequest *_request_gallery;
    WebServiceCall *web;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UISegmentedControl *segmentedControl2;
    
    SharingViewController *_networkPicker;
    UIPopoverController *_networkPickerPopover;
    
    UIButton *aButton;
    UIBarButtonItem *shareButton1;
    IBOutlet UILabel *headingLableLand;
    IBOutlet UILabel *headingLablePort;
    IBOutlet UILabel *sub_headingLableLand;
    IBOutlet UILabel *sub_headingLablePort;
    UIBarButtonItem *next;
    UIBarButtonItem *previous;
    int index_for_data;
    NSInteger index_segment;
    
}

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *topStories;
@property (nonatomic, strong) IBOutlet UIWebView *myWebView;
@property (nonatomic, strong) IBOutlet UIView *landscape;
@property (nonatomic, strong) IBOutlet UIView *portrait;
@property(nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic, strong) ImageSlideshowViewController *imageSlideView;
@property(nonatomic,strong)UIViewController *Viewcontroller;
@property (nonatomic, retain) SharingViewController *networkPicker;
@property (nonatomic, retain) UIPopoverController *networkPickerPopover;
@property (nonatomic, strong) UIPopoverController *activityPopoverController;


- (IBAction)SettingButtonActionInTopStoryScrren:(id)sender;

@end
