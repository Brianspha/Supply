module.exports = {
  default: {
    enabled: false,
    ipfs_bin: "ipfs",
    provider: "ipfs",
    available_providers: ["ipfs"],
    upload: {
      host: "localhost",
      port: 5001
    },
    dappConnection: [
      {
        provider: "ipfs",
        host: "localhost",
        port: 5001,
        getUrl: "http://localhost:8080/ipfs/"
      }
    ]
    // Configuration to start Swarm in the same terminal as `embark run`
    /*,account: {
      address: "YOUR_ACCOUNT_ADDRESS", // Address of account accessing Swarm
      password: "PATH/TO/PASSWORD/FILE" // File containing the password of the account
    },
    swarmPath: "PATH/TO/SWARM/EXECUTABLE" // Path to swarm executable (default: swarm)*/
  },
  development: {
    enabled: false,
    provider: "ipfs",
    upload: {
      host: "localhost",
      port: 5001,
      getUrl: "http://localhost:8080/ipfs/"
    }
  }
};
