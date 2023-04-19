## Solidity fuzzing with Echidna

### Solving 3 different CTFs (Capture the flag security challenges) using echidna

### CTF 1:
Find a way to accumulate at least 1,000,000 tokens of the Token contract to solve this challenge.  
https://capturetheether.com/challenges/math/token-whale/

### CTF 2:
This token contract allows you to buy and sell tokens at an even exchange rate of 1 token per ether.  
Find a way to steal some tokens of the contract balance.  
https://capturetheether.com/challenges/math/token-sale/

### CTF 3:
The user has to drain all of at least one of the two tokens - token1 and token2 from a DEX contract.  
https://blog.dixitaditya.com/ethernaut-level-22-dex

### Configuration

To run the fuzz tests, you'll need to have the correct version of solc and echidna installed.  

Install echidna on MacOS using:  
`brew install echidna`  

Install solc using:  
`npm install -g solc`  

Install solc-select using:  
`pip3 install solc-select`  

Install solc 0.4.25 and 0.8.19:  
`solc-select install 0.4.25`  
`solc-select install 0.8.19`  

To run the first two CTFs:  
`npm run ctf1`  
`npm run ctf2`  

To run the 3rd CTF:  
`npm run ctf3`  