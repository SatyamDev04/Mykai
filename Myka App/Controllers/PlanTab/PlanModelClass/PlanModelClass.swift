//
//  PlanModelClass.swift
//  Myka App
//
//  Created by YES IT Labs on 07/01/25.
//

import Foundation

struct PlanModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: PlanDataClass?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case success = "success"
        case code = "code"
        case message = "message"
    }
}

// MARK: - DataClass
struct PlanDataClass: Codable {
    var recipes: Recipes?
    var url: String?
}

// MARK: - Recipes
struct Recipes: Codable {
    var breakfast, Teatime, Snack: [Breakfast]?
    var dinner, lunch: [Dinner]?

    enum CodingKeys: String, CodingKey {
        case breakfast = "Breakfast"
        case dinner = "Dinner"
        case lunch = "Lunch"
        case Teatime = "Brunch"
        case Snack = "Snacks"
    }
}

// MARK: - Breakfast
struct Breakfast: Codable {
    var recipe: BreakfastRecipe?
    var links: Links?
    var isLike: Int?
    var review_number : Int?
    var review : Double?

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
        case isLike = "is_like"
        case review_number
        case review
    }
}

// MARK: - Links
//struct Links: Codable {
//    var linksSelf: SelfClass?
//
//    enum CodingKeys: String, CodingKey {
//        case linksSelf = "self"
//    }
//}

// MARK: - SelfClass
//struct SelfClass: Codable {
//    var href: String?
//    var title: String?
//}

 

//enum Title: String, Codable {
//    case titleSelf = "Self"
//}

// MARK: - BreakfastRecipe
struct BreakfastRecipe: Codable {
    var uri: String?
    var label: String?
    var image: String?
    var images: Images?
    var source: String?
    var url: String?
    var shareAs: String?
   // var yield: Int?
    var dietLabels: [String]?
    var healthLabels: [String]?
    var cautions: [String]?
    var ingredientLines: [String]?
    var ingredients: [Ingredient]?
    var calories, glycemicIndex: Double?
    var co2EmissionsClass: String?
    var totalWeight: Double?
    var totalTime: Int?
    var cuisineType, mealType, dishType: [String]?
    var totalNutrients, totalDaily: [String: Total]?
    var digest: [Digest]?
    var tags: [String]?
}

//enum Caution: String, Codable {
//    case fodmap = "FODMAP"
//    case gluten = "Gluten"
//    case shellfish = "Shellfish"
//    case sulfites = "Sulfites"
//    case treeNuts = "Tree-Nuts"
//    case wheat = "Wheat"
//}
//
//enum DietLabel: String, Codable {
//    case balanced = "Balanced"
//    case highFiber = "High-Fiber"
//    case lowCarb = "Low-Carb"
//    case lowFat = "Low-Fat"
//    case lowSodium = "Low-Sodium"
//}

// MARK: - Digest
//struct Digest: Codable {
//    var label: Label?
//    var tag: Tag?
//    var schemaOrgTag: SchemaOrgTag?
//    var total: Double?
//    var hasRDI: Bool?
//    var daily: Double?
//    var unit: Unit?
//    var sub: [Digest]?
//}

//enum Label: String, Codable {
//    case calcium = "Calcium"
//    case carbohydratesNet = "Carbohydrates (net)"
//    case carbs = "Carbs"
//    case carbsNet = "Carbs (net)"
//    case cholesterol = "Cholesterol"
//    case energy = "Energy"
//    case fat = "Fat"
//    case fiber = "Fiber"
//    case folateEquivalentTotal = "Folate equivalent (total)"
//    case folateFood = "Folate (food)"
//    case folicAcid = "Folic acid"
//    case iron = "Iron"
//    case magnesium = "Magnesium"
//    case monounsaturated = "Monounsaturated"
//    case niacinB3 = "Niacin (B3)"
//    case phosphorus = "Phosphorus"
//    case polyunsaturated = "Polyunsaturated"
//    case potassium = "Potassium"
//    case protein = "Protein"
//    case riboflavinB2 = "Riboflavin (B2)"
//    case saturated = "Saturated"
//    case sodium = "Sodium"
//    case sugarAlcohols = "Sugar alcohols"
//    case sugars = "Sugars"
//    case sugarsAdded = "Sugars, added"
//    case thiaminB1 = "Thiamin (B1)"
//    case trans = "Trans"
//    case vitaminA = "Vitamin A"
//    case vitaminB12 = "Vitamin B12"
//    case vitaminB6 = "Vitamin B6"
//    case vitaminC = "Vitamin C"
//    case vitaminD = "Vitamin D"
//    case vitaminE = "Vitamin E"
//    case vitaminK = "Vitamin K"
//    case water = "Water"
//    case zinc = "Zinc"
//}

//enum SchemaOrgTag: String, Codable {
//    case carbohydrateContent = "carbohydrateContent"
//    case cholesterolContent = "cholesterolContent"
//    case fatContent = "fatContent"
//    case fiberContent = "fiberContent"
//    case proteinContent = "proteinContent"
//    case saturatedFatContent = "saturatedFatContent"
//    case sodiumContent = "sodiumContent"
//    case sugarContent = "sugarContent"
//    case transFatContent = "transFatContent"
//}

//enum Tag: String, Codable {
//    case ca = "CA"
//    case chocdf = "CHOCDF"
//    case chocdfNet = "CHOCDF.net"
//    case chole = "CHOLE"
//    case fams = "FAMS"
//    case fapu = "FAPU"
//    case fasat = "FASAT"
//    case fat = "FAT"
//    case fatrn = "FATRN"
//    case fe = "FE"
//    case fibtg = "FIBTG"
//    case folac = "FOLAC"
//    case foldfe = "FOLDFE"
//    case folfd = "FOLFD"
//    case k = "K"
//    case mg = "MG"
//    case na = "NA"
//    case nia = "NIA"
//    case p = "P"
//    case procnt = "PROCNT"
//    case ribf = "RIBF"
//    case sugar = "SUGAR"
//    case sugarAdded = "SUGAR.added"
//    case sugarAlcohol = "Sugar.alcohol"
//    case thia = "THIA"
//    case tocpha = "TOCPHA"
//    case vitaRae = "VITA_RAE"
//    case vitb12 = "VITB12"
//    case vitb6A = "VITB6A"
//    case vitc = "VITC"
//    case vitd = "VITD"
//    case vitk1 = "VITK1"
//    case water = "WATER"
//    case zn = "ZN"
//}

//enum Unit: String, Codable {
//    case empty = "%"
//    case g = "g"
//    case kcal = "kcal"
//    case mg = "mg"
//    case µg = "µg"
//}

// MARK: - Images
//struct Images: Codable {
//    var thumbnail, small, regular, large: Large?
//
//    enum CodingKeys: String, CodingKey {
//        case thumbnail = "THUMBNAIL"
//        case small = "SMALL"
//        case regular = "REGULAR"
//        case large = "LARGE"
//    }
//}
//
//// MARK: - Large
//struct Large: Codable {
//    var url: String?
//    var width, height: Int?
//}

// MARK: - Ingredient
//struct Ingredient: Codable {
//    var text: String?
//    var quantity: Double?
//    var measure: Measure?
//    var food: String?
//    var weight: Double?
//    var foodCategory, foodID: String?
//    var image: String?
//
//    enum CodingKeys: String, CodingKey {
//        case text, quantity, measure, food, weight, foodCategory
//        case foodID = "foodId"
//        case image
//    }
//}

//enum Measure: String, Codable {
//    case can = "can"
//    case clove = "clove"
//    case cup = "cup"
//    case dash = "dash"
//    case grapefruit = "grapefruit"
//    case milliliter = "milliliter"
//    case ounce = "ounce"
//    case package = "package"
//    case pinch = "pinch"
//    case pound = "pound"
//    case quart = "quart"
//    case second = "second"
//    case serving = "serving"
//    case slice = "slice"
//    case stalk = "stalk"
//    case tablespoon = "tablespoon"
//    case teaspoon = "teaspoon"
//    case unit = "<unit>"
//    case wedge = "wedge"
//}

// MARK: - Total
//struct Total: Codable {
//    var label: Label?
//    var quantity: Double?
//    var unit: Unit?
//}

// MARK: - Dinner
struct Dinner: Codable {
    var recipe: DinnerRecipe?
    var links: Links?
    var isLike: Int?
    var review_number : Int?
    var review : Double?


    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
        case isLike = "is_like"
        case review_number
        case review
    }
}

// MARK: - DinnerRecipe
struct DinnerRecipe: Codable {
    var uri: String?
    var label: String?
    var image: String?
    var images: Images?
    var source: String?
    var url: String?
    var shareAs: String?
    var yield: Double?
    var dietLabels: [String]?
    var healthLabels: [String]?
    var cautions: [String]?
    var ingredientLines: [String]?
    var ingredients: [Ingredient]?
    var calories, glycemicIndex: Double?
    var co2EmissionsClass: String?
    var totalWeight: Double?
    var totalTime: Int?
    var cuisineType: [String]?
    var mealType: [String]?
    var dishType: [String]?
    var totalNutrients, totalDaily: [String: Total]?
    var digest: [Digest]?
}

//enum CuisineType: String, Codable {
//    case american = "american"
//    case british = "british"
//    case french = "french"
//    case korean = "korean"
//    case southEastAsian = "south east asian"
//    case world = "world"
//}
//
//enum DishType: String, Codable {
//    case alcoholCocktail = "alcohol cocktail"
//    case drinks = "drinks"
//    case mainCourse = "main course"
//    case sandwiches = "sandwiches"
//    case soup = "soup"
//}
//
//enum MealType: String, Codable {
//    case lunchDinner = "lunch/dinner"
//}

