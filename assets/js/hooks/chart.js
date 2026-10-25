import * as echarts from "echarts"

const radius = "60%"

const Chart = {
  mounted() {
    const chart = echarts.init(this.el)
    const chartData = JSON.parse(this.el.dataset.chartData)

    const option = {
      polar: {
        radius: radius
      },
      radiusAxis: {
        type: "value",
        axisLine: { show: false },
        axisTick: { show: false },
        axisLabel: { show: false },
        min: 0,
        max: 10,
        interval: 1,
        splitLine: {
          show: true,
          lineStyle: {
            color: "#ddd",
            type: "dashed"
          }
        }
      },
      angleAxis: {
        type: "category",
        data: [
          "family",
          "emotional",
          "social",
          "spiritual",
          "educational",
          "physical",
          "career",
          "financial"
        ],
        axisLine: { show: false },
        axisTick: { show: false },
        axisLabel: { show: false }
      },
      series: [
        {
          type: "pie",
          roseType: "area",
          radius: radius,
          data: chartData
        },
        {
          // Hidden series just to set the scale
          type: "pie",
          roseType: "area",
          radius: radius,
          silent: true, // Disable interactions
          itemStyle: {
            opacity: 0 // Make it invisible
          },
          label: {
            show: false
          },
          data: [{ name: "scale", value: 10 }]
        }
      ]
    }

    console.log(JSON.stringify(option))

    chart.setOption(option)
  }
}

export default Chart
