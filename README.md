0xProxy is a project by anftw. Please visit our [website](http://www.anftw.com/) or [Twitter](https://twitter.com/anftw_com) for further information about our work.

# 0xProxy background

0xProxy was created after a 'call-for-submissions' by [Zeneca33](https://twitter.com/Zeneca_33) following their reading of a [Medium post](https://medium.com/@tohbee.eth/usership-for-nfts-in-web3-proposal-by-tohbee-eth-d00488fd7eca) by [Tohbee.eth](https://twitter.com/tohbee_eth) that described a smart contract that points one address to another in order to verifiably prove that Wallet A also owns Wallet B and the contents. We liked the idea and welcomed the opportunity to work with these two and so set about creating it.

The contract was quickly written and tested. What became quickly apparent is that the primary challenge of such a project would be to:

 1. Achieve adoption by project developers and;
 2. Create a UX in which users understand how it works and the limitations

# How 0xProxy works

This contract creates proxy wallets from your existing hot or cold wallet using a tiny amount of gas. It allows users to prove that they own a token, without necessarily needing to expose the actual wallet that owns it to a website, contract or any other entity. The whole point of the resulting proxy wallet is that it's essentially worthless and doesn't hold anything that can be stolen.

# How to use 0xProxy

The contract is currently stored at [0x154AF254E6c3c914deF6b70114A5A3C77534833C](https://etherscan.io/address/0x154AF254E6c3c914deF6b70114A5A3C77534833C#code) which you can interact with directly.

We will soon be launching 0xProxy.com which will provide an interface from which you can create and manage your proxy wallets.

As a developer building a project that inspects a wallet's contents to see whether the user should be granted access, all you need to do is make a single additional call to this contract address to see whether the connecting wallet is actually a proxy wallet that provably owns the tokens you are looking for. We will be providing an example call on our website.

# Example use cases

 - Login to token-gated communities, without needing to connect the valuable wallet that holds the necessary token.
 - Mint projects that require you to hold another token, without needing to expose that token 
 - Prove ownership of tokens in real life, without needing to carry your real wallet with you. Coming soon to a 0xProxy app.

All of the above require participation from the project you are looking to engage with. You should encourage them to do so as it's a basic responsibility of founders to enable maximum security for their users.

