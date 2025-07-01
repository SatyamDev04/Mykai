//
//  HomeDataModel.swift
//  Myka
//
//  Created by YATIN  KALRA on 21/01/25.
//

import Foundation

// MARK: - TopLevel
struct HomeDataModel: Codable {
        let success: Bool?
        let code: Int?
        let message: String?
        let data: DataClass?
    }

    // MARK: - DataClass
    struct DataClass: Codable {
        let userData: [UserDatum]?
        let fridge, frezzer: Frezzer?
        let date: String?
        let graphValue: Int?
        let monthly_savings: String?
        enum CodingKeys: String, CodingKey {
            case userData, fridge, frezzer, date, monthly_savings
            case graphValue = "graph_value"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.userData = try container.decodeIfPresent([UserDatum].self, forKey: .userData)
            self.fridge = try container.decodeIfPresent(Frezzer.self, forKey: .fridge)
            self.frezzer = try container.decodeIfPresent(Frezzer.self, forKey: .frezzer)
            self.date = try container.decodeIfPresent(String.self, forKey: .date)
            self.graphValue = try container.decodeIfPresent(Int.self, forKey: .graphValue)
            self.monthly_savings = try container.decodeIfPresent(String.self, forKey: .monthly_savings)
        }
    }

    // MARK: - Frezzer
    struct Frezzer: Codable {
        let lunch, breakfast, dinner, teatime: Int?
        let snacks: Int?

        enum CodingKeys: String, CodingKey {
            case lunch = "Lunch"
            case breakfast = "Breakfast"
            case dinner = "Dinner"
            case teatime = "Brunch"
            case snacks = "Snacks"
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.lunch = try container.decodeIfPresent(Int.self, forKey: .lunch)
            self.breakfast = try container.decodeIfPresent(Int.self, forKey: .breakfast)
            self.dinner = try container.decodeIfPresent(Int.self, forKey: .dinner)
            self.teatime = try container.decodeIfPresent(Int.self, forKey: .teatime)
            self.snacks = try container.decodeIfPresent(Int.self, forKey: .snacks)
        }
    }

    // MARK: - UserDatum
    struct UserDatum: Codable {
        let id, userID: Int?
        let day, date: String?
        let uri: String?
        let type: String?
        let planType, servings, status: Int?
        let createdAt, updatedAt: String?
        let deletedAt: String?
        let isLike: Int?
        let isMissing: Int?
        let recipe: RecipeHome?

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case day, date, uri, type
            case planType = "plan_type"
            case servings, status
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
            case isLike = "is_like"
            case isMissing = "is_missing"
            case recipe
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decodeIfPresent(Int.self, forKey: .id)
            self.userID = try container.decodeIfPresent(Int.self, forKey: .userID)
            self.day = try container.decodeIfPresent(String.self, forKey: .day)
            self.date = try container.decodeIfPresent(String.self, forKey: .date)
            self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
            self.type = try container.decodeIfPresent(String.self, forKey: .type)
            self.planType = try container.decodeIfPresent(Int.self, forKey: .planType)
            self.servings = try container.decodeIfPresent(Int.self, forKey: .servings)
            self.status = try container.decodeIfPresent(Int.self, forKey: .status)
            self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
            self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
            self.deletedAt = try container.decodeIfPresent(String.self, forKey: .deletedAt)
            self.isLike = try container.decodeIfPresent(Int.self, forKey: .isLike)
            self.isMissing = try container.decodeIfPresent(Int.self, forKey: .isMissing)
            self.recipe = try container.decodeIfPresent(RecipeHome.self, forKey: .recipe)
        }
    }

    // MARK: - Recipe
    struct RecipeHome: Codable {
        let uri: String?
        let label: String?
        let image: String?
        let images: Images?
        let source: String?
        let url: String?
        let shareAs: String?
        let yield: Int?
        let dietLabels, healthLabels, cautions, ingredientLines: [String]?
        let ingredients: [IngredientHome]?
        let calories, totalWeight: Double?
        let totalTime: Int?
        let cuisineType: [String]?
        let mealType: [String]?
        let dishType: [String]?
        let totalNutrients, totalDaily: [String: Total]?
        let digest: [Digest]?
        let instructionLines: [String]?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.uri = try container.decodeIfPresent(String.self, forKey: .uri)
            self.label = try container.decodeIfPresent(String.self, forKey: .label)
            self.image = try container.decodeIfPresent(String.self, forKey: .image)
            self.images = try container.decodeIfPresent(Images.self, forKey: .images)
            self.source = try container.decodeIfPresent(String.self, forKey: .source)
            self.url = try container.decodeIfPresent(String.self, forKey: .url)
            self.shareAs = try container.decodeIfPresent(String.self, forKey: .shareAs)
            self.yield = try container.decodeIfPresent(Int.self, forKey: .yield)
            self.dietLabels = try container.decodeIfPresent([String].self, forKey: .dietLabels)
            self.healthLabels = try container.decodeIfPresent([String].self, forKey: .healthLabels)
            self.cautions = try container.decodeIfPresent([String].self, forKey: .cautions)
            self.ingredientLines = try container.decodeIfPresent([String].self, forKey: .ingredientLines)
            self.ingredients = try container.decodeIfPresent([IngredientHome].self, forKey: .ingredients)
            self.calories = try container.decodeIfPresent(Double.self, forKey: .calories)
            self.totalWeight = try container.decodeIfPresent(Double.self, forKey: .totalWeight)
            self.totalTime = try container.decodeIfPresent(Int.self, forKey: .totalTime)
            self.cuisineType = try container.decodeIfPresent([String].self, forKey: .cuisineType)
            self.mealType = try container.decodeIfPresent([String].self, forKey: .mealType)
            self.dishType = try container.decodeIfPresent([String].self, forKey: .dishType)
            self.totalNutrients = try container.decodeIfPresent([String : Total].self, forKey: .totalNutrients)
            self.totalDaily = try container.decodeIfPresent([String : Total].self, forKey: .totalDaily)
            self.digest = try container.decodeIfPresent([Digest].self, forKey: .digest)
            self.instructionLines = try container.decodeIfPresent([String].self, forKey: .instructionLines)
        }
    }

//    // MARK: - Digest
//    struct DigestHome: Codable {
//        let label, tag: String?
//        let schemaOrgTag: String?
//        let total: Double?
//        let hasRDI: Bool?
//        let daily: Double?
//        let unit: String?
//        let sub: [DigestHome]?
//    }

  

    // MARK: - Images
    struct ImagesHome: Codable {
        let thumbnail, small, regular, large: Large?

        enum CodingKeys: String, CodingKey {
            case thumbnail = "THUMBNAIL"
            case small = "SMALL"
            case regular = "REGULAR"
            case large = "LARGE"
        }
        
        init(thumbnail: Large?, small: Large?, regular: Large?, large: Large?) {
            self.thumbnail = thumbnail
            self.small = small
            self.regular = regular
            self.large = large
        }
    }

    // MARK: - Large
    struct LargeHome: Codable {
        let url: String?
        let width, height: Int?
    }

    // MARK: - Ingredient
    struct IngredientHome: Codable {
        let text: String?
        let quantity: Double?
        let measure: String?
        let food: String?
        let weight: Double?
        let foodCategory: String?
        let foodID: String?
        let image: String?

        enum CodingKeys: String, CodingKey {
            case text, quantity, measure, food, weight, foodCategory
            case foodID = "foodId"
            case image
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.text = try container.decodeIfPresent(String.self, forKey: .text)
            self.quantity = try container.decodeIfPresent(Double.self, forKey: .quantity)
            self.measure = try container.decodeIfPresent(String.self, forKey: .measure)
            self.food = try container.decodeIfPresent(String.self, forKey: .food)
            self.weight = try container.decodeIfPresent(Double.self, forKey: .weight)
            self.foodCategory = try container.decodeIfPresent(String.self, forKey: .foodCategory)
            self.foodID = try container.decodeIfPresent(String.self, forKey: .foodID)
            self.image = try container.decodeIfPresent(String.self, forKey: .image)
        }
    }

  
 

    // MARK: - Total
    struct TotalHome: Codable {
        let label: String?
        let quantity: Double?
        let unit: String?
    }
