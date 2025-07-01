

import Foundation

typealias JSONDictionary = [String : Any]
 
enum baseURL {
//    
    static let baseURL = "https://admin.getmykai.com/api/"
 
    static let imageUrl = "https://admin.getmykai.com" //  AWS Live url
    
//   static let baseURL = "https://myka.tgastaging.com/api/" // test url
//
//   static let imageUrl = "https://myka.tgastaging.com" //  test url
 }

enum appEndPoints{
   
    static let bodygoals = "body_goals"
    
    static let favouriteCuisines = "favourite_cuisines"
    
    static let dietaryRestrictions = "dietary_restrictions"
    
    static let dislikeIngredients = "dislike_ingredients"
    
    static let allergensIngredients = "allergens_ingredients"
    
    static let mealRoutine = "meal_routine"
    
    static let cookingFrequency = "cooking_frequency"
    
    static let eatingOut = "eating_out"
     
    static let getLogin = "user-login" // LogUser
    
    static let getsignUp = "user-signup" // SignUp
    
    static let SignUpResendotp = "resenddotp"
  
    static let getSignUpOtpVerify = "otp-verify"
    
    static let forgetPassword = "user-forgot-Password"
    
    static let forget_otp_verify = "forget-otp-verify"
    
    static let resetPassword = "update-password"
    
    static let change_password = "change-password"
    
    static let social_login = "social_login"
    
    static let takeAwayReason = "take_away_reason"
    
    static let TurnOnNotification = "toggle-notification"
    
    static let terms_and_Condation = "terms-and-condation"
    
    static let privacyPolicy = "privacy-policy"
    
    static let saveFeedback = "save-feedback"
    
    static let getUserProfile = "get-user-profile"
    
    static let UpdateProfile = "user-profile-update"
    
    static let profileImgUpdate = "profile-img-update"
    
    static let add_Card = "add-Card"
    
    static let get_card_Bank_details = "user-bank-and-card-list"
    
    static let delete_card = "delete_card"
    
    static let Add_Bank = "add-bank-details"
    
    static let delete_Bank_Account = "delete-Bank-Account"
    
    static let get_countries = "get-countries"
    
    static let Getprefrence = "user-prefrence"
    
    static let Updateprefrence = "update-user-prefrence"
    
    static let get_wallet = "get-wallet"
    
    static let transfer_To_Account = "transfer-To-Account"
    
    static let update_notification = "update-notification"
    
    static let user_Logout = "user-Logout"
    
    static let user_delete = "user-delete"
    
    static let recipe = "recipe" 
    
    static let all_recipe = "all-recipe"
    
    static let add_to_favorite = "add-to-favorite"
    
    static let add_to_basket = "add-to-basket"  
    
    static let get_recipe = "get-recipe"
    
    static let AddMeal = "add-meal"
    
    static let meal_review = "meal-review"
    
    static let get_meals = "get-meals"
    
    static let remove_meal = "remove-meal"
    
    static let ingredient_basket = "ingredient-basket"
    
    static let get_cook_book = "get-cook-book"
    
    static let Add_Cook_Book = "add-cook-book"
    
    static let home_data = "home-data"
    
    static let cook_book_type_list = "cook-book-type-list"
    
    static let move_recipe = "move-recipe"
    
    static let remove_cook_book = "remove-cook-book"
    
    static let recipes = "recipes"
    
    static let create_meal = "create-meal"
    
    static let for_search = "for-search"
    
    static let get_missing_ingredient = "get-missing-ingredient"
    
    static let add_to_cart = "add-to-cart"
    
    static let get_schedule = "get-schedule"
    
    static let for_preference_update = "for-preference-update"
    
    static let get_meal_by_url = "get-meal-by-url"
    
    static let update_meal = "update-meal"
    
    static let for_filter_search = "for-filter-search"
    
    static let subscription_apple = "subscription/apple"
    
    static let super_markets = "super-markets"
    
    static let change_type = "change-type"
    
    static let swap = "swap"
    
    static let add_meal_type = "add-meal-type"
    
    static let generate_link = "generate-link"
    
    static let ingredients = "ingredients"
    
    static let add_to_basket_all = "add-to-basket-all"
    
    static let user_diet_suggetion = "user-diet-suggetion"
    
    static let add_address = "add-address"
    
    static let get_address = "get-address"
    
    static let make_address_primary = "make-address-primary"
    
    static let get_basketlist = "get-basketlist"
    
    static let shopping_list = "shopping-list"
    
    static let select_store_product = "select-store-product"
    
    static let change_cart = "change-cart"
    
    static let remove_basket = "remove-basket"
    
    static let your_recipe = "your-recipe"
    
    static let store_products = "store-products"
   
    static let checkSubscription = "checkSubscription"
    
    static let get_products = "get-products"
    
    static let products = "products"
    
    static let getSubscriptionDeltails = "getSubscriptionDeltails"
    
    static let checkout = "checkout"
    
    static let select_product = "select-product"
    
    static let add_card_mealme = "add-card-mealme"
    
    static let get_card_mealme = "get-card-mealme"
    
    static let delete_card_mealme = "delete-card-mealme"
    
    static let set_preferred_card = "set-preferred-card"
    
    static let get_notes = "get-notes"
    
    static let add_notes = "add-notes"
    
    static let send_sms = "send-sms"
    
    static let add_phone = "add-phone"
    
    static let tip = "tip"
    
    static let charge_apple = "charge-apple"
    
    static let order_product = "order-product"
    
    static let order_history = "order-history"
    
    static let graph = "graph"
    
    static let referral = "referral"
    
    static let graph_week = "graph-week"
    
    static let checkavailablity = "checkavailablity"
    
    static let reedem = "reedem"
    
    static let ingredientRecipeSearch = "ingredient-recipe-search"
    
    static let update_user_prefrence = "update-user-prefrence"
    
    static let get_meals_by_random_date = "get-meals-by-random-date"
    
    static let get_schedule_by_random_date = "get-schedule-by-random-date"
    
    static let remove_meal_cooked = "remove-meal-cooked"
     
    static let schedule_time = "schedule-time"
    
    static let set_schedule = "set-schedule"
}

struct AppLocation {
    static var  lat = ""
    static var  long = ""
    static var  Address = ""
    static var  city = ""
    static var  state = ""
    static var  zip = ""
}

var userType = ""
