//
//  ProductModel.swift
//  SimmaTest
//
//  Created by Enas Abdallah on 09/02/2024.
//

import Foundation

// MARK: - ProductResponse
struct ProductResponse: Codable ,CodableInit{
    let code, msg: String?
    let info: ProductResponseInfo?
}

// MARK: - ProductResponseInfo
struct ProductResponseInfo: Codable {

    let multiLevelSaleAttribute: MultiLevelSaleAttribute?
    let mallInfoList: [MallInfoList]?

    enum CodingKeys: String, CodingKey {
      
        case  multiLevelSaleAttribute ,mallInfoList
        
    }
}

// MARK: - MallInfoList
struct MallInfoList: Codable {
    let stock: String?
    let retailPrice, salePrice: Price?
    let mallDescription: [String]?
    let mallCode, mallName, mallSort, unitDiscount: String?

    enum CodingKeys: String, CodingKey {
        case stock, retailPrice, salePrice, mallDescription
        case mallCode = "mall_code"
        case mallName = "mall_name"
        case mallSort = "mall_sort"
        case unitDiscount = "unit_discount"
    }
}


enum AmountWithSymbol: String, Codable {
    case the1099 = "$10.99"
    case the434 = "$4.34"
    case the665 = "$6.65"
}

// MARK: - MultiLevelSaleAttribute
struct MultiLevelSaleAttribute: Codable {
    let skcName, goodsSn, goodsID: String?
    let skuList: [SkuList]?

    enum CodingKeys: String, CodingKey {
        case skcName = "skc_name"
        case goodsSn = "goods_sn"
        case goodsID = "goods_id"
        case skuList = "sku_list"
    }
}


// MARK: - SkuList
struct SkuList: Codable {
    let skuSelectedMallCode, isSupportQuickShip, skuCode, stock: String?
    let mallStock: [MallStock]?
    let price: PriceElement?
    let mallPrice: [PriceElement]?
    let skuSaleAttr: [SkuSaleAttr]?
    let rewardPoints, doublePoints: Int?
    let subscribeStatus, gradeStatus: Int?
    let isDefault: String?

    enum CodingKeys: String, CodingKey {
        case skuSelectedMallCode, isSupportQuickShip
        case skuCode = "sku_code"
        case stock
        case mallStock = "mall_stock"
        case price
        case mallPrice = "mall_price"
        case skuSaleAttr = "sku_sale_attr"
        case rewardPoints, doublePoints
        case subscribeStatus = "subscribe_status"
        case gradeStatus = "grade_status"
        case isDefault = "is_default"
    }
}


// MARK: - PriceElement
struct PriceElement: Codable {
    let mallCode: String?
    let retailPrice: Price?
    let unitDiscount: Int?
    let salePrice, discountPrice: Price?
    let rewardPoints: Int?

    enum CodingKeys: String, CodingKey {
        case mallCode = "mall_code"
        case retailPrice
        case unitDiscount = "unit_discount"
        case salePrice, discountPrice, rewardPoints
       
    }
}


// MARK: - Price
struct Price: Codable {
    let amount: String?
    let amountWithSymbol: String?
    let usdAmount: String?
    let usdAmountWithSymbol: String?
    let priceShowStyle: String?
}


// MARK: - SkuSaleAttr
struct SkuSaleAttr: Codable {
    let attrID, attrName, attrNameEn, attrValueID: String?
    let attrValueName, attrValueNameEn: String?

    enum CodingKeys: String, CodingKey {
        case attrID = "attr_id"
        case attrName = "attr_name"
        case attrNameEn = "attr_name_en"
        case attrValueID = "attr_value_id"
        case attrValueName = "attr_value_name"
        case attrValueNameEn = "attr_value_name_en"
    }
}


// MARK: - MallStock
struct MallStock: Codable {
    let mallCode, mallCodeSort, stock: String?
    let isSupportQuickShip: Bool?

    enum CodingKeys: String, CodingKey {
        case mallCode = "mall_code"
        case mallCodeSort = "mall_code_sort"
        case stock, isSupportQuickShip
    }
}

