// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "PdfToMdUrlTools",
    products: [
        .library(name: "PdfToMdUrlTools", targets: ["PdfToMdUrlTools"]),
    ],
    targets: [
        .target(name: "PdfToMdUrlTools", path: "swift/Sources/PdfToMdUrlTools"),
        .executableTarget(name: "pdftomd-url-check", dependencies: ["PdfToMdUrlTools"], path: "swift/Check"),
    ]
)
