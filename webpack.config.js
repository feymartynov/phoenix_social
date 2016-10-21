'use strict';

var path = require('path');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var webpack = require('webpack');

function join(dest) {
  return path.resolve(__dirname, dest);
}

function web(dest) {
  return join('frontend/' + dest);
}

var config = module.exports = {
  entry: {
    application: [
      'bootstrap-loader',
      web('css/application.sass'),
      web('js/application.js')
    ]
  },
  output: {
    path: join('priv/static'),
    filename: 'js/application.js'
  },
  resolve: {
    extensions: ['', '.js', '.sass'],
    moduleDirectories: ['node_modules']
  },
  module: {
    noParse: /vendor\/phoenix/,
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          cacheDirectory: true,
          presets: ['react', 'es2015', 'stage-2', 'stage-0']
        }
      },
      {
        test: /\.sass$/,
        loader: ExtractTextPlugin.extract(
          'style',
          'css!sass?indentedSyntax&includePath[]=' +
          __dirname +
          '/node_modules')
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: "url-loader?limit=10000&mimetype=application/font-woff"
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: "file-loader"
      },
      {
        test:/bootstrap-sass[\/\\]assets[\/\\]javascripts[\/\\]/,
        loader: 'imports?jQuery=jquery'
      },
    ]
  },
  plugins: [
    new ExtractTextPlugin('css/application.css')
  ]
};

if (process.env.NODE_ENV === 'production') {
  config.plugins.push(
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin({minimize: true})
  );
}
