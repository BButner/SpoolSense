//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation

class FilamentApi: Codable, Identifiable {
    var id: UUID
    var name: String
    var diameter: Double = 1.75
    var abrasive: Bool = false
    var brand: String
    var color: ChoosableColor
    var material: Material
    var temperatureMinimum: Double
    var temperatureMaximum: Double
    
    enum CodingKeys: CodingKey {
        case id, name, diameter, abrasive, brand, color, material, temperature_minimum, temperature_maximum
    }
    
    init(id: UUID, name: String, diameter: Double, abrasive: Bool, brand: String, color: ChoosableColor, material: Material, temperatureMinimum: Double, temperatureMaximum: Double) {
        self.id = id
        self.name = name
        self.diameter = diameter
        self.abrasive = abrasive
        self.brand = brand
        self.color = color
        self.material = material
        self.temperatureMinimum = temperatureMinimum
        self.temperatureMaximum = temperatureMaximum
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try UUID(uuidString: container.decode(String.self, forKey: .id))!
        self.name = try container.decode(String.self, forKey: .name)
        self.diameter = try container.decode(Double.self, forKey: .diameter)
        self.abrasive = try container.decode(Bool.self, forKey: .abrasive)
        self.brand = try container.decode(String.self, forKey: .brand)
        self.color = try container.decode(ChoosableColor.self, forKey: .color)
        self.material = try container.decode(Material.self, forKey: .material)
        self.temperatureMinimum = try container.decode(Double.self, forKey: .temperature_minimum)
        self.temperatureMaximum = try container.decode(Double.self, forKey: .temperature_maximum)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(diameter, forKey: .diameter)
        try container.encode(abrasive, forKey: .abrasive)
        try container.encode(brand, forKey: .brand)
        try container.encode(color, forKey: .color)
        try container.encode(material, forKey: .material)
        try container.encode(temperatureMinimum, forKey: .temperature_minimum)
        try container.encode(temperatureMaximum, forKey: .temperature_maximum)
    }
}
