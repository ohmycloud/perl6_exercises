
use Games::Lacuna::Model::Captcha::CaptchaRole;
use Games::Lacuna::Model::NotLoggedInModel;

class Games::Lacuna::Model::NewUserCaptcha does Games::Lacuna::Model::Captcha::CaptchaRole does Games::Lacuna::Model::NotLoggedInModel {
    submethod BUILD () {
        ### The empire endpoint allows for fetching a captcha without a 
        ### session_id.  The user's solution to this captcha is passed along 
        ### to empire::create() when creating a new empire.
        ###
        ### I honestly don't care too much about making this p6 client 
        ### "complete", so ensuring that it can create a new empire is awfully 
        ### low on my priority list, so this class will probably never be 
        ### completed.
    }
}

