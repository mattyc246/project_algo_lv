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
    this.chart = this.createChart(historical);
  },
  updated() {
    let data = this.lastData();
    this.chart.updateData(data);
  },
};

export default Hooks;
