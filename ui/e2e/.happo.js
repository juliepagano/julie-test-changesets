const { RemoteBrowserTarget } = require('happo.io');
const happoPluginTypescript = require('happo-plugin-typescript');

require('dotenv').config();

module.exports = {
  apiKey: process.env.HAPPO_API_KEY,
  apiSecret: process.env.HAPPO_API_SECRET,

  targets: {
    'chrome-desktop': new RemoteBrowserTarget('chrome', {
      viewport: '1024x768',
    }),
  },
  plugins: [
    happoPluginTypescript(),
  ],
};