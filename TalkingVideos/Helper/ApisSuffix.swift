//
//  ApisSuffix.swift

////  Bluelight
////
////  Created by Nisha Gupta on 19/01/24.
////
//

import Foundation

enum APISuffix {
    
    case signup
    case login
    case dashboard
    case personlize
    case songsList(Int)
    case musictabSongsList
    case forgotpassword
    case getProfile(String)
    case editProfile
    case changePassword
    case facebookLogin
    case appleLogin
    case addDevice
    case removeDevice
    case searchTopics
    case logout
    case natureEffectsAPI(String)
    case binauralEffectSongsList
    case exploreSongsList
    case searchCategoryList
    case searchSongsList(String)
    case mostPopularSongs
    case updateTodayspecialVideoCount
    case songAddToFavourite
    case removeUserFavourite
    case privacyPolicy
    case contactUsAPI
    case loginBackgroundVideo
    case userNotificationsList
    case addAlarmNotification
    case addDurationNotification
    case favouriteSongList(String)
    case checkSubscription
    case accountDelete
    case cancelSubscription
    case validateSubscription
    case downloadedSongs

    func getDescription() -> String {
       
        switch self {
            
        case .signup :
            return "signup"
            
        case .login :
            return "login"
            
        case .dashboard:
            return "dashboard"
        
        case .personlize:
            return "personlize"
        
        case .songsList(let songListID):
            return "songsList?id=\(songListID)"
        
        case .musictabSongsList:
            return "songsList"
            
        case .forgotpassword:
            return "forgot-password"
        
        case .getProfile(let id):
            return "user?id=\(id)"
        
        case .editProfile:
            return "userUpdate"
            
        case .changePassword:
            return "changePassword"
            
        case .facebookLogin:
            return "facebookLogin"
            
        case .appleLogin:
            return "appleLogin"
            
        case .addDevice:
            return "inject-devicetoken"
            
        case .removeDevice:
            return "eject-devicetoken"
            
        case .searchTopics:
            return "fetch-topics"
                  
        case .logout:
            return "logout"
            
        case .natureEffectsAPI(let name):
            return "effectCategoryList?name=\(name)"
            
        case .binauralEffectSongsList:
            return "binauralEffectSongsList"
            
        case .exploreSongsList:
            return "exploreSongsList"
            
        case .searchCategoryList:
            return "searchCategoryList"
            
        case .searchSongsList(let name):
            return "searchSongsList?name=\(name)"
            
        case .mostPopularSongs:
            return "mostPopularSongs"
            
        case .updateTodayspecialVideoCount:
            return "updateTodayspecialVideoCount"
      
        case .songAddToFavourite:
            return "songAddToFavourite"
            
        case .removeUserFavourite:
            return "removeUserFavourite"
            
        case .privacyPolicy:
            return "staticPage?pagerole=privacy_policy"
            
        case .contactUsAPI:
            return "contactUs"
            
        case .loginBackgroundVideo:
            return "getLoginPageVideo"
            
        case .userNotificationsList:
            return "userNotificationList"
            
        case .addAlarmNotification:
            return "addAlarmNotification"
        
        case .addDurationNotification:
            return "addDurationNotification"
            
        case .favouriteSongList(let id):
            return "favouriteSongList?user=\(id)"
            
            
        case .checkSubscription:
            return "checkSubscription"
            
            
        case .accountDelete:
            return "accountDelete"
            
        case .cancelSubscription:
            return "cancelSubscription"
            
            
        case .validateSubscription:
            return "validateSubscription"
            
            
        case .downloadedSongs:
            return "downloadedSongs"
            
        }
    }
}


enum URLS {
    
    case baseUrl
    case profileImage(String)
    case slideImage(String)
    case profileImageMaestro(String)
    
    func getDescription() -> String {
        
        switch self {
       
        case .baseUrl :
           // return "http://163.47.212.61:8000/api/v1/"
            
        return "https://api.souljourney.io/api/v1/"
            
        case .profileImage(let fileName) :
            return "\(fileName)"
        
        case .slideImage(let fileName) :
            return "/\(fileName)"
            
        case .profileImageMaestro(let fileName) :
            return "/\(fileName)"
     
        }
        
    }
}

class UnifonicSmsGateway {
    
    var messageBody: String = ""
    let recipient: String
    let appSid: String = "evxaORfSlxgB7t3_NbAGclushgrQPl"
        
    
    init(otp: String , recipient: String) {
        self.messageBody = "Dear user, " + "\n" + otp + " is your one time password(OTP)." + "\n" + "Please enter the otp to proceed." + "\n" + "Thank you," + "\n" + "Team TAJR."
        self.recipient = recipient
    }
    
    deinit {
        print(#file , "UniFormSmsgateway Destructed")
    }
}
