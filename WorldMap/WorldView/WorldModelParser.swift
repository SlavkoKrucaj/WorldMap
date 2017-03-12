import Foundation
import UIKit

typealias JsonDictionary = [String: Any]

internal class WorldModelParser {
    func parse(json: JsonDictionary) -> [Country] {
        guard let features = json["features"] as? [JsonDictionary] else {
            return []
        }
        return features.flatMap(self.parseCountry)
    }

    private func parseCountry(country: JsonDictionary) -> Country? {
        guard let countryId = country["id"] as? String,
            let properties = country["properties"] as? JsonDictionary,
            let countryName = properties["name"] as? String,
            let geometryDict = country["geometry"] as? JsonDictionary,
            let geoType = geometryDict["type"] as? String else {
                return nil
        }

        if (geoType == "Polygon") {
            return Country(id: countryId, name: countryName, geometry: .polygon(self.parsePolygon(json: geometryDict)))
        } else if (geoType == "MultiPolygon") {
            return Country(id: countryId, name: countryName, geometry: .multiPolygon(self.parseMultiPolygon(json: geometryDict)))
        } else {
            print("Unrecognized type \(geoType)")
            return nil
        }
    }

    private func parsePolygon(json: JsonDictionary) -> [CGPoint] {
        guard let coordinates = json["coordinates"] as? [[[Double]]] else {
            return []
        }
        return self.parsePoints(points: coordinates)
    }

    private func parseMultiPolygon(json: JsonDictionary) -> [[CGPoint]] {
        guard let coordinates = json["coordinates"] as? [[[[Double]]]] else {
            return []
        }

        return coordinates.map(self.parsePoints)
    }

    private func parsePoints(points: [[[Double]]]) -> [CGPoint] {
        return points.flatMap{ $0 }.flatMap({ point in
            guard let x = point.first, let y = point.last else {
                return nil
            }
            return CGPoint(x: x, y: y)
        })
    }
}

internal struct Country {
    let id: String
    let name: String
    let geometry: Geometry
}

internal enum Geometry {
    case polygon([CGPoint])
    case multiPolygon([[CGPoint]])
}

public struct CountryName {
    public static let afghanistan = "AFG"
    public static let angola = "AGO"
    public static let albania = "ALB"
    public static let unitedArabEmirates = "ARE"
    public static let argentina = "ARG"
    public static let armenia = "ARM"
    public static let antarctica = "ATA"
    public static let frenchSouthernAndAntarcticLands = "ATF"
    public static let australia = "AUS"
    public static let austria = "AUT"
    public static let azerbaijan = "AZE"
    public static let burundi = "BDI"
    public static let belgium = "BEL"
    public static let benin = "BEN"
    public static let burkinaFaso = "BFA"
    public static let bangladesh = "BGD"
    public static let bulgaria = "BGR"
    public static let theBahamas = "BHS"
    public static let bosniaAndHerzegovina = "BIH"
    public static let belarus = "BLR"
    public static let belize = "BLZ"
    public static let bermuda = "BMU"
    public static let bolivia = "BOL"
    public static let brazil = "BRA"
    public static let brunei = "BRN"
    public static let bhutan = "BTN"
    public static let botswana = "BWA"
    public static let centralAfricanRepublic = "CAF"
    public static let canada = "CAN"
    public static let switzerland = "CHE"
    public static let chile = "CHL"
    public static let china = "CHN"
    public static let ivoryCoast = "CIV"
    public static let cameroon = "CMR"
    public static let democraticRepublicOfTheCongo = "COD"
    public static let republicOfTheCongo = "COG"
    public static let colombia = "COL"
    public static let costaRica = "CRI"
    public static let cuba = "CUB"
    public static let northernCyprus = "-99"
    public static let cyprus = "CYP"
    public static let czechRepublic = "CZE"
    public static let germany = "DEU"
    public static let djibouti = "DJI"
    public static let denmark = "DNK"
    public static let dominicanRepublic = "DOM"
    public static let algeria = "DZA"
    public static let ecuador = "ECU"
    public static let egypt = "EGY"
    public static let eritrea = "ERI"
    public static let spain = "ESP"
    public static let estonia = "EST"
    public static let ethiopia = "ETH"
    public static let finland = "FIN"
    public static let fiji = "FJI"
    public static let falklandIslands = "FLK"
    public static let france = "FRA"
    public static let gabon = "GAB"
    public static let unitedKingdom = "GBR"
    public static let georgia = "GEO"
    public static let ghana = "GHA"
    public static let guinea = "GIN"
    public static let gambia = "GMB"
    public static let guineaBissau = "GNB"
    public static let equatorialGuinea = "GNQ"
    public static let greece = "GRC"
    public static let greenland = "GRL"
    public static let guatemala = "GTM"
    public static let frenchGuiana = "GUF"
    public static let guyana = "GUY"
    public static let honduras = "HND"
    public static let croatia = "HRV"
    public static let haiti = "HTI"
    public static let hungary = "HUN"
    public static let indonesia = "IDN"
    public static let india = "IND"
    public static let ireland = "IRL"
    public static let iran = "IRN"
    public static let iraq = "IRQ"
    public static let iceland = "ISL"
    public static let israel = "ISR"
    public static let italy = "ITA"
    public static let jamaica = "JAM"
    public static let jordan = "JOR"
    public static let japan = "JPN"
    public static let kazakhstan = "KAZ"
    public static let kenya = "KEN"
    public static let kyrgyzstan = "KGZ"
    public static let cambodia = "KHM"
    public static let southKorea = "KOR"
    public static let kosovo = "CS-KM"
    public static let kuwait = "KWT"
    public static let laos = "LAO"
    public static let lebanon = "LBN"
    public static let liberia = "LBR"
    public static let libya = "LBY"
    public static let sriLanka = "LKA"
    public static let lesotho = "LSO"
    public static let lithuania = "LTU"
    public static let luxembourg = "LUX"
    public static let latvia = "LVA"
    public static let morocco = "MAR"
    public static let moldova = "MDA"
    public static let madagascar = "MDG"
    public static let mexico = "MEX"
    public static let macedonia = "MKD"
    public static let mali = "MLI"
    public static let malta = "MLT"
    public static let myanmar = "MMR"
    public static let montenegro = "MNE"
    public static let mongolia = "MNG"
    public static let mozambique = "MOZ"
    public static let mauritania = "MRT"
    public static let malawi = "MWI"
    public static let malaysia = "MYS"
    public static let namibia = "NAM"
    public static let newCaledonia = "NCL"
    public static let niger = "NER"
    public static let nigeria = "NGA"
    public static let nicaragua = "NIC"
    public static let netherlands = "NLD"
    public static let norway = "NOR"
    public static let nepal = "NPL"
    public static let newZealand = "NZL"
    public static let oman = "OMN"
    public static let pakistan = "PAK"
    public static let panama = "PAN"
    public static let peru = "PER"
    public static let philippines = "PHL"
    public static let papuaNewGuinea = "PNG"
    public static let poland = "POL"
    public static let puertoRico = "PRI"
    public static let northKorea = "PRK"
    public static let portugal = "PRT"
    public static let paraguay = "PRY"
    public static let qatar = "QAT"
    public static let romania = "ROU"
    public static let russia = "RUS"
    public static let rwanda = "RWA"
    public static let westernSahara = "ESH"
    public static let saudiArabia = "SAU"
    public static let sudan = "SDN"
    public static let southSudan = "SSD"
    public static let senegal = "SEN"
    public static let solomonIslands = "SLB"
    public static let sierraLeone = "SLE"
    public static let elSalvador = "SLV"
    public static let somaliland = "-99"
    public static let somalia = "SOM"
    public static let republicOfSerbia = "SRB"
    public static let suriname = "SUR"
    public static let slovakia = "SVK"
    public static let slovenia = "SVN"
    public static let sweden = "SWE"
    public static let swaziland = "SWZ"
    public static let syria = "SYR"
    public static let chad = "TCD"
    public static let togo = "TGO"
    public static let thailand = "THA"
    public static let tajikistan = "TJK"
    public static let turkmenistan = "TKM"
    public static let eastTimor = "TLS"
    public static let trinidadAndTobago = "TTO"
    public static let tunisia = "TUN"
    public static let turkey = "TUR"
    public static let taiwan = "TWN"
    public static let unitedRepublicOfTanzania = "TZA"
    public static let uganda = "UGA"
    public static let ukraine = "UKR"
    public static let uruguay = "URY"
    public static let unitedStatesOfAmerica = "USA"
    public static let uzbekistan = "UZB"
    public static let venezuela = "VEN"
    public static let vietnam = "VNM"
    public static let vanuatu = "VUT"
    public static let westBank = "PSE"
    public static let yemen = "YEM"
    public static let southAfrica = "ZAF"
    public static let zambia = "ZMB"
    public static let zimbabwe = "ZWE"
}


