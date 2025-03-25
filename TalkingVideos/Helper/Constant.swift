//
//  Constant.swift


////  Bluelight
////
////  Created by Nisha Gupta on 19/01/24.
////
//{{base_url}}/api/loggedIn

import UIKit


// Constants.swift

import Foundation

struct API {
    static let baseURL = "https://ugcreels.urtestsite.com/api/"
    
    struct Endpoints {
        static let signUp = "auth/register"
        static let signIn = "auth/login"
        static let forgotPassword = "auth/forgot-password"
        static let resetPassword = "auth/reset-password"
        static let videoList = "captions/list"
        static let logout = "logout"
        static let getProfile = "user"
        static let generateScript = "generate-script"
        static let submitVideo = "captions/submit"
        static let statusCheck = "captions/poll"
      
     
        // Add more endpoints as needed
   
    
    }
    
    struct Keys {
        static let email = "email"
        static let password = "password"
        static let userid = "userID"
        // Add more keys as needed
    }
    
    struct Constants {
        static let alertTitle = "Bluelight"
    }
}















struct Constant {
    static let googleClientID = "533810457836-eophqjkpb74bh50si1bmp19euemblfi3.apps.googleusercontent.com"
    static let poolID = "eu-west-2:1cd5eff9-9b77-4cf2-87f3-64a5c9fa2023"
    static let adminCommission: Double = 0.25
    static let showFormattedAddress: Bool = true
    static let isPrefetchLoadMoreImplemented: Bool = true
    static let isEmptyStateImplemented: Bool = true
    static let loadMoreScrollOffset: CGFloat = -40
    static let loadMoreScrollOffsetForPrefetch: CGFloat = 200
    static let showOrderCard = false
    static let logosURLRelative = UIScreen.main.scale <= 2 ? "2x" : "3x"
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let htRation = Constant.screenHeight / 667.0
    static let wdRation = Constant.screenWidth / 375.0
    static let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let deviceType = "1"  // 1-> iOS
    static let socialTypeFacebook = "1"
    static let socialTypeGoogle = "2"
    static let btnCornerRadius = CGFloat(8.0)
    static let viewCornerRadius = CGFloat(5.0)
    static let acceptableUsernameCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-."
    static let acceptableIBANCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    static let acceptableNameCharacter = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    //https://www.myloqta.com/useragreement/
    static let termsAndConditionUrl = "https://www.myloqta.com/useragreement/"
//    static let termsAndConditionUrl = "http://myloqta.com/terms-condition"
    static let faqUrl = "http://myloqta.com/faq"
    static let privacyPolicyUrl = "https://www.myloqta.com/privacy-policy/"
//    static let aboutUsUrl = "http://myloqta.com/about-us"
    static let aboutUsUrl = "https://www.myloqta.com/about-us/"
    static let IBANCount = 30
    static let itemNameCount = 80
    static let itemDescriptionCount = 1000
    static let maxPhotoCount = 10
    static let borderWidth = CGFloat(1.0)
    static let messageCount = 400
    static var isIPhone5: Bool {
        if Constant.screenHeight < 667.0 {
            return true
        }
        return false
    }
    static var isIPhone6: Bool {
        if Constant.screenHeight <= 667.0 {
            return true
        }
        return false
    }
    
    struct keys {
        static let kTitle = "title"
        static let kValue = "value"
        static let kFirstNameP = "firstNameP"
        static let kFirstNameV = "firstNameV"
        static let kLastNameP = "lastNameP"
        static let kLastNameV = "lastNameV"
        static let kProfileImage = "profileImage"
        static let kProfileImageUrl = "profileImageUrl"
        static let kCoverImage = "coverImage"
        static let kCoverImageUrl = "coverImageUrl"
        static let kImage = "image"
        static let kImageStatus = "imageStatus"
        static let kImageArray = "imageArray"
        static let kTags = "tags"
        static let kCellType = "cellType"
        static let kDataSource = "dataSource"
        static let kImageUrl = "tags"
        static let kSectionIndex = "sectionIndex"
        static let kFullNameP = "fullNameP"
        static let kFullNameV = "fullNameV"
        
        static let kCategoryId = "categoryId"
        static let kSubCategoryId = "subCategoryId"
        static let kColor = "color"
        static let k10Percent = "10Percent"
        static let kReferringUserId = "referringUserId"
        static let kCreatedSource = "createdSource"
        static let kChannel = "~channel"
        static let kIdentityId = "$identity_id"
        static let kReferrelCode = "referrelCode"
        static let kSenderName = "senderName"
    }
    
    struct validation {
        static let kFirstNameMin = 2
        static let kFirstNameMax = 30
        static let kLastNameMin = 2
        static let kLastNameMax = 40
        static let kUserNameMax = 32
        static let kUserNameMin = 5
        static let kPasswordMax = 32
        static let kPasswordMin = 6
        static let kEmailMax = 40
        static let kPhoneLength = 8
        static let kPhoneMinLength = 6
        static let kPhoneMaxLength = 8
        static let kAboutYouLength = 100
        static let kHaveAQuestionLength = 100
    }
    
   
}
extension UIColor {
    class var purpleColor : UIColor {
        return self.init(
            red:140.0/255.0, green:50.0/255.0, blue:244.0/255.0, alpha:1.0
        )
    }
    
    class var lightPurpleColor : UIColor {
        return self.init(
            red:249.0/255.0, green:244.0/255.0, blue:255.0/255.0, alpha:1.0
        )
    }
    
    class var appNotificationColor : UIColor {
        return self.init(
            red:53.0/255.0, green:136.0/255.0, blue:146.0/255.0, alpha:1.0
        )
    }
}

//extension UIDevice {
//    var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
//    var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
//    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
//    enum ScreenType: String {
//        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
//        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
//        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
//        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
//        case iPhones_X_XS = "iPhone X or iPhone XS"
//        case iPhone_XR_11 = "iPhone XR or iPhone 11"
//        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
//        case iPhone_11Pro = "iPhone 11 Pro"
//        case unknown
//    }
//    var screenType: ScreenType {
//        switch UIScreen.main.nativeBounds.height {
//        case 1136:
//            return .iPhones_5_5s_5c_SE
//        case 1334:
//            return .iPhones_6_6s_7_8
//        case 1792:
//            return .iPhone_XR_11
//        case 1920, 2208:
//            return .iPhones_6Plus_6sPlus_7Plus_8Plus
//        case 2426:
//            return .iPhone_11Pro
//        case 2436:
//            return .iPhones_X_XS
//        case 2688:
//            return .iPhone_XSMax_ProMax
//        default:
//            return .unknown
//        }
//    }
//}


struct Knet {
    // Get below values from Merchant Panel, Profile section
    static let MERCHANT_CODE = "22290920"
    static let ACCESS_CODE = "3d856409-e0e8-4252-af59-b5417fd85b99"
    static let MERCHANT_KEY = "jAvkVmK6XN3e8LwGLY1oqL5ZBd0zbwWx"
    static let MERCHANT_IV = "XN3e8LwGLY1oqL5Z"
}

struct  creditCart {
    // Get below values from Merchant Panel, Profile section
    static let MERCHANT_CODE = "22300920"
    static let ACCESS_CODE = "ead2bfa0-e2af-435b-8fd1-2828a493f14f"
    static let MERCHANT_KEY = "jAvkVmK6XN3e8LwGK0moqL5ZBd0zbwWx"
    static let MERCHANT_IV = "XN3e8LwGK0moqL5Z"
}

//var CHECKOUT_URL = "https://sandbox.hesabe.com/checkout"
let CHECKOUT_URL = "https://api.hesabe.com/checkout"
//var PAYMENT_URL = "https://sandbox.hesabe.com/payment?data="
let PAYMENT_URL = "https://api.hesabe.com/payment?data="

// Get below values from Merchant Panel, Profile section
var ACCESS_CODE = "2a3789f5-edd1-416d-a472-4357794d6a8c"
var MERCHANT_KEY = "OGzgrmqyDEnlALQRNvzPv8NJ4BwWM019"
var MERCHANT_IV = "DEnlALQRNvzPv8NJ"
var MERCHANT_CODE = "1351719857300"

// This URL are defined by you to get the response from Payment Gateway
var RESPONSE_URL = "http://success.hesbstaging.com"
var FAILURE_URL = "http://failure.hesbstaging.com"





//var MERCHANT_CODE = "22290920"
//var ACCESS_CODE = "3d856409-e0e8-4252-af59-b5417fd85b99"
//var MERCHANT_KEY = "OGzgrmqyDEnlALQRNvzPv8NJ4BwWM019"
//let MERCHANT_IV = "XN3e8LwGLY1oqL5Z"


//let MERCHANT_CODE = "22300920"
//let ACCESS_CODE = "ead2bfa0-e2af-435b-8fd1-2828a493f14f"
//let MERCHANT_KEY = "jAvkVmK6XN3e8LwGK0moqL5ZBd0zbwWx"
//let MERCHANT_IV = "XN3e8LwGK0moqL5Z"






// Notification

enum ConstantTextsApi: String {
    
    case noInternetConnection = "No Internet Connection"
    case noInternetConnectionTryAgain = "No Internet Connection. Please try again."
    case connecting = "connecting"
    case errorOccurred = "ErrorOccurred"
    case AppName = "Soul"
    case serverNotResponding = "Server is not responding."
    case cancel = "Cancel"
    
    var localizedString:String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
