import Chartkick from "chartkick";
import Chart from "chart.js";

Chartkick.use(Chart);

let Hooks = {};

Hooks.Chart = {
  lastData() {
    return JSON.parse(this.el.dataset.historical);
  },
  createChart(data) {
    return new Chartkick.LineChart("chart", data, {
      messages: { empty: "No data" },
    });
  },
  mounted() {
    let historical = JSON.parse(this.el.dataset.historical);
    console.log(historical);
    this.chart = this.createChart(historical);
  },
  updated() {
    let data = this.lastData();
    this.chart.updateData(data);
  },
};

Hooks.BalanceChart = {
  lastData() {
    return JSON.parse(this.el.dataset.balances);
  },
  sortData(data) {
    let newData = {}
    data.hour_range.forEach((hr) => {
      newData[`${hr}:00`] = data[hr]
    })
    return newData
  },
  createChart(data) {
    let sortedData = this.sortData(data);
    return new Chartkick.LineChart("balance-chart", sortedData, {
      messages: { empty: "No data" },
      label: "Portfolio Balance",
      curve: false,
    });
  },
  mounted() {
    let balances = JSON.parse(this.el.dataset.balances);
    this.chart = this.createChart(balances);
  },
  updated() {
    let data = this.sortedData(this.lastData());
    this.chart.updateData(data);
  },
};

export default Hooks;
