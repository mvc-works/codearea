
// import coffeescript from 'rollup-plugin-coffee-script';
import coffee from "vite-plugin-coffee";

export default {
  plugins: [
    coffee({
      // Set to true if you use react
      jsx: false,
    }),
  ]
}
