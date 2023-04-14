import '@nomicfoundation/hardhat-toolbox';

module.exports = {
  networks: {
    hardhat: {

    },
  },
  solidity: {
      compilers: [
        {
          version: "0.4.25",
          settings: {
            optimizer: {
              enabled: true,
              runs: 7777
            }
          }
        },
        {
          version: "0.8.19",
          settings: {
            optimizer: {
              enabled: true,
              runs: 7777
            }
          }
        },
      ],
  },
  gasReporter: {
    enabled: true
  }
};
