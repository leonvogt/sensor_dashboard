let postcss = require('postcss')

module.exports = {
  plugins: [
    {
      postcssPlugin: 'grouped',
      Once(root, { result }) {
        return postcss([
          require('postcss-import'),
          require('postcss-mixins'),
          require('postcss-simple-vars'),
          require("postcss-import"),
          require("postcss-advanced-variables"),
          require("tailwindcss/nesting"),
          require("tailwindcss")("./app/javascript/tailwind.config.js"),
          require("autoprefixer"),
        ]).process(root, result.opts)
      },
    },
    require('tailwindcss'),
    require('postcss-nested'),
    require('autoprefixer'),
  ],
}
