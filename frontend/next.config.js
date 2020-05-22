// alters the webpack config to ignore test.ts files in build
// https://github.com/zeit/next.js/issues/1914
module.exports = {
  webpack: (config, { dev }) => {
    config.module.rules.push({
      test: /\.test.ts$/,
      loader: "ignore-loader",
    });
    return config;
  },
};
