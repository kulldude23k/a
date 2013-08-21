

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "WebServiceCall.h"
#import "SettingsViewController.h"


@interface QuizSectionViewController : UIViewController<WebServiceCallDelegate>
{
    IBOutlet UIView *portraitView;
    IBOutlet UIView *landscapView;
    WebServiceCall *web;
    
}
-(IBAction)epworthQuiz:(id)sender;
-(IBAction)berlinQuiz:(id)sender;
-(IBAction)stopBangQuiz:(id)sender;
@property(nonatomic,strong)UIViewController *Viewcontroller;
@property(nonatomic,strong)MBProgressHUD *hud;
@end
