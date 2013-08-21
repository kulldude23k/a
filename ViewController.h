

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"
#import "WebServiceCall.h"
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"
#import "LoginViewController.h"
#import "ScrollView.h"
#import "ImageFlipViewController.h"
#import "TTTAttributedLabel.h"
#import "AppDelegate.h"
#import "NTAnimImageView.h"
#import "EventsViewController.h"
#import "topstoryImage.h"
#import "TechReport.h"
#import "TopStoryImage.h"


//typedef void(^SelectItemCallback)(id sender, id Item);

// FBSample logic
// The main UI for the application, which lets the user select a type of food, tag who they
// are with and where they are.

 

@interface ViewController : UIViewController <FBUserSettingsDelegate,WebServiceCallDelegate,UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UIView *portraitView;
    IBOutlet UIView *landscapView;
    IBOutlet UIView *homeView;
    WebServiceCall *web;
    IBOutlet UIScrollView *top_str_por;
    IBOutlet UIScrollView *top_str_lan;
    IBOutlet UIView *top_str_vie_lan;
    IBOutlet UIScrollView *art_por;
    IBOutlet UIView *art_vie_por;
    IBOutlet UIScrollView *art_lan;
    IBOutlet UIView *art_vie_lan;
    IBOutlet UIScrollView *qui_por;
    IBOutlet UIView *qui_vie_por;
    IBOutlet UIScrollView *qui_lan;
    IBOutlet UIView *qui_vie_lan;
    IBOutlet UIScrollView *vid_por;
    //IBOutlet UIView *vid_vie_por;
    IBOutlet UIScrollView *vid_lan;
    IBOutlet UIView *vid_vie_lan;
        
    IBOutlet UIScrollView *eve_por;
    //IBOutlet UIView *eve_vie_por;
    IBOutlet UIScrollView *eve_lan;
    IBOutlet UIView *eve_vie_lan;
    
    IBOutlet UIScrollView *lin_por;
    IBOutlet UIView *lin_vie_por;
    IBOutlet UIScrollView *lin_lan;
    IBOutlet UIView *lin_vie_lan;
    IBOutlet UIScrollView *rep_por;
    IBOutlet UIView *rep_vie_por;
    IBOutlet UIScrollView *rep_lan;
    IBOutlet UIView *rep_vie_lan;
    
    IBOutlet NTAnimImageView    *event_imageView_port;
    //IBOutlet NTAnimImageView    *event_imageView_land;
    IBOutlet TopStoryImage    *story_imageView_port;
    //IBOutlet NTAnimImageView    *story_imageView_land;
    IBOutlet NTAnimImageView    *video_imageView_port;
    //IBOutlet NTAnimImageView    *video_imageView_land;
    
    NSMutableArray *imageArray;
    NSMutableArray *topstory_imageArray;
    NSMutableArray *video_imageArray;

    
    ImageFlipViewController *image_fli_por_top;
    ImageFlipViewController *image_fli_lan_top;
    ImageFlipViewController *image_fli_por_art;
    ImageFlipViewController *image_fli_lan_art;
    ImageFlipViewController *image_fli_por_qui;
    ImageFlipViewController *image_fli_lan_qui;
    ImageFlipViewController *image_fli_por_vid;
    ImageFlipViewController *image_fli_lan_vid;
    ImageFlipViewController *image_fli_por_eve;
    ImageFlipViewController *image_fli_lan_eve;
    ImageFlipViewController *image_fli_por_lin;
    ImageFlipViewController *image_fli_lan_lin;
    ImageFlipViewController *image_fli_por_rep;
    ImageFlipViewController *image_fli_lan_rep;
    NSTimer *timer_por;
    NSTimer *timer_lan;
    
}


@property(nonatomic,strong)UIViewController *Viewcontroller;
@property(nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic, strong) LoginViewController *oAuthLoginView;


- (void)populateUserDetails;
- (IBAction)TopStoryButtonAction:(id)sender;
- (IBAction)VideoButtonAction:(id)sender;
- (IBAction)TechButtonAction:(id)sender;
- (IBAction)SleepButtonAction:(id)sender;
- (IBAction)LinkedinButtonAction:(id)sender;
- (IBAction)FaceBookButtonAction:(id)sender;
- (IBAction)TwitterButtonAction:(id)sender;
- (IBAction)ArtOfSleepingButtonAction:(id)sender;
- (IBAction)eventButtonTapped:(id)sender;

//flip animation

-(void)createFlipAnnimation;
-(void)createFlipAnnimationSleepQuizes;
-(void)createFlipAnnimationVideos;
-(void)createFlipAnnimationLinkedIn;
-(void)createFlipAnnimationEvents;
-(void)createFlipAnnimationReports;
-(void)createFlipAnnimationTopStory;
-(void)createFlipAnnimationArtOfSleeping;

-(void)moveToLinkedIn;
-(void)stopAnimation;

// item from flip

-(void)TopStory:(id)sender;
//-(IBAction)Quiz:(id)sender;
-(void)Video:(id)sender;
-(void)ArtOfSleeping:(id)sender;
-(void)LinkedIn:(id)sender;
-(void)Event:(id)sender;

//flip - both view

-(void)flipAnimation_por;
-(void)flipAnimation_lan;



//- (void)startLocationManager;

@end
