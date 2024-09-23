/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Ngo Ngoc Thinh
  ID: s3879364
  Created  date: 26/08/2024
  Last modified: 02/09/2024
  Acknowledgement:
     https://rmit.instructure.com/courses/138616/modules/items/6274581
     https://rmit.instructure.com/courses/138616/modules/items/6274582
     https://rmit.instructure.com/courses/138616/modules/items/6274583
     https://rmit.instructure.com/courses/138616/modules/items/6274584
     https://rmit.instructure.com/courses/138616/modules/items/6274585
     https://rmit.instructure.com/courses/138616/modules/items/6274586
     https://rmit.instructure.com/courses/138616/modules/items/6274588
     https://rmit.instructure.com/courses/138616/modules/items/6274589
     https://developer.apple.com/documentation/swift/
     https://developer.apple.com/documentation/swiftui/
     https://www.youtube.com/watch?v=Va1Xeq04YxU&t=15559s
     https://www.instructables.com/Playing-Chess/
     https://github.com/exyte/PopupView
     https://github.com/willdale/SwiftUICharts
*/

import SwiftUI
import SwiftUICharts

struct BarChartView: View {
    let data: BarChartData
    
    var body: some View {
        BarChart(chartData: data)
            .touchOverlay(chartData: data)
            .xAxisGrid(chartData: data)
            .yAxisGrid(chartData: data)
            .xAxisLabels(chartData: data)
            .yAxisLabels(chartData: data, colourIndicator: .custom(colour: ColourStyle(colour: .red), size: 12))
            .extraYAxisLabels(chartData: data, colourIndicator: .style(size: 12))
            .headerBox(chartData: data)
            .id(data.id)
            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 400, maxHeight: 500, alignment: .center)
            .padding(.horizontal)
    }
}

extension BarChartView {
    static func weekOfData() -> BarChartData {
        let data: BarDataSet =
            BarDataSet(dataPoints: [
                BarChartDataPoint(value: 200, xAxisLabel: "Laptops"   , description: "Laptops"   , colour: ColourStyle(colour: .purple)),
                BarChartDataPoint(value: 90 , xAxisLabel: "Desktops"  , description: "Desktops"  , colour: ColourStyle(colour: .blue)),
                BarChartDataPoint(value: 700, xAxisLabel: "Phones"    , description: "Phones"    , colour: ColourStyle(colour: .green)),
                BarChartDataPoint(value: 175, xAxisLabel: "Tablets"   , description: "Tablets"   , colour: ColourStyle(colour: .yellow)),
                BarChartDataPoint(value: 60 , xAxisLabel: "Watches"   , description: "Watches"   , colour: ColourStyle(colour: .yellow)),
                BarChartDataPoint(value: 100, xAxisLabel: "Monitors"  , description: "Monitors"  , colour: ColourStyle(colour: .orange)),
                BarChartDataPoint(value: 600, xAxisLabel: "Headphones", description: "Headphones", colour: ColourStyle(colour: .red))
            ],
            legendTitle: "Data")

        let metadata = ChartMetadata(title: "Units Sold", subtitle: "Last year")

        let gridStyle = GridStyle(numberOfLines: 7,
                                   lineColour: Color(.lightGray).opacity(0.25),
                                   lineWidth: 1)

        let chartStyle = BarChartStyle(infoBoxPlacement: .header,
                                       markerType: .bottomLeading(),
                                       xAxisGridStyle: gridStyle,
                                       xAxisLabelPosition: .bottom,
                                       xAxisLabelsFrom: .dataPoint(rotation: .degrees(-90)),
                                       xAxisTitle: "Categories",
                                       yAxisGridStyle: gridStyle,
                                       yAxisLabelPosition: .leading,
                                       yAxisNumberOfLabels: 5,
                                       yAxisTitle: "Units sold (x 1000)",
                                       baseline: .zero,
                                       topLine: .maximumValue)

        return BarChartData(dataSets: data,
                            metadata: metadata,
                            xAxisLabels: ["One", "Two", "Three"],
                            barStyle: BarStyle(barWidth: 0.5,
                                               cornerRadius: CornerRadius(top: 50, bottom: 0),
                                               colourFrom: .dataPoints,
                                               colour: ColourStyle(colour: .blue)),
                            chartStyle: chartStyle)
    }
}

#Preview {
    BarChartView(data: BarChartView.weekOfData())
        .environment(ModelData.previewModelData)
}
