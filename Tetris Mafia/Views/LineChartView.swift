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
import Combine

struct LineChartView: View {
    @Environment(ModelData.self) var modelData
    
//    let data: LineChartData = weekOfData()
    let data: LineChartData
    
    var body: some View {
        LineChart(chartData: data)
//            .extraLine(chartData: data,
//                       legendTitle: "Test",
//                       datapoints: extraLineData,
//                       style: extraLineStyle)
            .pointMarkers(chartData: data)
            .touchOverlay(chartData: data,
                          formatter: numberFormatter)
//            .yAxisPOI(chartData: data,
//                      markerName: "Step Count Aim",
//                      markerValue: 15_000,
//                      labelPosition: .center(specifier: "%.0f",
//                                             formatter: numberFormatter),
//                      labelColour: Color.black,
//                      labelBackground: Color(red: 1.0, green: 0.75, blue: 0.25),
//                      lineColour: Color(red: 1.0, green: 0.75, blue: 0.25),
//                      strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
//            .yAxisPOI(chartData: data,
//                      markerName: "Minimum Recommended",
//                      markerValue: 10_000,
//                      labelPosition: .center(specifier: "%.0f",
//                                             formatter: numberFormatter),
//                      labelColour: Color.white,
//                      labelBackground: Color(red: 0.25, green: 0.75, blue: 1.0),
//                      lineColour: Color(red: 0.25, green: 0.75, blue: 1.0),
//                      strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
//            .xAxisPOI(chartData: data,
//                      markerName: "Worst",
//                      markerValue: 2,
//                      dataPointCount: data.dataSets.dataPoints.count,
//                      lineColour: .red)
            .averageLine(chartData: data,
                         labelPosition: .yAxis(specifier: "",
                                               formatter: numberFormatter),
                         strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
            .xAxisGrid(chartData: data)
            .yAxisGrid(chartData: data)
            .xAxisLabels(chartData: data)
            .yAxisLabels(chartData: data,
                         formatter: numberFormatter,
                         colourIndicator: .style(size: 12))
            .extraYAxisLabels(chartData: data, colourIndicator: .style(size: 12))
            .infoBox(chartData: data, height: 60)
            .headerBox(chartData: data)
            .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
            .id(data.id)
            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
            .padding(.horizontal)
            
//            .navigationTitle("Week of Data")
            .customFont(modelData.appConfig.appFontRegular, size: 24)
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}


extension LineChartView {
    static func weekOfData() -> LineChartData {
        let data = LineDataSet(dataPoints: [
            LineChartDataPoint(value: 12000, xAxisLabel: "M", description: "Monday"   ),
            LineChartDataPoint(value: 10000, xAxisLabel: "T", description: "Tuesday"  ),
            LineChartDataPoint(value: 8000 , xAxisLabel: "W", description: "Wednesday"),
            LineChartDataPoint(value: 17500, xAxisLabel: "T", description: "Thursday" ),
            LineChartDataPoint(value: 16000, xAxisLabel: "F", description: "Friday"   ),
            LineChartDataPoint(value: 11000, xAxisLabel: "S", description: "Saturday" ),
            LineChartDataPoint(value: 9000 , xAxisLabel: "S", description: "Sunday"   ),
        ],
        legendTitle: "Steps",
        pointStyle: PointStyle(),
        style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine))
        
        let gridStyle = GridStyle(numberOfLines: 7,
                                   lineColour   : Color(.lightGray).opacity(0.5),
                                   lineWidth    : 1,
                                   dash         : [8],
                                   dashPhase    : 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false),
                                        infoBoxContentAlignment: .vertical,
                                        infoBoxBorderColour : Color.primary,
                                        infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                        
                                        markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        
                                        xAxisGridStyle      : gridStyle,
                                        xAxisLabelPosition  : .bottom,
                                        xAxisLabelColour    : Color.primary,
                                        xAxisLabelsFrom     : .dataPoint(rotation: .degrees(0)),
                                        xAxisTitle          : "xAxisTitle",
                                        
                                        yAxisGridStyle      : gridStyle,
                                        yAxisLabelPosition  : .leading,
                                        yAxisLabelColour    : Color.primary,
                                        yAxisNumberOfLabels : 7,
                                        
                                        baseline            : .minimumWithMaximum(of: 5000),
                                        topLine             : .maximum(of: 20000),
                                        
                                        globalAnimation     : .easeOut(duration: 1))
        
        
        
        let chartData = LineChartData(dataSets       : data,
                                      metadata       : ChartMetadata(title: "", subtitle: ""),
                                      chartStyle     : chartStyle)
        
        defer {
            chartData.touchedDataPointPublisher
                .map(\.value)
                .sink { value in
                    var dotStyle: DotStyle
                    if value < 10_000 {
                        dotStyle = DotStyle(fillColour: .red)
                    } else if value >= 10_000 && value <= 15_000 {
                        dotStyle = DotStyle(fillColour: .blue)
                    } else {
                        dotStyle = DotStyle(fillColour: .green)
                    }
                    withAnimation(.linear(duration: 0.5)) {
                        chartData.chartStyle.markerType = .vertical(attachment: .line(dot: .style(dotStyle)))
                    }
                }
                .store(in: &chartData.subscription)
        }
        
        return chartData
    }
}



#Preview {
    LineChartView(data: LineChartView.weekOfData())
        .environment(ModelData.previewModelData)
}
