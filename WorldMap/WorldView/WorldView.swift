import Foundation
import UIKit

open class WorldView: UIView {
    @IBInspectable public var countryColor: UIColor = UIColor(red: 95/255.0, green: 133/255.0, blue: 167/255.0, alpha: 1.0)
    @IBInspectable public var selectedCountryColor: UIColor = UIColor(red: 239/255.0, green: 236/255.0, blue: 230/255.0, alpha: 1.0)

    private let borderWidth: CGFloat = 0.2
    private let intrinsicSize = CGSize(width: 360, height: 180)
    private let countries: [Country]

    override public init(frame: CGRect) {
        self.countries = WorldView.loadCountries()
        super.init(frame: frame)
        self.setupLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.countries = WorldView.loadCountries()
        super.init(coder: aDecoder)
        self.setupLayer()
    }

    override open class var layerClass: AnyClass {
        return CATiledLayer.self
    }

    open var selectedCountries: [String] = [] {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let scale = self.bounds.width / self.intrinsicSize.width

        let context = UIGraphicsGetCurrentContext()!
        countries.forEach({ country in
            context.saveGState()
            context.setLineWidth(self.borderWidth * scale)
            context.setStrokeColor(UIColor.white.cgColor)

            if (selectedCountries.contains(country.id)) {
                context.setFillColor(self.countryColor.cgColor)
            } else {
                context.setFillColor(self.selectedCountryColor.cgColor)
            }

            context.scaleBy(x: scale, y: -scale)
            context.translateBy(x: self.intrinsicSize.width / 2, y: -self.intrinsicSize.height / 2)

            switch (country.geometry) {
            case .polygon(let points): self.drawPolygon(context: context, points: points, rect: rect)
            case .multiPolygon(let polygons): polygons.forEach { self.drawPolygon(context: context, points: $0, rect: rect) }
            }

            context.drawPath(using: .fillStroke)
            context.restoreGState()
        })
    }

    private func setupLayer() {
        if let layer: CATiledLayer = self.layer as? CATiledLayer {
            layer.tileSize = CGSize(width: 1024, height: 1024)
            layer.levelsOfDetail = 5
            layer.levelsOfDetailBias = 2
        }
    }

    private static func loadCountries() -> [Country] {
        guard let asset = NSDataAsset(name: "world", bundle: Bundle(for: WorldView.self)),
            let json = try? JSONSerialization.jsonObject(with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments),
            let jsonDict = json as? JsonDictionary else {
                return []
        }
        return WorldModelParser().parse(json: jsonDict)
    }

    private func drawPolygon(context: CGContext, points: [CGPoint], rect: CGRect) {
        for (index, point) in points.enumerated() {
            if (index == 0) {
                context.move(to: point)
            } else {
                context.addLine(to: point)
            }
        }
    }
}
